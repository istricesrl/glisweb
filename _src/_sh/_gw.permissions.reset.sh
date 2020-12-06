#!/bin/bash

## pulizia schermo
clear

## livelli per la root del sito
# NOTA questo script deve girare nella cartella SUPERIORE a quella
# di installazione!
RL="../../../"

## directory corrente
cd $(dirname "$0")
cd $RL

## informazioni
echo "lavoro su: $(pwd)"

## cambio permessi
find . -type d		-not \( -path ".git" -prune \)		-exec echo {} \; -exec chmod 775 {} \;
find . -type f		-not \( -path ".git" -prune \)		-exec echo {} \; -exec chmod 664 {} \;
find . -name '*.sh'	-not \( -path ".git" -prune \)		-exec echo {} \; -exec chmod 775 {} \;

## cambio proprietario
chown -R www-data:www-data *
