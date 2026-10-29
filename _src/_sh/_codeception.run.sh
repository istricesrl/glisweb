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

## porta di chromedriver
# la prima libera da 9515 in su: con una porta fissa due deploy che fanno girare i test insieme si pestano i
# piedi, perche' il secondo chromedriver non parte e il primo, a fine giro, spegne quello che usano tutti e due;
# i .suite.yml la leggono come %GLISWEB_CHROMEDRIVER_PORT%
PORTA=9515
while (echo > /dev/tcp/127.0.0.1/$PORTA) 2>/dev/null; do
    PORTA=$(( PORTA + 1 ))
done

## porta del finto REST
# il finto REST dei test ( _usr/_test/_rest.mock.php ) gira su 127.0.0.1, alla prima porta libera da 8790 in su
PORTA_REST=8790
while (echo > /dev/tcp/127.0.0.1/$PORTA_REST) 2>/dev/null; do
    PORTA_REST=$(( PORTA_REST + 1 ))
done

## porta del server FTP di prova
# il server FTP dei test gira su 127.0.0.1, alla prima porta libera da 2121 in su, se c'e' python3-pyftpdlib
PORTA_FTP=2121
while (echo > /dev/tcp/127.0.0.1/$PORTA_FTP) 2>/dev/null; do
    PORTA_FTP=$(( PORTA_FTP + 1 ))
done

## esecuzione come www-data se lanciato da root
if [ "$(id -u)" = "0" ]; then
    ESEGUI="sudo -u www-data env HOME=$(pwd)/var/test GLISWEB_CHROMEDRIVER_PORT=$PORTA"
else
    ESEGUI="env HOME=$(pwd)/var/test GLISWEB_CHROMEDRIVER_PORT=$PORTA"
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

## finto REST
# la cartella delle risposte e delle richieste riparte vuota, e var/test/rest.mock con la porta e' l'interruttore che
# _src/_config/_595.rest.php legge per deviare le chiamate di restCall() ( vedi _src/_config/_590.rest.php )
rm -rf var/test/rest.mock.d
mkdir -p var/test/rest.mock.d/risposte
echo $PORTA_REST > var/test/rest.mock

## server FTP e sorgente dei log remoti di prova
# credenziali casuali a ogni giro, negli interruttori che _src/_config/_585.ftp.php e _src/_config/_020.debug.php
# leggono per far usare ai test il server FTP di prova e una sorgente di log remoti; senza python3-pyftpdlib il
# server FTP non c'e' e i test FTP si saltano col loro motivo
rm -rf var/test/ftp.mock.d
mkdir -p var/test/ftp.mock.d
if python3 -c "import pyftpdlib" 2>/dev/null; then
    FTP_PASSWORD=$(head -c 32 /dev/urandom | base64 | tr -dc 'A-Za-z0-9' | head -c 24)
    printf '%s\n%s\n' $PORTA_FTP $FTP_PASSWORD > var/test/ftp.mock
fi
head -c 48 /dev/urandom | base64 | tr -dc 'A-Za-z0-9' | head -c 32 > var/test/log.remoti
chmod 640 var/test/rest.mock var/test/log.remoti
[ -f var/test/ftp.mock ] && chmod 640 var/test/ftp.mock

## permessi
if [ "$(id -u)" = "0" ]; then
    chown -R www-data:www-data var/test var/spool/test
fi

## browser per le suite che ne hanno bisogno
if [[ " $SUITE " =~ " backend " || " $SUITE " =~ " frontend " ]]; then
    $ESEGUI chromedriver --port=$PORTA > var/test/output/chromedriver.log 2>&1 &
    CHROMEDRIVER_PID=$!
    sleep 1
fi

## avvio del finto REST
# l'output del server integrato non si tiene, perche' riporta gli URL con la query e quindi anche le chiavi che ci
# viaggiano; le richieste, con le credenziali mascherate, le registra il finto REST in var/test/rest.mock.d/
$ESEGUI php -S 127.0.0.1:$PORTA_REST -t var/test/rest.mock.d _usr/_test/_rest.mock.php > /dev/null 2>&1 &
REST_MOCK_PID=$!
for i in $(seq 30); do
    (echo > /dev/tcp/127.0.0.1/$PORTA_REST) 2>/dev/null && break
    sleep 0.1
