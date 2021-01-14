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

## cartella di destinazione
DSTDIR="usr/database/$(date '+%Y%m%d%H%M')/"
mkdir -p $DSTDIR

## file di destinazione
FILE1=$DSTDIR"mysql.schema.sql"
FILE2=$DSTDIR"mysql.data.sql"

## file temporaneo
FILEC=$FILE1".clean"

## se il file su cui lavorare è specificato
if [ -d "$DSTDIR" ]; then

    read -p "indirizzo del server: " SRVADDR

    read -p "porta del server: " SRVPORT

    read -p "nome utente: " SRVUSER

    read -p "password: " SRVPASS

    read -p "database: " SRVDBNAME

    mysqldump -h $SRVADDR -u $SRVUSER -p$SRVPASS --no-data --opt --routines --single-transaction --events $SRVDBNAME > $FILE1
    mysqldump -h $SRVADDR -u $SRVUSER -p$SRVPASS --no-create-info --opt --single-transaction $SRVDBNAME > $FILE2

    cat $FILE1 | sed -E 's/DEFINER=`[a-z]+`@`[a-z0-9\.%]+`/DEFINER=CURRENT_USER()/g' | sed 's/ AUTO_INCREMENT=[0-9]*\b//g' > $FILEC
	mv $FILEC $FILE1

else

    echo "cartella non trovata"

fi
