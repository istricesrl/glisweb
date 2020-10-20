#!/bin/bash

## livelli per la root del sito
RL="../../"

## directory corrente
cd $(dirname "$0")
cd $RL

## informazioni
echo "lavoro su: $(pwd)"

## pulizia schermo
clear

## valori casuali
NOMI=( "" "Mario" "Giovanna" "Luca" "Andrea" "Rossana" "Carla" "Francesco" "Alessandro" "Annalisa" )
COGNOMI=( "Bianchi" "Rossi" "Verdi" "Marroni" "Gialli" "Arancioni" "Neri" "Turchesi" "Azzurri" )
DENOMINAZIONI=( "ACME" "Alfa" "Beta" "Gamma" "Delta" "Lambda" "Kappa" "Epsilon" "Omicron" "Sigma" "Tau" )
TIPOLOGIE=( "spa" "snc" "sas" "srl" "soc. coop." "ONLUS" )

## se il file su cui lavorare è specificato
if [ -n "$1" -a -n "$2" ]; then

    read -p "indirizzo del server: " SRVADDR

    read -p "porta del server: " SRVPORT

    read -p "nome utente: " SRVUSER

    read -p "password: " SRVPASS

    read -p "database: " SRVDBNAME

#    mysql -h $SRVADDR -u $SRVUSER -p$SRVPASS $SRVDBNAME < $FILE2

    for (( i=1; i<=$1; i++ )); do

        RANDOM=$$$(date +%N)
        NOME=${NOMI[$RANDOM % ${#NOMI[@]}]}

        RANDOM=$$$(date +%N)
        COGNOME=${COGNOMI[$RANDOM % ${#COGNOMI[@]}]}

        if [ -z "$NOME" ]; then

            RANDOM=$$$(date +%N)
            DENOMINAZIONE1=${DENOMINAZIONI[$RANDOM % ${#DENOMINAZIONI[@]}]}

            RANDOM=$$$(date +%N)
            DENOMINAZIONE2=${DENOMINAZIONI[$RANDOM % ${#DENOMINAZIONI[@]}]}

            RANDOM=$$$(date +%N)
            TIPOLOGIA=${TIPOLOGIE[$RANDOM % ${#TIPOLOGIE[@]}]}

            DENOMINAZIONE="$DENOMINAZIONE1 $DENOMINAZIONE2 $TIPOLOGIA"

            QUERY="INSERT INTO anagrafica ( denominazione ) VALUES ( '$DENOMINAZIONE' )"

        else

            QUERY="INSERT INTO anagrafica ( nome, cognome ) VALUES ( '$NOME', '$COGNOME' )"

        fi

        echo "$i $QUERY"
        IDS=$( mysql -h $SRVADDR -u $SRVUSER -p$SRVPASS $SRVDBNAME -e "$QUERY; SELECT LAST_INSERT_ID();" )
        ID=$( echo $IDS | cut -d\| -f1 | tr -dc '0-9' )

    done

else

    echo "$0 <numeroOggetti> <tipoOggetti>"

fi
