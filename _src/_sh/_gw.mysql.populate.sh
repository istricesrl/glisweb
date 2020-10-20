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
NOMI=( "" "Mario" "Giovanna" "Luca" "Andrea" "Rossana" "Carla" "Francesco" "Alessandro" "Annalisa" "Giacomo" "Sara" )
COGNOMI=( "Bianchi" "Rossi" "Verdi" "Marroni" "Gialli" "Arancioni" "Neri" "Turchesi" "Azzurri" "Violetti" )
DENOMINAZIONI=( "ACME" "Alfa" "Beta" "Gamma" "Delta" "Lambda" "Kappa" "Epsilon" "Omicron" "Sigma" "Tau" )
TIPOLOGIE=( "spa" "snc" "sas" "srl" "ONLUS" )
CATEGORIE=( "1" "2" "3" "4" "5" "6" )
DOMINI=( "bogus" "bogon" "noob" "null" "no" "whatever" )
ESTENSIONI=( "bho" "tux" "nop" "clue" "clue" "wtf" )
TIPOLOGIETELEFONI=( "1" "2" "3" "4" )

## se il file su cui lavorare è specificato
if [ -n "$1" -a -n "$2" ]; then

    read -p "indirizzo del server: " SRVADDR
    read -p "porta del server: " SRVPORT
    read -p "nome utente: " SRVUSER
    read -p "password: " SRVPASS
    read -p "database: " SRVDBNAME

    if [ -z "$SRVADDR" ]; then SRVADDR="127.0.0.1"; fi
    if [ -z "$SRVPORT" ]; then SRVPORT="3306"; fi
    if [ -z "$SRVUSER" ]; then SRVUSER="root"; fi

    for (( i=1; i<=$1; i++ )); do

        case "$2" in
            "anagrafica")

                RANDOM=$$$(date +%N)
                NOME=${NOMI[$RANDOM % ${#NOMI[@]}]}

                RANDOM=$$$(date +%N)
                COGNOME=${COGNOMI[$RANDOM % ${#COGNOMI[@]}]}

                RANDOM=$$$(date +%N)
                ESTENSIONE=${ESTENSIONI[$RANDOM % ${#ESTENSIONI[@]}]}

                if [ -z "$NOME" ]; then

                    RANDOM=$$$(date +%N)
                    DENOMINAZIONE1=${DENOMINAZIONI[$RANDOM % ${#DENOMINAZIONI[@]}]}

                    RANDOM=$$$(date +%N)
                    DENOMINAZIONE2=${DENOMINAZIONI[$RANDOM % ${#DENOMINAZIONI[@]}]}

                    RANDOM=$$$(date +%N)
                    TIPOLOGIA=${TIPOLOGIE[$RANDOM % ${#TIPOLOGIE[@]}]}

                    DENOMINAZIONE="$DENOMINAZIONE1 $DENOMINAZIONE2 $TIPOLOGIA"
                    MAIL=$( echo "info@$DENOMINAZIONE1$DENOMINAZIONE2$TIPOLOGIA.$ESTENSIONE"  | tr '[:upper:]' '[:lower:]' )

                    QUERY="INSERT INTO anagrafica ( denominazione ) VALUES ( '$DENOMINAZIONE' )"

                else

                    RANDOM=$$$(date +%N)
                    DOMINIO=${DOMINI[$RANDOM % ${#DOMINI[@]}]}

                    MAIL=$( echo "$NOME.$COGNOME@$DOMINIO.$ESTENSIONE"  | tr '[:upper:]' '[:lower:]' )

                    QUERY="INSERT INTO anagrafica ( nome, cognome ) VALUES ( '$NOME', '$COGNOME' )"

                fi

                echo "$i $QUERY"
                IDS=$( mysql -h $SRVADDR -u $SRVUSER -p$SRVPASS $SRVDBNAME -e "$QUERY; SELECT LAST_INSERT_ID();" )
                IDA=$( echo $IDS | cut -d\| -f1 | tr -dc '0-9' )

                RANDOM=$$$(date +%N)
                CATEGORIA=${CATEGORIE[$RANDOM % ${#CATEGORIE[@]}]}

                QUERY="INSERT INTO anagrafica_categorie ( id_anagrafica, id_categoria ) VALUES ( '$IDA', '$CATEGORIA' )"

                echo "$i $QUERY"
                IDS=$( mysql -h $SRVADDR -u $SRVUSER -p$SRVPASS $SRVDBNAME -e "$QUERY; SELECT LAST_INSERT_ID();" )

                QUERY="INSERT INTO mail ( id_anagrafica, indirizzo ) VALUES ( '$IDA', '$MAIL' )"

                echo "$i $QUERY"
                IDS=$( mysql -h $SRVADDR -u $SRVUSER -p$SRVPASS $SRVDBNAME -e "$QUERY; SELECT LAST_INSERT_ID();" )

                RANDOM=$$$(date +%N)
                TIPOLOGIATELEFONO=${TIPOLOGIETELEFONI[$RANDOM % ${#TIPOLOGIETELEFONI[@]}]}
                TELEFONO="$( shuf -i 111-999 -n 1 )/$( shuf -i 1111111-9999999 -n 1 )"

                QUERY="INSERT INTO telefoni ( id_anagrafica, id_tipologia, numero ) VALUES ( '$IDA', '$TIPOLOGIATELEFONO', '$TELEFONO' )"

                echo "$i $QUERY"
                IDS=$( mysql -h $SRVADDR -u $SRVUSER -p$SRVPASS $SRVDBNAME -e "$QUERY; SELECT LAST_INSERT_ID();" )

            ;;
            "catalogo")

            ;;
        esac

    done

else

    echo "$0 <numeroOggetti> <tipoOggetti>"

fi
