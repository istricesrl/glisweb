#!/bin/bash

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

## nome del file di backup
BKFILE="backup.$( date +%Y%m%d%H%M%S ).tar.gz"

## file e directory da escludere
EXCLUDE=".git .github _src/_lib/_ext _usr/_docs/_html _usr/_docs/_pdf tmp var/log var/cache var/spool"

# compongo la stringa di esclusione
for i in $EXCLUDE; do
    EXC="$EXC --exclude=./$SUB/$i"
done

## comando di backup
BKCMD="tar $EXC -cvzf $BKFILE ./$SUB"

# informazioni
echo "eseguo: $BKCMD"

# eseguo il backup
$BKCMD

## NOTE
#
# affinché l'opzione --exclude di tar funzioni, il percorso della cartella da comprimere e quello delle cartelle
# da escludere devono essere entrambi relativi o entrambi assoluti, altrimenti tar non riesce a fare il match
#
