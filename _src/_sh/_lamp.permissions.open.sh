#!/bin/bash

## questo file setta i permessi della document root in modalità aperta (installazione)
#
# NOTA dopo aver terminato l'installazione, eseguire _lamp.permission.secure.sh
#
# TODO documentare questo script
#

## pulizia schermo
clear

## livelli per la root del sito
# NOTA questo script deve girare nella cartella SUPERIORE a quella di installazione!
RL="../../../"

## directory corrente
cd $(dirname "$0")
cd $RL

## informazioni
echo "lavoro su: $(pwd)"

## cambio permessi (silenzioso)
find . -type d        -not \( -path ".git" -prune \) -exec chmod 775 {} \;
find . -type f        -not \( -path ".git" -prune \) -exec chmod 664 {} \;
find . -name '*.sh'    -not \( -path ".git" -prune \) -exec chmod 775 {} \;

## cambio proprietario
sudo chown -R www-data:www-data *
