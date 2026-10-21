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
# ogni esecuzione lascia i suoi risultati in var/spool/test/<data e ora>/, cosi' un giro non si confonde coi
# precedenti e si puo' rileggere a distanza di giorni:
#
# - errori.log                   <- solo i test falliti, col messaggio e il punto in cui sono falliti
# - test.log                     <- l'output completo, passo per passo, di tutte le suite
# - <suite>.report.html e .xml   <- il report di Codeception, da browser e in formato JUnit
# - *.fail.html e *.fail.png     <- HTML e screenshot della pagina al momento di ogni fallimento
# - chromedriver.log             <- il log del browser
# - esito.md                     <- l'esito in breve: versione, commit, conteggi per suite e fallimenti
#
# esito.md e i report HTML dell'ultima esecuzione vengono poi pubblicati da _docs.build.sh --test, insieme
# all'elenco delle esecuzioni precedenti: quelli del progetto in usr/pages/test/ dietro Basic auth, quelli
# dello standard in _usr/_pages/_test/ sui deploy del framework; i *.fail.* non si pubblicano mai, perche'
# contengono i dati veri del deploy
#
# le esecuzioni piu' vecchie di 30 giorni vengono tolte all'avvio
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

## cartella dei risultati di questa esecuzione
# var/test/output/ e' l'area di lavoro di Codeception e si svuota a ogni giro: senza, i fallimenti dei giri
# precedenti restano li' accanto a quelli nuovi e non si distinguono
ESECUZIONE="var/spool/test/$(date +%Y%m%d%H%M%S)"
mkdir -p "$ESECUZIONE"
rm -rf var/test/output/*
find var/spool/test -mindepth 1 -maxdepth 1 -type d -mtime +30 -exec rm -rf {} +

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
    chown -R www-data:www-data var/test var/spool/test
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
        $ESEGUI $CODECEPT run $s -c _usr/_test/codeception.yml --no-colors --steps --html $s.report.html --xml $s.report.xml "$@" 2>&1 | tee var/test/output/$s.log
        ESITO=${PIPESTATUS[0]}
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

## raccolta dei risultati
# il log completo e' l'output delle suite una dopo l'altra; il report degli errori ne prende, per ogni suite, la
# parte finale che Codeception dedica ai fallimenti ( da "There was/were N failure/error" in poi )
for s in $SUITE; do
    [ -f var/test/output/$s.log ] || continue
    cat var/test/output/$s.log >> "$ESECUZIONE/test.log"
    FALLIMENTI=$(sed -n '/^There \(was\|were\) [0-9]* \(failure\|error\)/,$p' var/test/output/$s.log)
    if [ -n "$FALLIMENTI" ]; then
        printf '== suite %s ==\n\n%s\n\n' "$s" "$FALLIMENTI" >> "$ESECUZIONE/errori.log"
    fi
    rm -f var/test/output/$s.log
done
[ "$CODECEPTION_EXIT_CODE" = "0" ] || [ -s "$ESECUZIONE/errori.log" ] || echo "esecuzione fallita prima dei test ( codice $CODECEPTION_EXIT_CODE ): vedi test.log" >> "$ESECUZIONE/errori.log"
[ -s "$ESECUZIONE/errori.log" ] || echo "nessun errore" > "$ESECUZIONE/errori.log"
cp -a var/test/output/. "$ESECUZIONE/"

## esito in breve
# e' la pagina che si legge per prima e quella che si pubblica: dice su quale codice hanno girato i test
# ( versione e commit, con i file non ancora committati ) e quanti ne sono passati per ogni suite, contati
# dal report JUnit di Codeception
VERSIONE=$(cat etc/version.conf 2>/dev/null)
COMMIT=$(git rev-parse --short HEAD 2>/dev/null)
if [ -n "$COMMIT" ]; then
    MODIFICATI=$(git status --porcelain 2>/dev/null | wc -l)
    [ "$MODIFICATI" = "0" ] || COMMIT="$COMMIT, piu' $MODIFICATI file modificati e non committati"
else
    COMMIT="non disponibile"
fi
DATA=$(basename "$ESECUZIONE" | sed -E 's|^(....)(..)(..)(..)(..)(..)$|\3/\2/\1 \4:\5:\6|')
if [ "$CODECEPTION_EXIT_CODE" = "0" ]; then
    ESITO="superati"
else
    ESITO="falliti ( codice $CODECEPTION_EXIT_CODE )"
fi
{
    echo "# esecuzione del $DATA"
    echo
    echo "- deploy: $(hostname) $(pwd)"
    echo "- versione: ${VERSIONE:-non disponibile}"
    echo "- commit: $COMMIT"
    echo "- suite: $SUITE"
    echo "- esito: $ESITO"
    echo
    echo "| suite | test | superati | falliti | saltati | tempo |"
    echo "|---|---|---|---|---|---|"
    for s in $SUITE; do
        php -r '
            $x = @simplexml_load_file( $argv[1] );
            if( ! $x ) { exit( 1 ); }
            $t = ( $x->getName() == "testsuites" ) ? $x->testsuite[0] : $x;
            $n = (int) $t["tests"]; $f = (int) $t["failures"] + (int) $t["errors"]; $k = (int) $t["skipped"];
            printf( "| [%s](%s.report.html) | %d | %d | %d | %d | %.1f s |\n", $argv[2], $argv[2], $n, $n - $f - $k, $f, $k, (float) $t["time"] );
        ' "$ESECUZIONE/$s.report.xml" "$s" 2>/dev/null || echo "| $s | non eseguita | | | | |"
    done
    # i fallimenti si leggono dal report JUnit e non da errori.log: con --steps Codeception scrive il
    # dettaglio dentro lo scenario, e nel riepilogo finale restano solo i separatori. Una riga per test,
    # col messaggio, e un tetto, perche' una suite rotta per intero farebbe una pagina illeggibile.
    # Del messaggio di JUnit la prima riga ripete il nome del test: il messaggio e' la seconda, e se e'
    # un confronto su una pagina l'atteso sta nell'ultima riga "-->", dopo il corpo della pagina
    if [ "$CODECEPTION_EXIT_CODE" != "0" ]; then
        echo
        echo "## fallimenti"
        echo
        for s in $SUITE; do
            php -r '
                $x = @simplexml_load_file( $argv[1] );
                if( ! $x ) { exit( 1 ); }
                $c = $x->xpath( "//testcase[failure or error]" );
                foreach( array_slice( $c, 0, 50 ) as $t ) {
                    $e = ( isset( $t->failure ) ) ? $t->failure : $t->error;
                    $r = array_values( array_filter( array_map( "trim", explode( "\n", (string) $e ) ) ) );
                    $m = ( isset( $r[1] ) ) ? $r[1] : "";
                    $a = preg_grep( "/^--> /", $r );
                    if( count( $a ) > 1 ) { $m .= " " . substr( end( $a ), 4 ); }
                    printf( "- %s, `%s:%s`: %s\n", $argv[2], $t["class"], $t["name"], ( $m === "" ) ? "nessun messaggio" : $m );
                }
                if( count( $c ) > 50 ) { printf( "- %s: e altri %d, vedi il report\n", $argv[2], count( $c ) - 50 ); }
            ' "$ESECUZIONE/$s.report.xml" "$s" 2>/dev/null
        done
        grep -q "^esecuzione fallita prima dei test" "$ESECUZIONE/errori.log" && echo "- $(cat "$ESECUZIONE/errori.log")"
    fi
} > "$ESECUZIONE/esito.md"
[ "$(id -u)" = "0" ] && chown -R www-data:www-data "$ESECUZIONE"

## pubblicazione dell'esito
# la fa il generatore della documentazione, che ne condivide la protezione e la pagina; se fallisce i
# risultati restano comunque in var/spool/test/
./_src/_sh/_docs.build.sh --test > /dev/null || echo "pubblicazione dell'esito non riuscita: lanciare _src/_sh/_docs.build.sh --test" >&2

echo
echo "risultati in $ESECUZIONE/"

## codice di uscita
exit $CODECEPTION_EXIT_CODE

## NOTA
#
# per approfondire vedi _usr/_docs/_read/180.test.md
#
# per approfondire vedi anche https://codeception.com/docs/AcceptanceTests
#
