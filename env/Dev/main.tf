module "aws-dev" {
    source = "../../infra"            # caminho onde tera o arquivo com as variaveis de ambiente
    instancia = "t2.micro"
    regiao_aws = "us-west-2"
    chave = "Iac-DEV"
    grupoDeSeguranca = "Dev"
    minimo = 0
    maximo = 1
    nomeGrupo = "Dev"
    Producao = false
}