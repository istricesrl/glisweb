#!/bin/bash

## pulizia schermo
clear

## livelli per la root del sito
RL="../../"

## directory corrente
cd $(dirname "$0")
cd $RL

## informazioni
echo "lavoro su: $(pwd)"

## installazione di Apache
apt-get install -y apache2

## attivazione del modulo rewrite
a2enmod rewrite

## attivazione del modulo expires
a2enmod expires

## attivazione del modulo headers
a2enmod headers

## installazione di PHP
apt-get install -y php

## installazione di composer
apt-get install -y composer

## installazione degli strumenti di sviluppo
apt-get install -y php-dev

## installazione di PEAR
apt-get install -y php-pear

## installazione di CURL
apt-get install -y php-curl

## installazione di SSH
apt-get install -y php-ssh2

## installazione di GD
apt-get install -y php-gd

## installazione libreria per xml
apt-get install -y php-xml

## installazione libreria per yaml
apt-get install -y php-yaml

## installazione libreria Tidy
apt-get install -y php-tidy

## installazione di memcache
apt-get install -y memcached
apt-get install -y php-memcache
apt-get install -y php-memcached

## installazione di redis
apt-get install -y redis-server
apt-get install -y php-redis

## installazione di php-zip
apt-get install -y php-zip

## installazione di php-intl
apt-get install -y php-intl

## attivazione modulo mysqlnd
phpenmod mysqlnd

## attivazione modulo tidy
phpenmod tidy

## installazione di Pear FTP
pear install Net_FTP

## installazione di ncftp
apt-get install -y ncftp

## installazione di mysql
apt-get install -y default-mysql-server

## installazione di adminer
apt-get install -y adminer
a2enconf adminer

## richiesta
echo -n "vuoi configurare automaticamente il sito di default su localhost (s/n)? "
read YN

## configurazione
if [ "$YN" = "s" ]; then
    a2dissite 000-default.conf
    cp _usr/_config/_apache2/default.http.conf /etc/apache2/sites-available/
    a2ensite default.http.conf
    service apache2 restart
fi

## password di root
read -s -p "inserisci la password per MySQL root (vuoto per saltare): " SRVPASS && echo
if [ -n "$SRVPASS" ]; then
#    sudo service mysql stop
#    sudo mkdir -p /var/run/mysqld
#    sudo chown mysql:mysql /var/run/mysqld
#    sudo mysqld_safe --skip-grant-tables &
#    sudo killall mysqld
#    sudo service mysql restart

# TODO verificare che lo faccia davvero
#     sudo mysql -u root mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$SRVPASS';"
#     sudo mysql -u root -p$SRVPASS mysql -e "FLUSH PRIVILEGES;"

fi

## installazione di certbot
apt-get install -y python3-certbot-apache

## riavvio di Apache
service apache2 restart

## aggiorno composer
composer update

## permessi
_src/_sh/_lamp.permissions.secure.sh

## fine script
echo "se necessario, riavviare la sessione o il computer per aggiornare i gruppi dell'utente corrente"
