#!/bin/bash

## CONFIGURAZIONE INIZIALE DEL FRAMEWORK DA UN TEMPLATE
#
# Copia /_usr/_config/_json/_templates/template.<template>.json nel file di configurazione e chiede
# un valore per ogni segnaposto %...% che contiene; %opzioni% e %moduli% vengono espansi subito
# ( frammenti di /_usr/_config/_json/_templates/_options/ e moduli di _mod/ ), tutti gli altri
# vengono raccolti e scritti nel file in un colpo solo alla fine.
#
# I VALORI PASSANO LETTERALI. Fino al 29/09/2026 la sostituzione era `perl -pi -e "s/$P/$V/g"`: un
# valore con / rompeva l'espressione, uno con @ ( un utente SMTP, una password ) veniva interpolato
# da perl come array e usciva troncato, & \ e $ venivano interpretati. Ora i valori arrivano a php
# nell'ambiente, mai dentro il codice, e vengono scritti con strtr(): niente viene interpretato, e
# il testo gia' sostituito non viene riletto, quindi un valore che contiene a sua volta qualcosa
# come %xxx% non viene scambiato per un segnaposto. Siccome i segnaposto stanno tutti dentro
# stringhe JSON, il valore viene scritto con l'escape JSON ( " e \ ): nel file diventa \" e \\, e
# il framework, leggendolo, ritrova esattamente quello che e' stato digitato.
#
# I SEGRETI VANNO IN SHADOW. Accanto a template.<template>.json c'e' shadow.<template>.json, con le
# sole chiavi segrete ( hash della password di root, utente e password dei server MySQL ), e allo
# stesso modo un'opzione con dei segreti ha il suo _options/shadow.<opzione>.json ( oggi smtp ). Il
# primo si copia in src/config.json, che si puo' versionare, il secondo in src/shadow.json, che e'
# escluso da git e che il framework fonde sopra config.json ( vedi "Come trovare le credenziali" in
# _etc/_claude/_claude.framework.md ). I segnaposto dei due file si chiedono nello stesso giro, prima
# quelli di config e poi quelli di shadow. Il file shadow sta accanto al file di configurazione e ne
# prende il nome: config.json -> shadow.json, prova.json -> shadow.prova.json. Fino al 30/09/2026 tutto
# finiva in src/config.json, che per questo .gitignore.dev escludeva dal repository.
#
# LA PASSWORD DI ROOT si salva come hash di password_hash() ( bcrypt ), lo stesso di passwordHash() e
# di _password.hash.sh; fino al 30/09/2026 era md5, che passwordVerify() accetta ancora.
#
# IL CRONTAB si installa per ogni stage di cui si conoscono protocollo, nome host e dominio. I
# segnaposto si riconoscono sia nella forma semplice ( «%nome host del sito%», template base e
# sviluppo ) sia in quella per stage ( «%nome host in DEV del sito%», template test ): prima del
# 29/09/2026 la seconda non era riconosciuta e con template.test.json il crontab non si installava.
#
# uso: _gw.config.sh <template> [ file ] [ ip porta utente password database ]

## funzione di recupero token
#
# restituisce il primo segnaposto dei due file ( prima config, poi shadow ) che non e' ancora stato
# trattato: i valori raccolti restano da scrivere fino alla fine, quindi i segnaposto gia' visti vanno
# saltati
placeholder() {
    local FILES=( "$FILE" )
    [ -f "$SHADOW" ] && FILES+=( "$SHADOW" )
    PLACEHOLDER="$( grep -Poh '%[a-zA-Z0-9\-\., ]+%' "${FILES[@]}" | awk '!visti[$0]++' | grep -vxF -f <( printf '%s\n' "${FATTI[@]}" ) | head -1 )"
}

## espansione di un frammento JSON grezzo ( %opzioni% e %moduli% ) nel file indicato
#
# uso: espandi <file> <segnaposto> <valore>
#
# NOTA segnaposto e valore passano dall'ambiente e non dalla riga di codice, quindi non vengono
# interpretati ne' da bash ne' da php
espandi() {
    [ -f "$1" ] || return 0
    GW_FILE="$1" GW_SEGNAPOSTO="$2" GW_VALORE="$3" php -r '
        $f = getenv( "GW_FILE" );
        file_put_contents( $f, str_replace( getenv( "GW_SEGNAPOSTO" ), getenv( "GW_VALORE" ), file_get_contents( $f ) ) );
    '
}

