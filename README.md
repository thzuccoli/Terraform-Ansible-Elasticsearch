# Resumo do projeto

Projeto utilizando Terraform para provisionamento, Ansible para as configurações e dependências, e AWS como provedor da infraestrutura.

## 🔨 Funcionalidades do projeto

A partir desse projeto você pode:

- Criar maquinas virtuais na EC2
- Separar o seu codigo em 2 ambientes, um de produção e um de desenvolvimento
- configurar as maquinas para executar uma API em Django automaticamente
- preparar uma infraestrutura elastica
- criar um Load Balancer para a sua aplicação

## ✔️ Técnicas e tecnologias utilizadas

Neste App são exploradas as seguintes técnicas e tecnologias:

- **Criação de maquinas na EC2**: criação de maquinas virtuias no ambiente EC2 (Elastic Compute Cloud) da AWS (/infra/main.tf)
- **Configuração das maquinas**: configura as maquinas de forma automatica ultilizando o Ansible 
- **Criação de playbooks**: os playbooks são parte integral do ansible e descrevem quais os passos a serem seguidos (/env/prod/playbook.yml)
- **Separação de ambientes**: 2 ambientes separados, construidos de forma automatica pelo Terraform, reultilizando codigo.
- **Execução de APIs**: como iniciar um API automaticamente apos a configuração da maquina
- **Criação do load balancer**: o load balancer é um programa ultilziado para distribuir requisições entre multiplas maquinas

## 🛠️ Abrir e rodar o projeto

O projeto foi desenvolvido no VSC (Visual Studio Code), sendo assim, instale o VSC (pode ser uma versão mais recente) e, na tela inicial, procure a opção extenções, ou aperte Ctrl+Shift+X, e busque por HashiCorp Terraform, assim teremos o suporte do intellisense, tornando o trabalho de escrever o código mais rapido.

> Caso baixou o zip, extraia o projeto antes de procurá-lo, pois não é possível abrir via arquivo zip

Vá até a paste a abra a pasta do projeto. Apos abrir o projeto abra um terminal, pode ser o integrado com o VSC, navegue até as pastas `infra/`,`env/Prod` e `env/DEV` e execute o comando `terraform init` dentro delas, agora temos o terraform iniciado e podemos começar a ultiliza-lo. Para criar a infraestrutura, execute o terraform apply em uma das pastas de Produção (`env/Prod`) ou de Desenvolvimento (`env/DEV`) de acordo com o ambiente desejado.🏆

