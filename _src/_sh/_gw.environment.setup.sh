#!/bin/bash

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

## installazione di memcache
apt-get install -y memcached
apt-get install -y php-memcache

## installazione di redis
apt-get install -y redis-server
apt-get install -y php-redis

## installazione di php-zip
apt-get install -y php-zip

## installazione di certbot
apt-get install -y python-certbot-apache

## aggiorno composer
composer update

## permessi
_src/_sh/_gw.permissions.reset.sh