## scrittura di tutti i valori raccolti, in un solo passaggio per file
#
# uso: applica <file>
#
# ogni coppia arriva nell'ambiente come GW_S_<n> ( segnaposto ) e GW_V_<n> ( valore ); il valore
# viene scritto come contenuto di una stringa JSON, cioe' con l'escape di " e \
applica() {
    [ -f "$1" ] || return 0
    GW_FILE="$1" php -r '
        $t = array();
        for( $i = 0; getenv( "GW_S_" . $i ) !== false; $i++ ) {
            $v = json_encode( (string) getenv( "GW_V_" . $i ), JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE | JSON_INVALID_UTF8_SUBSTITUTE );
            $t[ getenv( "GW_S_" . $i ) ] = substr( $v, 1, -1 );
        }
        $f = getenv( "GW_FILE" );
        file_put_contents( $f, strtr( file_get_contents( $f ), $t ) );
    '
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

## file dei segreti, accanto al file di lavoro: config.json -> shadow.json, prova.json -> shadow.prova.json
BASE="$( basename "$FILE" )"
SHADOW="$( dirname "$FILE" )/shadow.${BASE#config.}"

## parametri a linea di comando per MySQL
if [ -n "$3" ]; then
	MYSQLIP=$3
fi
if [ -n "$4" ]; then
	MYSQLPORT=$4
fi
if [ -n "$5" ]; then
	MYSQLUSER=$5
fi
if [ -n "$6" ]; then
	MYSQLPW=$6
fi
if [ -n "$7" ]; then
	MYSQLDB=$7
fi

## placeholder
PLACEHOLDER=""

## segnaposto gia' trattati e numero di valori raccolti
FATTI=()
N=0

## protocollo, host e dominio per stage, per il crontab ( chiave _ se il segnaposto non nomina lo stage )
declare -A PROTOCOLLI HOSTS DOMINI

## se il file su cui lavorare è specificato
if [ -f "$FILE" ]; then

    ## prelevo un placeholder dal file
    placeholder

    while [ -n "$PLACEHOLDER" ]; do

		VALUE=""

		FATTI+=( "$PLACEHOLDER" )

		if [ "$PLACEHOLDER" = "%moduli%" ]; then

			for mod in $( ls _mod ); do

				md=${mod#*_}

				read -p "vuoi attivare il modulo $md (s/n)? " SN

				if [ "$SN" == "s" ]; then
					if [ -n "$VALUE" ]; then
						VALUE="$VALUE,"
					fi
					VALUE="$VALUE"$'\n'"        \"$md\""
				fi

			done

			if [ -n "$VALUE" ]; then
				VALUE="$VALUE"$'\n'"      "
			fi

			espandi "$FILE" "$PLACEHOLDER" "$VALUE"

		elif [ "$PLACEHOLDER" = "%opzioni%" ]; then

			# i segreti dell'opzione, se ne ha, vanno nel file shadow
			VALUESHADOW=""

			for opt in $( cd _usr/_config/_json/_templates/_options/ && ls option.*.json ); do

				opf=${opt#*.}
				op=${opf%.*}

				read -p "vuoi attivare l'opzione $op (s/n)? " SN

				if [ "$SN" == "s" ]; then
					VALUE="$VALUE"$'\n'"$(cat _usr/_config/_json/_templates/_options/$opt),"
					if [ -f "_usr/_config/_json/_templates/_options/shadow.$op.json" ]; then
						VALUESHADOW="$VALUESHADOW"$'\n'"$(cat _usr/_config/_json/_templates/_options/shadow.$op.json),"
					fi
				fi

			done

			espandi "$FILE" "$PLACEHOLDER" "$VALUE"
			espandi "$SHADOW" "$PLACEHOLDER" "$VALUESHADOW"

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

				# IFS vuoto e -r: spazi in testa e in coda e backslash restano come sono stati digitati
				if [[ $PLACEHOLDER =~ "password" ]]; then
					IFS= read -r -s -p "${PLACEHOLDER//\%}: " VALUE && echo
				else
					IFS= read -r -p "${PLACEHOLDER//\%}: " VALUE
				fi

				# hash come passwordHash() di _src/_lib/_cryptography.tools.php; la password passa dall'ambiente
				if [ "$PLACEHOLDER" = "%password di root%" ]; then
					VALUE=$( GW_PASSWORD="$VALUE" php -r 'echo password_hash( (string) getenv( "GW_PASSWORD" ), PASSWORD_DEFAULT );' )
				fi

			fi

			# protocollo, host e dominio del sito, nella forma semplice o per stage
			if [[ $PLACEHOLDER =~ ^%protocollo( in ([A-Z]+))?\ del\ sito%$ ]]; then
				PROTOCOLLI[${BASH_REMATCH[2]:-_}]=$VALUE
			elif [[ $PLACEHOLDER =~ ^%nome\ host( in ([A-Z]+))?\ del\ sito%$ ]]; then
				HOSTS[${BASH_REMATCH[2]:-_}]=$VALUE
			elif [[ $PLACEHOLDER =~ ^%dominio( in ([A-Z]+))?\ del\ sito%$ ]]; then
				DOMINI[${BASH_REMATCH[2]:-_}]=$VALUE
			fi

			export "GW_S_$N=$PLACEHOLDER" "GW_V_$N=$VALUE"
			N=$(( N + 1 ))

		fi

		placeholder

    done

    ## scrittura dei valori raccolti
    applica "$FILE"
    applica "$SHADOW"

    echo "nessun placeholder rimasto da sostituire"

    ## controllo del risultato: un JSON rotto il framework lo rifiuta al primo avvio
    for J in "$FILE" "$SHADOW"; do
		[ -f "$J" ] || continue
		if GW_FILE="$J" php -r 'json_decode( file_get_contents( getenv( "GW_FILE" ) ) ); if( json_last_error() ) { echo json_last_error_msg(); exit( 1 ); }' > /dev/null; then
			echo "$J è un JSON valido"
		else
			echo "ATTENZIONE $J non è un JSON valido, va corretto a mano"
		fi
    done

    ## crontab, uno per ogni stage di cui si conoscono protocollo, host e dominio
    CRONTAB=""
    for STADIO in "${!HOSTS[@]}"; do
		if [[ -n "${PROTOCOLLI[$STADIO]}" ]] && [[ -n "${HOSTS[$STADIO]}" ]] && [[ -n "${DOMINI[$STADIO]}" ]]; then
			./_src/_sh/_crontab.install.sh install "${PROTOCOLLI[$STADIO]}" "${HOSTS[$STADIO]}.${DOMINI[$STADIO]}"
			CRONTAB="1"
		fi
    done

    if [[ -z "$CRONTAB" ]]; then
		echo "ATTENZIONE installare il crontab manualmente"
    fi

#	read -p "vuoi creare il database MySQL (s/n)? " SN

#	if [ -n "$MYSQLIP" ]; then
#		./_src/_sh/_mysql.install.sh $MYSQLIP $MYSQLPORT $MYSQLDB $MYSQLUSER $MYSQLPW
#	fi

    ./_src/_sh/_lamp.permissions.secure.sh

elif [ -n "$1" ] && [ -f "./_usr/_config/_json/_templates/template.$1.json" ]; then

    ## un file shadow gia' presente ha delle credenziali: non si sovrascrive
    if [ -f "./_usr/_config/_json/_templates/shadow.$1.json" ] && [ -f "$SHADOW" ]; then
		echo "ATTENZIONE $SHADOW esiste già: spostalo o cancellalo prima di rilanciare"
		exit 1
    fi

    mkdir -p "$( dirname "$FILE" )"

    cp "./_usr/_config/_json/_templates/template.$1.json" "$FILE"

    if [ -f "./_usr/_config/_json/_templates/shadow.$1.json" ]; then
		cp "./_usr/_config/_json/_templates/shadow.$1.json" "$SHADOW"
    fi

    ## si ripassano anche i parametri MySQL, che prima andavano persi a questo punto
    ./_src/_sh/_gw.config.sh "$1" "$FILE" "${@:3}"

else

    if [ -n "$1" ]; then
		echo "template $1 non trovato"
    fi

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
