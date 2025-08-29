#!/bin/bash

# TODO documentare
# questo script testa il sistema di importazione del framework
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

## passo alla cartella del deploy
cd $RL

## creo una cartella in /var/spool/import/todo con nome uguale alla data e ora corrente
IMPORTDIR=./var/spool/import
TODODIR=$IMPORTDIR/todo/$(date +%Y%m%d%H%M%S)
TODOFILE=$TODODIR/01.post.test.csv
IMPORTFILE=$IMPORTDIR/02.post.test.csv
mkdir -p $TODODIR

## creo un file csv di prova nella cartella todo
echo "id,nome" > $TODOFILE
echo "1,prova 1" >> $TODOFILE
echo "2,prova 2" >> $TODOFILE
echo "3,prova 3" >> $TODOFILE

## creo un file di prova nella cartella import
echo "id,nome" > $IMPORTFILE
echo "1,prova 1" >> $IMPORTFILE
echo "2,prova 2" >> $IMPORTFILE
echo "3,prova 3" >> $IMPORTFILE

## creo un file di immagine di prova nella cartella todo
# TODO

## creo un file di immagine di prova nella cartella import
# TODO

## aggiusto i permessi
chown -R www-data:www-data $TODODIR
