terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = var.regiao_aws             # região a ser criado o serviço
}

resource "aws_launch_template" "maquina" {             # recurso a ser utilizado para escalar as maquinas automaticamente
  image_id           = "ami-05d38da78ce859165"        # AMI da imagem a ser usada
  instance_type = var.instancia            # tipo da maquina
  key_name = var.chave
  tags = {
    Name = var.nomeGrupo      # nome da instancia
  }
  security_group_names = [ var.grupoDeSeguranca ]
  user_data = var.Producao ? filebase64("ansible.sh"): ""         # irá pegar o script e colocar numa base 64 para aws conseguir executa-lo
}

# significado da linha 24 (operador tenario)
# if(var.Producao) {     --> ser var.Producao for verdadeiro
#    filebase64("ansible.sh")
# }  else {
#     ""           --> se não for proucao, não importar nenhuma arquivo
# }

resource "aws_autoscaling_group" "grupo" {
  availability_zones = [ "${var.regiao_aws}a", "${var.regiao_aws}b"  ]
  name = var.nomeGrupo
  max_size = var.maximo
  min_size = var.minimo
  launch_template {           # configuração do launch template no autoscalling 
    id = aws_launch_template.maquina.id              
    version = "$Latest"
  }
  target_group_arns = var.Producao ? [ aws_lb_target_group.alvoLoadBalancer[0].arn ] : []   # alvo do lb no autoscalling group (inserir o 0 devido a config count e sempre o primeiro lb a ser criado)
}

resource "aws_default_subnet" "subnet_1" {        # recurso criação subnet devido a implantação do loadbalancer
  availability_zone = "${var.regiao_aws}a"
}

resource "aws_default_subnet" "subnet_2" {        # recurso criação subnet devido a implantação do loadbalancer
  availability_zone = "${var.regiao_aws}b"
}

resource "aws_lb" "loadbalancer" {      # recurso criação load balancer
  internal = false           # linha q define se o lb comunica com a internet ou não (false)
  subnets = [ aws_default_subnet.subnet_1.id, aws_default_subnet.subnet_2.id ]
  count = var.Producao ? 1 : 0
}
# no recurso acima precisamos definir qtos loadbalancer sera criado, inserindo 
# iremos definir caso for verdadeiro a variavel de produção (var.Producao), inserimos 1, falso 0

resource "aws_lb_target_group" "alvoLoadBalancer" {     # recurso de grupo de destino do lb (onde as requisições irão ser redirecionada)
  name = "MaquinasAlvo"
  port = "8000"
  protocol = "HTTP"
  vpc_id = aws_default_vpc.vpc.id
  count = var.Producao ? 1 : 0

}

resource "aws_default_vpc" "vpc" {
}

resource "aws_lb_listener" "entradaLoadBalancer" {
  load_balancer_arn = aws_lb.loadbalancer[0].arn  # inserir o 0 devido a config count e sempre o primeiro lb a ser criado)
  port = "8000"
  protocol = "HTTP"
  default_action {            # ação do que será feito quando receber as requisições
    type = "forward"          # ação de encaminhar as requisições para o grupo alvo
    target_group_arn = aws_lb_target_group.alvoLoadBalancer[0].arn
  }
  count = var.Producao ? 1 : 0
}

resource "aws_autoscaling_policy" "escala-Producao" {      
  name = "terraform-escala"
  autoscaling_group_name = var.nomeGrupo
  policy_type = "TargetTrackingScaling"            # politica de monitoramento atraves do consumo da CPU 
  target_tracking_configuration {            # configuração do alvo
    predefined_metric_specification {        # selecionando uma metrica pre definida (consumo de cpu já uma)
      predefined_metric_type = "ASGAverageCPUUtilization"     # tipo de metrica
    }
    target_value = 50.0           # consumo para aumentar a escalabilidade (acima de 50% CPU utilizada aumenta)
  }
  count = var.Producao ? 1 : 0
}  

resource "aws_key_pair" "chaveSSH" {       # recurso para utilizar uma chave ssh criada localmente na instancia da AWS
  key_name = var.chave
  public_key = file("${var.chave}.pub")    # acao de importar o arquivo com a chave
}
