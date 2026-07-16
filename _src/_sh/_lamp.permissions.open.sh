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
# NOTA il perimetro è la cartella del deploy (./$SUB/), come in _lamp.permissions.secure.sh: lavorare
# su tutta la cartella principale significherebbe ciclare anche sui backup e su quanto altro le sta
# accanto. NOTA i find usano -exec + (un solo chmod ogni N file) e non -exec \; (un chmod per file):
# su un albero da centinaia di migliaia di file la differenza è fra secondi e ore.
find ./$SUB/            -path "./$SUB/.git" -prune  -o -type d       -exec chmod 775 {} +
find ./$SUB/            -path "./$SUB/.git" -prune  -o -type f       -exec chmod 664 {} +
find ./$SUB/            -path "./$SUB/.git" -prune  -o -name '*.sh'  -exec chmod 775 {} +

## cambio proprietario
chown -R www-data:www-data ./$SUB/
