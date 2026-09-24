#!/bin/bash

# TODO documentare
# documentare tutto il processo di setup del framework
#
# TODO aggiornare guardando cosa fa lo script va.lamp.setup.sh
#

## pulizia schermo
clear

## livelli per la root del sito
RL="../../"

## directory corrente
cd $(dirname "$0")
cd $RL

## aggiornamento del sistema
apt-get update
apt-get upgrade -y

## informazioni
echo "lavoro su: $(pwd)"

## installazione di apt-utils
apt-get install -y apt-utils

## installazione di midnight commander
apt-get install -y mc

## installazione libreria per yaml
apt-get install -y php-yaml

## installazione libreria Tidy
apt-get install -y php-tidy
