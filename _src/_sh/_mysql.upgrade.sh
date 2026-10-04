#!/bin/bash

## AGGIORNAMENTO DEL DATABASE CON LE PATCH, DA RIGA DI COMANDO
#
# Applica al database del profilo le patch di _usr/_database/_patch/ ( e di usr/database/patch/,
# se il progetto ne ha ) che non ha ancora ricevuto, con le stesse regole del task
# /task/mysql.patch ( _src/_api/_task/_mysql.patch.php ): e' il modo di farlo senza browser e
# senza una sessione con il privilegio GESTIONE_MYSQL, cioe' da una shell o da uno script di
# deploy. Su un database vuoto le patch lo creano da zero, esattamente come fa il task.
#
# STORIA. Lo script nasce nel 2021 per un meccanismo che non c'e' piu': esportava dati e
# struttura, faceva DROP DATABASE senza chiedere, lo ricreava e ricaricava
# _usr/_database/mysql.schema.sql e mysql.data.sql. Quei due file sono stati sostituiti dalle
# patch numerate, e lo script e' rimasto a dire «cartella non trovata». Il 29/09/2026 e' stato
# riscritto sul meccanismo attuale. Le patch sono incrementali, quindi per aggiornare non serve
# piu' cancellare niente: questo script NON fa DROP DATABASE in nessun caso.
#
# COME LEGGE LE PATCH. Non lo sa: lo chiede alle funzioni mysqlPatch...() di
# _src/_lib/_mysql.tools.php, le stesse che usano il task e _database.rebuild.check.sh, e che si
# possono includere senza il bootstrap del framework. Un marcatore `-- | <livello>` apre una patch,
# le righe che seguono ( commenti esclusi ) si accumulano e ogni patch e' UNA sola query; si applica
# solo cio' che sta sopra il livello registrato in __patch__, si registra ogni patch eseguita e ci
# si ferma al primo errore. Fino al 29/09/2026 queste regole erano copiate qui, nel task e in
# _database.rebuild.check.sh, e le tre copie si comportavano in modo diverso.
#
# uso: _mysql.upgrade.sh <STATO> [ --server <nome> ] [ --si ] [ --senza-backup ] [ --fino <livello> ]
#
#   STATO           DEV | TEST | PROD
#   --server        il server del profilo su cui lavorare, se non e' il primo
#   --si            applica davvero; senza, elenca le patch che applicherebbe e non tocca niente
#   --senza-backup  salta il dump preventivo ( sconsigliato: serve dove il dump lo ha appena fatto
#                   qualcun altro, ad esempio _backup.nightly.sh )
#   --fino          applica le patch fino a questo livello compreso, e non oltre: per smaltire un
#                   arretrato fermandosi prima di una patch che chiede di guardare il deploy, come la
#                   conversione degli id ( _202609301900.id.numerici.sql: --fino 202609301859 )
#
# PRIMA DI APPLICARE fa un dump del database nella cartella dei backup del progetto, un livello
# sopra la document root, con lo stesso nome e la stessa rotazione dei dump di _backup.nightly.sh.
# Se il dump non riesce non applica niente.
#
# Lo STATO va detto, come in _backup.nightly.sh: in shell non c'e' alcuna richiesta HTTP, quindi la
# regola del bootstrap ( ricavare SITE_STATUS dall'HTTP_HOST ) non si puo' applicare. Meglio dirlo
# che indovinarlo: una patch applicata all'ambiente sbagliato non si ritira.
#
# NOTA sulle credenziali: si leggono da src/shadow.json e src/config.json, cioe' dalla stessa fonte
# del framework, con shadow che vince su config. Stesso schema di _backup.nightly.sh. La password
# non passa mai dalla riga di comando: a mysqldump arriva con MYSQL_PWD, alla connessione per le
# patch direttamente da PHP.

## livelli per la root del sito
RL="../../"

## directory corrente
cd $(dirname "$0") || exit 1

