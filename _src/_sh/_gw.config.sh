#!/bin/bash

## funzione di recupero token
placeholder() {
    PLACEHOLDER="$( grep -m1 -Po '%[a-zA-Z0-9\-\., ]+%' $FILE )"
}

## pulizia schermo
clear

## livelli per la root del sito
RL="../../"

## directory corrente
cd $(dirname "$0")
cd $RL

## informazioni
echo "lavoro su: $(pwd)"

## file di lavoro
FILE="./src/config.json"

## placeholder
PLACEHOLDER=""

## se il file su cui lavorare è specificato
if [ -f "$FILE" ]; then

    ## prelevo un placeholder dal file
    placeholder

    while [ -n "$PLACEHOLDER" ]; do

		if [ "$PLACEHOLDER" = "%moduli%" ]; then

			for mod in $( ls _mod ); do

				read -p "vuoi attivare il modulo $mod?" SN

				# TODO se l'utente dice sì, aggiungere il modulo a una variabile MODULI
				# avendo cura di preporre una virgola se il modulo non è il primo aggiunto

				# TODO bisogna anche "pulire" il nome del modulo dal resto del path

			done

		else

			read -p "${PLACEHOLDER//\%}: " VALUE

			if [ "$PLACEHOLDER" = "%password di root%" ]; then
				VALUE=$( echo -n $VALUE | md5sum | cut -c 1-32 )
			elif [ "$PLACEHOLDER" = "%protocollo del sito%" ]; then
				PROTOCOL=$VALUE
			elif [ "$PLACEHOLDER" = "%nome host del sito%" ]; then
				HOST=$VALUE
			elif [ "$PLACEHOLDER" = "%dominio del sito%" ]; then
				DOMAIN=$VALUE
			fi

		fi

		perl -pi -e "s/$PLACEHOLDER/$VALUE/g" $FILE

		placeholder

    done

    echo "nessun placeholder rimasto da sostituire"

    if [[ -n "$PROTOCOL" ]] && [[ -n "$HOST" ]] && [[ -n "$DOMAIN" ]]; then
		./_src/_sh/_gw.crontab.install.sh install $PROTOCOL $HOST.$DOMAIN
    else
		echo "non sono riuscito ad installare automaticamente il crontab, procedere manualmente"
    fi

elif [ -n "$1" ]; then

    mkdir -p ./src/

    cp ./_usr/_config/_json/_templates/template.$1.json ./src/config.json

    ./_src/_sh/_gw.config.sh

else

    echo "utilizzo: $( basename $0 ) template"
    echo "template disponibili:"

    for i in $( ls -d ./_usr/_config/_json/_templates/template.*.json ); do
        TEMPLATE="$( basename $i )"
        TEMPLATEBASENAME="${TEMPLATE%.*}"
        echo "${TEMPLATEBASENAME#*.}"
    done

fi

# TODO alla fine bisognerebbe indentare il JSON, è possibile a linea di comando?
# https://stackoverflow.com/questions/352098/how-can-i-pretty-print-json-in-a-shell-script
