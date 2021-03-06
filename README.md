# Ambiente de desenvolvimento em PHP-7 e Zend Framework 3


O Zend é um Framework desenvolvido pela empresa Zend(http://www.zend.com/) para criação de sistemas Web.

Atualmente o Zend Framework está versão 3.0 e, na criação deste repositório (20/05/2019), está sendo transferido para ser um projeto oficial da Linux Foundation com o novo nome Laminas (https://getlaminas.org/).

# Ambiente utilizando Docker
Para uma nova imagem, crie um arquivo chamado Dockerfile em uma pasta com o seguite conteúdo:

FROM alpine

RUN apk update 
RUN apk add apache2
RUN apk add php7-apache2
RUN apk add php7-pdo php7-pdo_mysql php7-pdo_pgsql postgresql sudo
RUN apk add openssh

##configurando o php-7
RUN echo "display_errors = On">> /etc/php7/php.ini


##configurando a inicializacao do postgres
RUN mkdir /run/postgresql
RUN chown postgres.postgres /run/postgresql/

##criando os servicos de inicializacao
#instala o services
RUN apk add openrc --no-cache

##adicina os servicos
#RUN rc-update add postgresql 
RUN rc-update add sshd 
#RUN rc-update add apache2
RUN rc-status
RUN touch /run/openrc/softlevel
#RUN rc-service postgresql start
#RUN rc-service postgresql stop

##inicializando postgres
RUN sudo su - postgres -c "initdb -D data --auth-local=trust --auth-host=trust"

##liberando o acesso via tcpip
RUN echo "listen_addresses = '*' " >> /var/lib/postgresql/data/postgresql.conf
RUN echo "host    all     all             0.0.0.0/0                 trust" >> /var/lib/postgresql/data/pg_hba.conf

RUN echo '#!/bin/sh' >>/start.sh
RUN echo '/usr/sbin/httpd -f /etc/apache2/httpd.conf -DFOREGROUND &' >>/start.sh
RUN echo 'rc-service sshd start 2>/dev/null' >>/start.sh
RUN echo 'sudo su - postgres -c "postgres -D /var/lib/postgresql/data >logfile 2>&1" ' >>/start.sh


RUN chmod +x /start.sh

EXPOSE 80

##Roda o script para inicializacao dos servicos
CMD ["/start.sh"]

##Fim de arquivo



Com o docker devidamente instalado, no shell de comnandos do seu sistema operacional digite os seguintes comandos, com o ponto (.) no final:

sudo docker build -t suaimagem .


Verifique as imagens no seu docker:

sudo docker images

Rode a imagem
sudo docker run -it suaimagem 

Acesso via navegador:

Abra um navegador e digite o ip : http://172.17.0.2

Acesso via postgres acessando 

sudo su - postgres

psql -h 172.17.0.2

# Ambiente com uma maquina virtual Linux

Este ambiente é um Linux Fedora 30 com todo ambiente de desenvolvimento instalado e configurado para trabalhar com o Zend Framework 3.

Usuários:
Usuário Admin
Login: admin
Senha: admin

Usuário Postgres do banco de dados PostgreSQL
Login: postgres
Senha: postgres

Softwares instalados:
Firefox;
Chrome;
Eclipse-PDT para desenvolvimento em PHP
pgAdmin 3 para acesso ao banco de dados postgres
composer para adicionar pacotes no Zend 3


Arquivo do virtualbox fedora30.vdi
