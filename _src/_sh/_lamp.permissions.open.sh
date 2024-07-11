#!/bin/bash

## questo file setta i permessi della document root in modalità aperta (installazione)
#
# NOTA dopo aver terminato l'installazione, eseguire _lamp.permission.secure.sh
#
# TODO documentare
# questo script è un buon posto dove mettere la documentazione su come GlisWeb gestisce i permessi
#

## pulizia schermo
clear

## livelli per la root del sito
# NOTA questo script deve girare nella cartella SUPERIORE a quella di installazione!
RL="../../"
RP="../"

## directory corrente
cd $(dirname "$0")

## funzioni
. ./_lib/_functions.sh

## verifica utente root
check-root

## passo alla cartella del deploy
cd $RL

## ricaavo il nome del deploy
SUB=$( basename $( pwd ) )

## passo alla cartella principale
cd $RP

## informazioni
echo "lavoro su: $(pwd)"

## cambio permessi (silenzioso)
find . -type d          -not \( -path ".git" -prune \)      -exec chmod 775 {} \;
find . -type f          -not \( -path ".git" -prune \)      -exec chmod 664 {} \;
find . -name '*.sh'     -not \( -path ".git" -prune \)      -exec chmod 775 {} \;

## cambio proprietario
sudo chown -R www-data:www-data *
