#!/bin/bash

## questo script crea le cartelle custom necessarie al funzionamento di alcune parti del framework
#
# NOTA dopo aver lanciato questo script, eseguire _lamp.permission.secure.sh
#
#

## pulizia schermo
clear

## livelli per la root del sito
RL="../../"

## directory corrente
cd $(dirname "$0")

## funzioni
. ./_lib/_functions.sh

## verifica utente root
check-root

## directory di lavoro
cd $RL

## informazioni
echo "lavoro su: $(pwd)"

## cartella dei log
mkdir -p ./var/log/details

## cartella dei file temporanei
mkdir -p ./tmp

## cartelle delle cache
mkdir -p ./var/cache/pages
mkdir -p ./var/cache/twig

## cartelle di spool
mkdir -p ./var/spool/export
mkdir -p ./var/spool/import/done
mkdir -p ./var/spool/import/todo
mkdir -p ./var/spool/security

## cartelle dei templates
mkdir -p ./src/templates
