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
FILE2=$DSTDIR"mysql.data.sql"
FILE3=$DSTDIR"mysql.schema.sql"

## file sorgente
FILE0="_usr/_database/mysql.schema.sql"
FILE1="_usr/_database/mysql.data.sql"

## file temporaneo
FILEC=$FILE1".clean"

## se il file su cui lavorare è specificato
if [ -f "$FILE0" ]; then

    read -p "indirizzo del server: " SRVADDR

    read -p "porta del server: " SRVPORT

    read -p "nome utente AMMINISTRATORE: " SRVUSER

    read -p "password utente AMMINISTRATORE: " SRVPASS

    read -p "database: " SRVDBNAME

    read -p "nome utente DATABASE: " SRVDBUSER

    if [ -n "$SRVPASS" ]; then
        PASSC="-p$SRVPASS"
    fi

    mysqldump -h $SRVADDR -u $SRVUSER $PASSC --no-create-info --complete-insert --replace --opt --single-transaction $SRVDBNAME > $FILE2
    mysqldump -h $SRVADDR -u $SRVUSER $PASSC --no-data --opt --routines --single-transaction --events $SRVDBNAME > $FILE3

    cat $FILE3 | sed -E 's/DEFINER=`[a-z]+`@`[a-z0-9\.%]+`/DEFINER=CURRENT_USER()/g' | sed 's/ AUTO_INCREMENT=[0-9]*\b//g' > $FILEC
	mv $FILEC $FILE3

    mysql -h $SRVADDR -u $SRVUSER $PASSC -e "DROP DATABASE \`$SRVDBNAME\`;"
    mysql -h $SRVADDR -u $SRVUSER $PASSC -e "CREATE DATABASE \`$SRVDBNAME\` CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
    mysql -h $SRVADDR -u $SRVUSER $PASSC -e "GRANT ALL PRIVILEGES ON \`$SRVDBNAME\`.* TO \`$SRVDBUSER\`@\`%\`;"
    mysql -h $SRVADDR -u $SRVUSER $PASSC $SRVDBNAME < $FILE0
    mysql -h $SRVADDR -u $SRVUSER $PASSC $SRVDBNAME < $FILE1
    mysql -h $SRVADDR -u $SRVUSER $PASSC $SRVDBNAME < $FILE2

else

    echo "cartella non trovata"

fi