done

## avvio del server FTP di prova
if [ -f var/test/ftp.mock ]; then
    $ESEGUI python3 -m pyftpdlib -i 127.0.0.1 -p $PORTA_FTP -w -d var/test/ftp.mock.d -u test -P $FTP_PASSWORD > /dev/null 2>&1 &
    FTP_PID=$!
    for i in $(seq 30); do
        (echo > /dev/tcp/127.0.0.1/$PORTA_FTP) 2>/dev/null && break
        sleep 0.1
    done
fi

## generazione degli actor
$ESEGUI $CODECEPT build -c _usr/_test/codeception.yml --no-ansi > /dev/null
CODECEPTION_EXIT_CODE=$?

## esecuzione delle suite
if [ "$CODECEPTION_EXIT_CODE" = "0" ]; then
    for s in $SUITE; do
        touch var/test/rest.mock var/test/log.remoti
        [ -f var/test/ftp.mock ] && touch var/test/ftp.mock
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

## arresto del finto REST
pkill -P $REST_MOCK_PID 2>/dev/null
kill $REST_MOCK_PID 2>/dev/null
rm -f var/test/rest.mock

## arresto del server FTP di prova e della sorgente dei log remoti
if [ -n "$FTP_PID" ]; then
    pkill -P $FTP_PID 2>/dev/null
    kill $FTP_PID 2>/dev/null
fi
rm -f var/test/ftp.mock var/test/log.remoti

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
SALTATI=$(awk '
    /^Signature: / { firma = $2 }
    /I mark test (skipped|incomplete) / { m = $0; sub( /^.*I mark test (skipped|incomplete) "?/, "", m ); sub( /"$/, "", m ); printf( "- `%s`: %s\n", firma, m ) }
' "$ESECUZIONE/test.log" 2>/dev/null)
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
    # i test saltati non fanno fallire l'esecuzione, ma sono test che non hanno girato: quasi sempre al deploy
    # manca una risorsa ( una configurazione, un segreto, un servizio ), e la cosa giusta e' dargliela; il
    # motivo non sta nel report JUnit, che ha solo <skipped/>, quindi si prende dal log, dove con --steps
    # Codeception scrive la firma del test e poi la riga "I mark test skipped" col messaggio
    if [ -n "$SALTATI" ]; then
        echo
        echo "## saltati"
        echo
        echo "Non hanno girato: vanno fatti girare dando al deploy le risorse che chiedono."
        echo
        echo "$SALTATI"
    fi
} > "$ESECUZIONE/esito.md"
[ "$(id -u)" = "0" ] && chown -R www-data:www-data "$ESECUZIONE"

## pubblicazione dell'esito
# la fa il generatore della documentazione, che ne condivide la protezione e la pagina; se fallisce i
# risultati restano comunque in var/spool/test/
./_src/_sh/_docs.build.sh --test > /dev/null || echo "pubblicazione dell'esito non riuscita: lanciare _src/_sh/_docs.build.sh --test" >&2

echo
echo "risultati in $ESECUZIONE/"

## avviso dei test saltati
# non cambia il codice di uscita, perche' un test saltato non e' un test fallito, ma non deve passare inosservato
if [ -n "$SALTATI" ]; then
    echo >&2
    echo "ATTENZIONE: $(echo "$SALTATI" | wc -l) test saltati, che vanno fatti girare dando al deploy le risorse che chiedono:" >&2
    echo "$SALTATI" | sed 's/`//g' >&2
fi

## codice di uscita
exit $CODECEPTION_EXIT_CODE

## NOTA
#
# per approfondire vedi _usr/_docs/_read/180.test.md
#
# per approfondire vedi anche https://codeception.com/docs/AcceptanceTests
#
