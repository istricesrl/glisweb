#!/bin/bash

## funzione di recupero token
placeholder() {
    PLACEHOLDER="$( grep -m1 -Po '%[a-zA-Z0-9\-\., ]+%' $FILE )"
}

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

## pulizia schermo
clear

## se il file su cui lavorare è specificato
if [ -f "$FILE" ]; then

    ## prelevo un placeholder dal file
    placeholder

    while [ -n "$PLACEHOLDER" ]; do

	if [ "$PLACEHOLDER" = "%moduli%" ]; then
	    echo "preconfigurazioni dei moduli disponibili:"
	    for i in $( ls -d ./_usr/_config/mods.*.json ); do
		MODS="$( basename $i )"
		MODSBASENAME="${MODS%.*}"
		echo "${MODSBASENAME#*.}"
	    done
	fi

	read -p "${PLACEHOLDER//\%}: " VALUE

	if [ "$PLACEHOLDER" = "%password di root%" ]; then
	    VALUE=$( echo -n $VALUE | md5sum | cut -c 1-32 )
	elif [ "$PLACEHOLDER" = "%protocollo del sito, http o https%" ]; then
	    PROTOCOL=$VALUE
	elif [ "$PLACEHOLDER" = "%nome host del sito, ad es. bogon in bogon.nomedominio.bogus%" ]; then
	    HOST=$VALUE
	elif [ "$PLACEHOLDER" = "%dominio del sito, ad es. nomedominio.bogus in bogon.nomedominio.bogus%" ]; then
	    DOMAIN=$VALUE
#	elif [ "$PLACEHOLDER" = "%moduli%" ]; then
#	    VALUE=$( cat ./_usr/_config/mods.$VALUE.json )
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