## libreria di funzioni
. ./_lib/_functions.sh

## servono i privilegi di root: si legge shadow.json e si scrive fuori dalla document root
check-root

## dalla cartella degli script alla document root
cd $RL || exit 1
DOCROOT=$( pwd )

## la cartella dei backup, la stessa di _backup.nightly.sh
DEST=$( dirname "$DOCROOT" )/$BACKUP_SUBDIR

## argomenti
STATO=""
SERVER=""
ESEGUI=0
BACKUP=1
FINO=""

while [ $# -gt 0 ]; do
    case "$1" in
        --server)       SERVER="$2"; shift 2 ;;
        --si)           ESEGUI=1; shift ;;
        --senza-backup) BACKUP=0; shift ;;
        --fino)         FINO="$2"; shift 2 ;;
        *)              [ -z "$STATO" ] && STATO="$1"; shift ;;
    esac
done

if [ -z "$STATO" ]; then
    echo "uso: $( basename $0 ) <DEV|TEST|PROD> [ --server <nome> ] [ --si ] [ --senza-backup ] [ --fino <livello> ]"
    exit 1
fi

## i dump non devono essere leggibili da chiunque abbia una shell
umask 027

echo "patch del database in $DOCROOT ( stato $STATO )"
[ "$ESEGUI" = "1" ] && echo "  MODO: esecuzione" || echo "  MODO: solo elenco ( aggiungi --si per applicare )"
echo

