#!/bin/bash

## funzione di recupero token
placeholder() {
    PLACEHOLDER="$( grep -m1 -Po '%[a-zA-Z0-9\-\., ]+%' $FILE | head -1 )"
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

## intestazione
echo "configurazione del framework"

## file di lavoro
if [ -z "$2" ]; then
	FILE="./src/config.json"
else
	FILE="$2"
fi

## placeholder
PLACEHOLDER=""

## se il file su cui lavorare è specificato
if [ -f "$FILE" ]; then

    ## prelevo un placeholder dal file
    placeholder

    while [ -n "$PLACEHOLDER" ]; do

		VALUE=""

		if [ "$PLACEHOLDER" = "%moduli%" ]; then

			for mod in $( ls _mod ); do

				md=${mod#*_}

				read -p "vuoi attivare il modulo $md (s/n)? " SN

				if [ "$SN" == "s" ]; then
					if [ -n "$VALUE" ]; then
						VALUE="$VALUE,"
					fi
					VALUE="$VALUE\n        \"$md\""
				fi

			done

			if [ -n "$VALUE" ]; then
				VALUE="$VALUE\n      "
			fi

		elif [ "$PLACEHOLDER" = "%opzioni%" ]; then

			for opt in $( ls _usr/_config/_json/_templates/_options/ ); do

				opf=${opt#*.}
				op=${opf%.*}

				read -p "vuoi attivare l'opzione $op (s/n)? " SN

				if [ "$SN" == "s" ]; then
					VALUE="$VALUE\n$(cat _usr/_config/_json/_templates/_options/$opt),"
				fi

			done

		else

			if [ "$PLACEHOLDER" = "%stage del sito%" -a -n "$STAGE" ]; then
				VALUE=$STAGE
			else
				if [[ $PLACEHOLDER =~ "password" ]]; then
					read -s -p "${PLACEHOLDER//\%}: " VALUE && echo
				else
					read -p "${PLACEHOLDER//\%}: " VALUE
				fi
			fi

			if [ "$PLACEHOLDER" = "%password di root%" ]; then
				VALUE=$( echo -n $VALUE | md5sum | cut -c 1-32 )
			elif [ "$PLACEHOLDER" = "%protocollo del sito%" ]; then
				PROTOCOL=$VALUE
			elif [ "$PLACEHOLDER" = "%stage del sito%" ]; then
				STAGE=$VALUE
			elif [ "$PLACEHOLDER" = "%nome host del sito%" ]; then
				HOST=$VALUE
			elif [ "$PLACEHOLDER" = "%dominio del sito%" ]; then
				DOMAIN=$VALUE
			fi

		fi

		perl -pi -e "s/$PLACEHOLDER/$VALUE/g" $FILE
		# sed -i "s/$PLACEHOLDER/$VALUE/" $FILE

		placeholder

    done

    echo "nessun placeholder rimasto da sostituire"

    if [[ -n "$PROTOCOL" ]] && [[ -n "$HOST" ]] && [[ -n "$DOMAIN" ]]; then
		./_src/_sh/_gw.crontab.install.sh install $PROTOCOL $HOST.$DOMAIN
    else
		echo "ATTENZIONE installare il crontab manualmente"
    fi

elif [ -n "$1" ]; then

    mkdir -p ./src/

    cp ./_usr/_config/_json/_templates/template.$1.json $FILE

    ./_src/_sh/_gw.config.sh $1 $FILE

else

    echo "utilizzo: $( basename $0 ) template [path/to/file.json]"
	echo "es: $( basename $0 ) base"
	echo "es: $( basename $0 ) base ./src/prova.json"
    echo "template disponibili:"

    for i in $( ls -d ./_usr/_config/_json/_templates/template.*.json ); do
        TEMPLATE="$( basename $i )"
        TEMPLATEBASENAME="${TEMPLATE%.*}"
        echo "${TEMPLATEBASENAME#*.}"
    done

fi

# TODO alla fine bisognerebbe indentare il JSON, è possibile a linea di comando?
# https://stackoverflow.com/questions/352098/how-can-i-pretty-print-json-in-a-shell-script
