#!/bin/bash

## pulizia schermo
clear

## livelli per la root del sito
RL="../../"

## directory corrente
cd $(dirname "$0")
cd $RL

## informazioni
echo "lavoro su: $(pwd)"

## se è specificata la cartella sorgente
if [ -n "$1" ]; then

    ## cartella di destinazione
    DSTDIR="usr/database/$1/"
    mkdir -p $DSTDIR

    ## file di destinazione
    FILE2=$DSTDIR"mysql.data.sql"

    ## se il file su cui lavorare è specificato
    if [ -f "$FILE2" ]; then

        read -p "indirizzo del server: " SRVADDR

        read -p "porta del server: " SRVPORT

        read -p "nome utente: " SRVUSER

        read -s -p "password: " SRVPASS && echo

        read -p "database: " SRVDBNAME

        mysql -h $SRVADDR -u $SRVUSER -p$SRVPASS $SRVDBNAME < $FILE2

    else

        echo "cartella non trovata"

    fi

else

    echo "$0 nomeCartella"

fi
