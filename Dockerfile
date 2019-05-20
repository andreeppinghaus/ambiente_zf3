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

## criando os servicos de inicializacao
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