php -d error_reporting=E_ALL -- "$DOCROOT" "$STATO" "$SERVER" "$ESEGUI" "$BACKUP" "$DEST" "$FINO" <<'PHP'
<?php

    list( , $docroot, $stato, $server, $esegui, $backup, $dest, $fino ) = $argv;

    // le regole delle patch: lettura, livello, esecuzione
    require_once $docroot . '/_src/_lib/_mysql.tools.php';

    // lettura della configurazione, come in _backup.nightly.sh
    function carica( $f ) {
        $j = ( is_readable( $f ) ) ? json_decode( file_get_contents( $f ), true ) : NULL;
        return ( is_array( $j ) ) ? $j : array();
    }

    $cf = carica( $docroot . '/src/config.json' );
    $sh = carica( $docroot . '/src/shadow.json' );

    // fusione minima, come fa il framework: shadow vince su config
    $servers = $cf['mysql']['servers'] ?? array();
    foreach( $sh['mysql']['servers'] ?? array() as $k => $v ) {
        $servers[ $k ] = array_replace( $servers[ $k ] ?? array(), $v );
    }

    // il profilo dichiara quali server usare per questo stato
    $nomi = (array) ( $cf['mysql']['profiles'][ $stato ]['servers'] ?? array() );
    if( empty( $nomi ) ) {
        echo '  ERRORE: nessun server dichiarato in mysql.profiles.' . $stato . PHP_EOL;
        exit( 1 );
    }

    // il server su cui lavorare
    if( empty( $server ) ) {
        $server = reset( $nomi );
    } elseif( ! in_array( $server, $nomi ) ) {
        echo '  ERRORE: il server ' . $server . ' non fa parte di mysql.profiles.' . $stato . PHP_EOL;
        exit( 1 );
    }

    $s = $servers[ $server ] ?? array();
    if( empty( $s['db'] ) ) {
        echo '  ERRORE: il server ' . $server . ' non dichiara un database' . PHP_EOL;
        exit( 1 );
    }

    $addr = ( ! empty( $s['address'] ) ) ? $s['address'] : '127.0.0.1';
    $port = ( ! empty( $s['port'] ) ) ? (int) $s['port'] : 3306;
    $user = ( ! empty( $s['username'] ) ) ? $s['username'] : 'root';
    $pasw = $s['password'] ?? '';

    echo '  database ' . $s['db'] . ' su ' . $addr . ' ( server ' . $server . ' )' . PHP_EOL;

    // gli errori si leggono da mysqli_errno(), come nel task
    mysqli_report( MYSQLI_REPORT_OFF );

    // la connessione si apre qui e si riapre dopo il dump preventivo, quindi sta in una funzione
    $connetti = function() use ( $addr, $user, $pasw, $s, $port ) {

        $cn = mysqli_init();
        mysqli_options( $cn, MYSQLI_OPT_CONNECT_TIMEOUT, 6 );
        if( ! @mysqli_real_connect( $cn, $addr, $user, $pasw, $s['db'], $port ) ) {
            echo '  ERRORE: connessione non riuscita: ' . mysqli_connect_errno() . ' ' . mysqli_connect_error() . PHP_EOL;
            exit( 1 );
        }

        // stessa collation della connessione del framework ( _src/_config/_125.mysql.php )
        mysqli_set_charset( $cn, 'utf8' );
        mysqli_query( $cn, 'SET NAMES utf8mb4 COLLATE utf8mb4_general_ci' );

        return $cn;

    };

    $cn = $connetti();

    // livello di patch del database; senza tabella __patch__ il database e' da creare
    $patchLevel = mysqlPatchLevel( $cn );
    if( $patchLevel === false ) {
        echo '  ERRORE: livello di patch illeggibile: ' . mysqli_errno( $cn ) . ' ' . mysqli_error( $cn ) . PHP_EOL;
        exit( 1 );
    }
    $livelloIniziale = $patchLevel;

    echo '  livello di patch attuale: ' . $patchLevel . PHP_EOL;

    // le patch da applicare, nell'ordine; l'elenco a vuoto ( senza --si ) e' lo stesso che l'esecuzione applichera'
    $segnalazioni = array();
    $daApplicare = mysqlPatchRead( mysqlPatchFiles( $docroot . '/' ), $patchLevel, $segnalazioni );

    // con --fino ci si ferma a quel livello: le patch dopo restano da applicare
    if( ! empty( $fino ) ) {
        $oltre = count( $daApplicare );
        $daApplicare = array_values( array_filter( $daApplicare, function( $p ) use ( $fino ) { return $p['id'] <= $fino; } ) );
        $oltre -= count( $daApplicare );
        if( $oltre ) {
            echo '  --fino ' . $fino . ': ' . $oltre . ' patch oltre questo livello restano da applicare' . PHP_EOL;
        }
    }

    // SQL fuori dalle patch e id non crescenti: non si applicano, ma si dice
    foreach( $segnalazioni as $w ) {
        echo '  ATTENZIONE: ' . $w . PHP_EOL;
    }

    if( empty( $daApplicare ) ) {
        echo '  nessuna patch da applicare: il database e\' allineato' . PHP_EOL;
        exit( 0 );
    }

    // riepilogo per file: su un database vuoto le patch sono centinaia
    $perFile = array();
    foreach( $daApplicare as $p ) {
        $perFile[ $p['file'] ][] = $p['id'];
    }
    echo '  patch da applicare: ' . count( $daApplicare ) . PHP_EOL;
    foreach( $perFile as $f => $ids ) {
        printf( '    %-58s %4d  %s' . PHP_EOL, str_replace( $docroot . '/', '', $f ), count( $ids ),
            ( count( $ids ) > 1 ) ? reset( $ids ) . ' .. ' . end( $ids ) : reset( $ids ) );
    }

    if( $esegui != '1' ) {
        echo '  ( solo elenco: niente e\' stato toccato )' . PHP_EOL;
        exit( 0 );
    }

    // dump preventivo: stesso nome e stessa cartella di _backup.nightly.sh, cosi' ne segue la rotazione
    if( $backup == '1' ) {

        if( ! is_dir( $dest ) ) {
            mkdir( $dest, 0750, true );
        }

        $out = $dest . '/backup.db.' . $s['db'] . '.' . date( 'YmdHis' ) . '.sql.gz';
        echo PHP_EOL . '  dump preventivo -> ' . $out . PHP_EOL;

        // prima con le routine, poi senza: l'utente applicativo non sempre puo' leggerle
        $esito = 1;
        foreach( array( array( '--routines', '--events' ), array() ) as $routine ) {
            $cmd = array_merge(
                array( 'mysqldump', '-h', $addr, '-P', (string) $port, '-u', $user,
                       '--opt', '--single-transaction', '--default-character-set=utf8mb4' ),
                $routine,
                array( $s['db'] )
            );
            $env = array_merge( getenv(), array( 'MYSQL_PWD' => $pasw ) );
            // NOTA il comando come stringa e non come array: l'array lo accetta solo PHP 7.4, e su una macchina
            // con PHP 7.3 proc_open() falliva, il dump risultava fallito e nessuna patch veniva applicata
            $cmd = implode( ' ', array_map( 'escapeshellarg', $cmd ) );
            $p = proc_open( $cmd, array( 1 => array( 'pipe', 'w' ), 2 => array( 'pipe', 'w' ) ), $pipes, NULL, $env );
            if( ! is_resource( $p ) ) { break; }
            $gz = gzopen( $out, 'wb' );
            while( ! feof( $pipes[1] ) ) {
                gzwrite( $gz, fread( $pipes[1], 1 << 20 ) );
            }
            gzclose( $gz );
            $err = stream_get_contents( $pipes[2] );
            fclose( $pipes[1] );
            fclose( $pipes[2] );
            $esito = proc_close( $p );
            if( $esito == 0 ) {
                if( empty( $routine ) ) {
                    echo '  NOTA: routine e eventi NON inclusi ( privilegi insufficienti ); le definizioni stanno nelle patch' . PHP_EOL;
                }
                break;
            }
        }

        if( $esito != 0 ) {
            @unlink( $out );
            echo '  ERRORE nel dump: ' . substr( trim( $err ?? '' ), 0, 300 ) . PHP_EOL;
            echo '  nessuna patch applicata ( --senza-backup per procedere comunque )' . PHP_EOL;
            exit( 1 );
        }

        chmod( $out, 0640 );
        echo '  fatto: ' . sprintf( '%.1f', filesize( $out ) / 1048576 ) . ' MB' . PHP_EOL;

        // NOTA la connessione e' rimasta inattiva per tutta la durata del dump: se questa supera il wait_timeout
        // il server la chiude, e la prima query delle patch muore con 2006 MySQL server has gone away ( polmasi
        // DEV, 04/10/2026: dump di 65 secondi contro un wait_timeout di 60 ); la si riapre invece di contarci
        @mysqli_close( $cn );
        $cn = $connetti();

    }

    echo PHP_EOL;

    // applicazione, una patch per volta; la tabella __patch__ la crea mysqlPatchApply() se non c'e'
    $errore = array();
    foreach( mysqlPatchApply( $cn, $daApplicare, $errore ) as $p ) {
        echo '  patch ' . $p['id'] . ' applicata correttamente' . PHP_EOL;
        $patchLevel = $p['id'];
    }

    // ci si ferma al primo errore, come nel task
    if( ! empty( $errore ) ) {
        echo '  ERRORE nella patch ' . $errore['id'] . ( ( empty( $errore['file'] ) ) ? '' : ' di ' . basename( $errore['file'] ) ) . ': ' . $errore['errno'] . ' ' . $errore['error'] . PHP_EOL;
        echo trim( $errore['query'] ) . PHP_EOL;
        echo '  livello di patch fermo a ' . $patchLevel . ': le patch successive non sono state applicate' . PHP_EOL;
        exit( 1 );
    }

    echo PHP_EOL . '  livello di patch: ' . $livelloIniziale . ' -> ' . $patchLevel . PHP_EOL;
PHP

ESITO=$?

echo
echo "fine"

exit $ESITO
