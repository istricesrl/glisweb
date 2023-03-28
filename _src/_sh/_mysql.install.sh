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

## file da importare
# FILE1="_usr/_database/mysql.schema.sql"
# FILE2="_usr/_database/mysql.data.sql"

## intestazione
echo "installazione del database"

## se il file su cui lavorare è specificato
# if [ -f "$FILE1" -a -f "$FILE2" ]; then

    if [ -n "$1" ]; then
        SRVADDR=$1
    else
        read -p "indirizzo del server: " SRVADDR
    fi

    if [ -n "$2" ]; then
        SRVPORT=$2
    else
        read -p "porta del server: " SRVPORT
    fi

    if [ -n "$3" ]; then
        SRVDBNAME=$3
    else
        read -p "database: " SRVDBNAME
    fi

    if [ -f "/etc/mysql.remote.conf" ]; then
        DEFAULT="--defaults-extra-file=/etc/mysql.remote.conf"
        SRVUSER="root"
    elif [ -n "$SRVPASS" ]; then
        read -p "nome utente AMMINISTRATORE: " SRVUSER
        read -s -p "password utente AMMINISTRATORE: " SRVPASS && echo
        PASSC="-p$SRVPASS"
    fi

    mysql $DEFAULT -h $SRVADDR -u $SRVUSER $PASSC -e "CREATE DATABASE IF NOT EXISTS \`$SRVDBNAME\` CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
    # mysql -h $SRVADDR -u $SRVUSER $PASSC $SRVDBNAME < $FILE1
    # mysql -h $SRVADDR -u $SRVUSER $PASSC $SRVDBNAME < $FILE2

    read -p "vuoi assegnare il database a un utente specifico (s/n)? " YN

    if [ $YN == "s" ]; then

        read -p "l'utente va creato (s/n)? " SYN

        if [ -n "$4" ]; then
            SRVDBUSER=$4
        else
            read -p "nome utente DATABASE: " SRVDBUSER
        fi

        if [ $SYN == "s" ]; then
            if [ -n "$5" ]; then
                SRVDBPASS=$5
            else
                read -s -p "password utente DATABASE: " SRVDBPASS && echo
            fi
            mysql $DEFAULT -h $SRVADDR -u $SRVUSER $PASSC -e "CREATE USER \`$SRVDBUSER\`@\`%\` IDENTIFIED BY '$SRVDBPASS';"
        fi

        mysql $DEFAULT -h $SRVADDR -u $SRVUSER $PASSC -e "GRANT ALL PRIVILEGES ON \`$SRVDBNAME\`.* TO \`$SRVDBUSER\`@\`%\`;"

    fi

    # mkdir -p usr/database/
    # cp _usr/_database/mysql.schema.version usr/database/mysql.schema.version

# fi
