#!/bin/bash

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

## argomenti
check-args $@

## se lo script è stato chiamato senza argomenti
if [ -n "$PNOARGS" ]; then

    echo "utilizzo: $0 target [opzioni]"
    echo "opzioni:"
    echo "  --soft   esegue semplicemente composer update"
    echo "  --hard   pulisce la cache e la cartella vendor e poi esegue composer update"
    exit 1

else

    ## passo alla cartella del deploy
    cd $RL

    ## modalità
    if [ -n "$PARGHARD" ]; then

        # elimino le librerie esterne
        rm -rf ./_src/_lib/_ext

        # elimino il file composer.lock
        rm -f ./composer.lock

        # svuoto la cache di composer
        composer clearcache

    fi

    ## aggiorno composer
    composer update

fi

## uscita
exit 0
