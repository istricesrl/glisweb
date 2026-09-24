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

## parametri a linea di comando per MySQL
if [ -n $3 ]; then
	MYSQLIP=$3
fi
if [ -n $4 ]; then
	MYSQLPORT=$4
fi
if [ -n $5 ]; then
	MYSQLUSER=$5
fi
if [ -n $6 ]; then
	MYSQLPW=$6
fi
if [ -n $7 ]; then
	MYSQLDB=$7
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

			if [ "$PLACEHOLDER" = "%indirizzo IP del server MySQL%" -a -n "$MYSQLIP" ]; then
				VALUE=$MYSQLIP
			elif [ "$PLACEHOLDER" = "%porta del server MySQL%" -a -n "$MYSQLPORT" ]; then
				VALUE=$MYSQLPORT
			elif [ "$PLACEHOLDER" = "%nome utente del server MySQL%" -a -n "$MYSQLUSER" ]; then
				VALUE=$MYSQLUSER
			elif [ "$PLACEHOLDER" = "%password del server MySQL%" -a -n "$MYSQLPW" ]; then
				VALUE=$MYSQLPW
			elif [ "$PLACEHOLDER" = "%nome del database MySQL%" -a -n "$MYSQLDB" ]; then
				VALUE=$MYSQLDB
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

				if [ "$PLACEHOLDER" = "%indirizzo IP del server MySQL%" ]; then
					MYSQLIP=$VALUE
				elif [ "$PLACEHOLDER" = "%porta del server MySQL%" ]; then
					MYSQLPORT=$VALUE
				elif [ "$PLACEHOLDER" = "%nome utente del server MySQL%" ]; then
					MYSQLUSER=$VALUE
				elif [ "$PLACEHOLDER" = "%password del server MySQL%" ]; then
					MYSQLPW=$VALUE
				elif [ "$PLACEHOLDER" = "%nome del database MySQL%" ]; then
					MYSQLDB=$VALUE
				fi

			fi

		fi

		perl -pi -e "s/$PLACEHOLDER/$VALUE/g" $FILE

		placeholder

    done

    echo "nessun placeholder rimasto da sostituire"

    if [[ -n "$PROTOCOL" ]] && [[ -n "$HOST" ]] && [[ -n "$DOMAIN" ]]; then
		./_src/_sh/_crontab.install.sh install $PROTOCOL $HOST.$DOMAIN
    else
		echo "ATTENZIONE installare il crontab manualmente"
    fi

#	read -p "vuoi creare il database MySQL (s/n)? " SN

#	if [ -n "$MYSQLIP" ]; then
#		./_src/_sh/_mysql.install.sh $MYSQLIP $MYSQLPORT $MYSQLDB $MYSQLUSER $MYSQLPW
#	fi

    ./_src/_sh/_lamp.permissions.secure.sh

elif [ -n "$1" ]; then

    mkdir -p ./src/

    cp ./_usr/_config/_json/_templates/template.$1.json $FILE

    ./_src/_sh/_gw.config.sh $1 $FILE

else

    echo "utilizzo: $( basename $0 ) template [path/to/file.json]"
	echo "es: $( basename $0 ) base"
	echo "es: $( basename $0 ) base ./src/prova.json"
	echo "es: $( basename $0 ) base ./src/config.json ipMySQL portMySQL userMySQL passMySQL dbMySQL"
    echo "template disponibili:"

    for i in $( ls -d ./_usr/_config/_json/_templates/template.*.json ); do
        TEMPLATE="$( basename $i )"
        TEMPLATEBASENAME="${TEMPLATE%.*}"
        echo "${TEMPLATEBASENAME#*.}"
    done

fi

# TODO alla fine bisognerebbe indentare il JSON, è possibile a linea di comando?
# https://stackoverflow.com/questions/352098/how-can-i-pretty-print-json-in-a-shell-script
