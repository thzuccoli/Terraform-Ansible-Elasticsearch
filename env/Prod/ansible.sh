#!/bin/bash
chmod +x /home/thzuccoli/devops/iac-ansible-terraform/env/Prod/ansible.sh
sudo apt install ansible-core
sudo apt install pipx
pipx install --include-deps ansible
cd /home/ubuntu
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo apt update
sudo apt install -y python3 python3-pip
sudo python3 get-pip.py
tee -a playbook.yml > /dev/null <<EOT
- hosts: localhost             # hosts informado no arquivo hosts.yaml
  tasks:                               # tarefas
  - name: instalando o python3, vitualenv
    apt:         
      pkg:
      - python3
      - virtualenv
      - python3-pip
      update_cache: yes           # atualização dos repositorios
    become: yes          # ação de executar como usuario root

  - name: Git Clone                                      #nome da task a ser executada
    ansible.builtin.git:			       #ação de clonagem dentro do ansible
      repo: https://github.com/guilhermeonrails/clientes-leo-api.git        #repositório do GitHub a ser clonado 
      dest: /home/ubuntu/tcc                          #destino do clone referente ao código a ser implementado
      single_branch: yes
      version: master                               # branch do git a ser clonado
      force: yes                  # ação de forçar em sempre pegar a versão nova do codigo

  - name: instalando dependencias com pip (Django e Django Rest)
    pip:        # tarefa para instalação com pip
      virtualenv: /home/ubuntu/tcc/venv      # ação de criar a pasta tcc e virtualenv para instalação das dependencias
      requirements: /home/ubuntu/tcc/requirements.txt

  - name: Alterando o hosts do settings
    lineinfile:                                    # ação de alterar algo num arquivo de texto
      path: /home/ubuntu/tcc/setup/settings.py           # caminho do arquivo para alteração
      regexp: 'ALLOWED_HOSTS'            # informar a expressão que queremos trocar
      line: 'ALLOWED_HOSTS = ["*"]'      # informar a subsituição
      backrefs: yes             # ação caso não ache a expressão, não realizar ação nenhuma

  - name: Atualizando pip, setuptools e wheel
    pip:
      virtualenv: /home/ubuntu/tcc/venv
      name:
        - pip
        - setuptools
        - wheel
      state: latest

  - name: subindo a virtualvenv e configurando o banco de dados
    shell: . /home/ubuntu/tcc/venv/bin/activate; python /home/ubuntu/tcc/manage.py migrate

  - name: carregando os dados iniciais
    shell: . /home/ubuntu/tcc/venv/bin/activate; python /home/ubuntu/tcc/manage.py loaddata clientes.json

  - name: iniciando o servidor
    shell: . /home/ubuntu/tcc/venv/bin/activate; nohup python /home/ubuntu/tcc/manage.py runserver 0.0.0.0:8000 & 
EOT

chmod +x /home/ubuntu/playbook.yml

ansible-playbook playbook.yml 
