resource "aws_security_group" "acesso-geral" {
    name = var.grupoDeSeguranca
    ingress {
        cidr_blocks = [ "0.0.0.0/0" ]
        ipv6_cidr_blocks = [ "::/0" ]
        from_port = 0
        to_port = 0           # numero 0 indica todas as portas disponiveis
        protocol = "-1"       # -1 libera todos os protocolos
    }               # regras de entrada para toda internet
    egress {
        cidr_blocks = [ "0.0.0.0/0" ]
        ipv6_cidr_blocks = [ "::/0" ]
        from_port = 0
        to_port = 0           # numero 0 indica todas as portas disponiveis
        protocol = "-1" 
    }                # regras de saida
    tags = {
        Name = var.grupoDeSeguranca
    }
}