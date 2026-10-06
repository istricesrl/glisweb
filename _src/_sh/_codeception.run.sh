#!/bin/bash

## SCRIPT PER L'ESECUZIONE DEI TEST
#
# questo script raccoglie i test del framework, dei moduli attivi e del progetto e li esegue con Codeception
#
# uso: _src/_sh/_codeception.run.sh [suite] [opzioni di codecept run]
#
# le suite sono unit (default), backend e frontend; "tutte" le esegue una dopo l'altra; le opzioni successive
# vanno a codecept run; un solo test si indica col percorso dentro la suite raccolta, cioe' la cartella di origine
# e il file, p.es.: _src/_sh/_codeception.run.sh backend AN000.anagrafica/anagraficaFormCest.php
#
# i test non stanno in un posto solo, quindi prima di eseguirli lo script li raccoglie in var/test/ con dei
# collegamenti simbolici, una cartella per origine:
#
# - var/test/tests/<suite>/framework/  <- _usr/_test/_tests/<suite>/
# - var/test/tests/<suite>/<modulo>/   <- _mod/_<modulo>/_usr/_test/_tests/<suite>/, solo per i moduli attivi
# - var/test/tests/<suite>/progetto/   <- usr/test/tests/<suite>/
#
# un file custom con lo stesso nome di uno standard lo sostituisce: usr/test/tests/<suite>/ prende il posto dei
# test del framework e mod/<modulo>/usr/test/tests/<suite>/ quello dei test del modulo; i test custom senza
# corrispettivo vengono aggiunti; la stessa regola vale per i file <suite>.suite.yml e per il supporto
# (_support/ e usr/test/tests/_support/, dove un progetto puo' mettere i propri helper)
#
# Codeception gira con _usr/_test/_bootstrap.php come auto_prepend_file, che avvia il framework e si rifiuta
# di proseguire se il sito e' in produzione; se lo script e' lanciato da root, i test girano come www-data
#

## pulizia schermo
clear

## livelli per la root del sito
RL="../../"

## directory corrente
cd $(dirname "$0") || exit 1
cd $RL || exit 1

## suite da eseguire
SUITE=${1:-unit}
shift
if [ "$SUITE" = "tutte" ]; then
    SUITE="unit backend frontend"
fi

## esecuzione come www-data se lanciato da root
if [ "$(id -u)" = "0" ]; then
    ESEGUI="sudo -u www-data env HOME=$(pwd)/var/test"
else
    ESEGUI="env HOME=$(pwd)/var/test"
fi

## PHP col bootstrap del framework
PHP="php -d auto_prepend_file=_usr/_test/_bootstrap.php"
CODECEPT="$PHP _src/_lib/_ext/codeception/codeception/codecept"

## moduli attivi
MODULI=$(echo '<?php echo implode( PHP_EOL, $cf["mods"]["active"]["array"] );' | $ESEGUI $PHP) || {
    echo "impossibile avviare il framework, i test non si eseguono"
    echo "$MODULI"
    exit 1
}

## collega i file di una cartella in un'altra, sostituendo quelli con lo stesso nome
# $1 cartella sorgente, $2 cartella di destinazione, $3 filtro sui nomi
function collega() {
    [ -d "$1" ] || return 0
    mkdir -p "$2"
    for f in "$1"/$3; do
        [ -f "$f" ] && ln -sfn "$(pwd)/$f" "$2/$(basename "$f")"
    done
    return 0
}

## raccolta dei test
rm -rf var/test/tests var/test/support
mkdir -p var/test/tests var/test/support/Helper var/test/support/_generated var/test/output

# supporto
collega _usr/_test/_tests/_support var/test/support "*.php"
collega _usr/_test/_tests/_support/Helper var/test/support/Helper "*.php"
collega usr/test/tests/_support var/test/support "*.php"
collega usr/test/tests/_support/Helper var/test/support/Helper "*.php"

# configurazione delle suite
collega _usr/_test/_tests var/test/tests "*.suite.yml"
collega usr/test/tests var/test/tests "*.suite.yml"

# test
for s in $SUITE; do

    # framework e progetto
    collega _usr/_test/_tests/$s var/test/tests/$s/framework "*Cest.php"
    for f in usr/test/tests/$s/*Cest.php; do
        [ -f "$f" ] || continue
        if [ -e "var/test/tests/$s/framework/$(basename "$f")" ]; then
            collega usr/test/tests/$s var/test/tests/$s/framework "$(basename "$f")"
        else
            collega usr/test/tests/$s var/test/tests/$s/progetto "$(basename "$f")"
        fi
    done

    # moduli attivi
    for m in $MODULI; do
        collega _mod/_$m/_usr/_test/_tests/$s var/test/tests/$s/$m "*Cest.php"
        collega mod/$m/usr/test/tests/$s var/test/tests/$s/$m "*Cest.php"
    done

done

## permessi
if [ "$(id -u)" = "0" ]; then
    chown -R www-data:www-data var/test
fi

## browser per le suite che ne hanno bisogno
if [[ " $SUITE " =~ " backend " || " $SUITE " =~ " frontend " ]]; then
    $ESEGUI chromedriver --port=9515 > var/test/output/chromedriver.log 2>&1 &
    CHROMEDRIVER_PID=$!
    sleep 1
fi

## generazione degli actor
$ESEGUI $CODECEPT build -c _usr/_test/codeception.yml --no-ansi > /dev/null
CODECEPTION_EXIT_CODE=$?

## esecuzione delle suite
if [ "$CODECEPTION_EXIT_CODE" = "0" ]; then
    for s in $SUITE; do
        $ESEGUI $CODECEPT run $s -c _usr/_test/codeception.yml --no-colors --steps "$@"
        ESITO=$?
        [ "$ESITO" = "0" ] || CODECEPTION_EXIT_CODE=$ESITO
    done
fi

## arresto del browser
if [ -n "$CHROMEDRIVER_PID" ]; then
    pkill -P $CHROMEDRIVER_PID 2>/dev/null
    kill $CHROMEDRIVER_PID 2>/dev/null
fi

## reCAPTCHA riacceso anche se la suite si e' interrotta ( vedi _src/_config/_115.google.php )
rm -f var/test/recaptcha.off

## codice di uscita
exit $CODECEPTION_EXIT_CODE

## NOTA
#
# per approfondire vedi _usr/_docs/_read/180.test.md
#
# per approfondire vedi anche https://codeception.com/docs/AcceptanceTests
#
