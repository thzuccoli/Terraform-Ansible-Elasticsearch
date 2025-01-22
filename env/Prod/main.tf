module "aws-prod" {
    source = "../../infra"            # caminho onde tera o arquivo com as variaveis de ambiente
    instancia = "t2.micro"
    regiao_aws = "us-west-2"
    chave = "IaC-PROD"
    grupoDeSeguranca = "Producao"
    minimo = 1
    maximo = 10
    nomeGrupo = "Producao"
    Producao = true
}