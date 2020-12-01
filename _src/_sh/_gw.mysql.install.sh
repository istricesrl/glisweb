#!/bin/bash

## livelli per la root del sito
RL="../../"

## directory corrente
cd $(dirname "$0")
cd $RL

## informazioni
echo "lavoro su: $(pwd)"

FILE1="_usr/_database/mysql.schema.sql"
FILE2="_usr/_database/mysql.data.sql"

clear

## se il file su cui lavorare è specificato
if [ -f "$FILE1" -a -f "$FILE2" ]; then

    read -p "indirizzo del server: " SRVADDR

    read -p "porta del server: " SRVPORT

    read -p "nome utente: " SRVUSER

    read -p "password: " SRVPASS

    read -p "database: " SRVDBNAME

    if [ -n "$SRVPASS" ]; then
        PASSC="-p$SRVPASS"
    fi

    mysql -h $SRVADDR -u $SRVUSER $PASSC $SRVDBNAME < $FILE1
    mysql -h $SRVADDR -u $SRVUSER $PASSC $SRVDBNAME < $FILE2

    mkdir -p usr/database/
    cp _usr/_database/mysql.schema.version usr/database/mysql.schema.version

fi
