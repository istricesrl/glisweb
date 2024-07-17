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

    echo "utilizzo: $0 [opzioni]"
    echo "opzioni:"
    echo "  --soft      elimina i log, i file temporanei e le cache"
    echo "  --hard      elimina i log, i file temporanei, e sitemap, le cache e i file in spool"
    exit 1

else

    ## passo alla cartella del deploy
    cd $RL

    ## informazioni
    echo "lavoro su: $(pwd)"

    ## elimino i log
    if [ -d ./var/log ]; then
        rm -rf ./var/log/*
    fi

    ## elimino le cache
    if [ -d ./var/cache ]; then
        rm -rf ./var/cache/*
    fi

    ## elimino i file temporanei
    if [ -d ./tmp ]; then
        rm -rf ./tmp/*
    fi

    ## modalità hard
    if [ -n "$PARGHARD" ]; then

        ## avviso
        echo "modalità hard!"

        ## elimino la spool
        if [ -d ./var/spool ]; then
            rm -rf ./var/spool/*
        fi

        ## elimino le sitemap
        if [ -d ./var/sitemap ]; then
            rm -rf ./var/sitemap/*
        fi

    fi

    ## ripristino cartelle
    ./_src/_sh/_gw.check.folders.sh

    ## ripristino permessi
    ./_src/_sh/_lamp.permissions.secure.sh

fi

## debug
# echo "$0, $1, $2, $3, $4, $5, $6, $7, $8, $9"

## uscita
exit 0
