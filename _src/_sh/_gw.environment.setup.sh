#!/bin/bash

## livelli per la root del sito
RL="../../"

## directory corrente
cd $(dirname "$0")
cd $RL

## informazioni
echo "lavoro su: $(pwd)"

## attivazione del modulo rewrite
a2enmod rewrite

## attivazione del modulo expires
a2enmod expires

## attivazione del modulo headers
a2enmod headers

## installazione di PHP
apt-get install php

## installazione di composer
apt-get install composer

## installazione degli strumenti di sviluppo
apt-get install php-dev

## installazione di PEAR
apt-get install php-pear

## installazione di CURL
apt-get install php-curl

## installazione di SSH
apt-get install php-ssh2

## installazione di GD
apt-get install php-gd

## installazione libreria per xml
apt-get install php-xml

## installazione di memcache
apt-get install memcached
apt-get install php-memcache

## installazione di redis
apt-get install redis-server
apt-get install php-redis

## installazione di php-zip
apt-get install php-zip

## installazione di certbot
apt-get install python-certbot-apache

## aggiorno composer
composer update
