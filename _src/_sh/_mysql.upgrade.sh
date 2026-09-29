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
# COME LEGGE LE PATCH. Come il task, riga per riga: un marcatore `-- | <livello>` apre una patch,
# le righe che seguono ( commenti esclusi ) si accumulano e la patch si esegue quando arriva il
# marcatore SUCCESSIVO, come UNA sola query. Si applica solo cio' che sta sopra il livello
# registrato in __patch__, si registra ogni patch eseguita e ci si ferma al primo errore. Le
# regole sono duplicate qui perche' il task non si puo' includere fuori dal framework avviato
# ( vuole la connessione e i privilegi del bootstrap ): se cambiano la', vanno cambiate anche qui
# e nello spezzatore di _database.rebuild.check.sh.
#
# uso: _mysql.upgrade.sh <STATO> [ --server <nome> ] [ --si ] [ --senza-backup ]
#
#   STATO           DEV | TEST | PROD
#   --server        il server del profilo su cui lavorare, se non e' il primo
#   --si            applica davvero; senza, elenca le patch che applicherebbe e non tocca niente
#   --senza-backup  salta il dump preventivo ( sconsigliato: serve dove il dump lo ha appena fatto
#                   qualcun altro, ad esempio _backup.nightly.sh )
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

while [ $# -gt 0 ]; do
    case "$1" in
        --server)       SERVER="$2"; shift 2 ;;
        --si)           ESEGUI=1; shift ;;
        --senza-backup) BACKUP=0; shift ;;
        *)              [ -z "$STATO" ] && STATO="$1"; shift ;;
    esac
done

if [ -z "$STATO" ]; then
    echo "uso: $( basename $0 ) <DEV|TEST|PROD> [ --server <nome> ] [ --si ] [ --senza-backup ]"
    exit 1
fi

## i dump non devono essere leggibili da chiunque abbia una shell
umask 027

echo "patch del database in $DOCROOT ( stato $STATO )"
[ "$ESEGUI" = "1" ] && echo "  MODO: esecuzione" || echo "  MODO: solo elenco ( aggiungi --si per applicare )"
echo

php -d error_reporting=E_ALL -- "$DOCROOT" "$STATO" "$SERVER" "$ESEGUI" "$BACKUP" "$DEST" <<'PHP'
<?php

    list( , $docroot, $stato, $server, $esegui, $backup, $dest ) = $argv;

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

    $cn = mysqli_init();
    mysqli_options( $cn, MYSQLI_OPT_CONNECT_TIMEOUT, 6 );
    if( ! @mysqli_real_connect( $cn, $addr, $user, $pasw, $s['db'], $port ) ) {
        echo '  ERRORE: connessione non riuscita: ' . mysqli_connect_errno() . ' ' . mysqli_connect_error() . PHP_EOL;
        exit( 1 );
    }

    // stessa collation della connessione del framework ( _src/_config/_125.mysql.php )
    mysqli_set_charset( $cn, 'utf8' );
    mysqli_query( $cn, 'SET NAMES utf8mb4 COLLATE utf8mb4_general_ci' );

    // livello di patch del database; senza tabella __patch__ il database e' da creare
    $r = mysqli_query( $cn, 'SELECT id AS patch_level FROM __patch__ ORDER BY id DESC LIMIT 1' );
    $patchLevel = ( $r ) ? ( mysqli_fetch_row( $r )[0] ?? NULL ) : NULL;
    if( empty( $patchLevel ) ) {
        $patchLevel = '000000000000';
    }
    $livelloIniziale = $patchLevel;

    echo '  livello di patch attuale: ' . $patchLevel . PHP_EOL;

    // i file di patch, standard e custom, come li cerca il task con glob2custom()
    $pFiles = array();
    foreach( glob( $docroot . '/{,_}usr/{,_}database/{,_}patch/{,_}*.*.sql', GLOB_BRACE ) as $f ) {
        if( is_file( $f ) ) {
            $pFiles[] = $f;
        }
    }
    $pFiles = array_unique( $pFiles );
    sort( $pFiles );

    // le patch da applicare, nell'ordine: ogni voce e' array( file, id, query )
    //
    // NOTA il livello avanza come nel task, cioe' a ogni patch che si applicherebbe: l'elenco a
    // vuoto ( senza --si ) e' quindi lo stesso che l'esecuzione applichera'
    $daApplicare = array();
    $simulato = $patchLevel;

    foreach( $pFiles as $pFile ) {

        // livello del file dal nome, come nel task
        $pFilePatchLevel = substr( str_replace( '_', '', basename( $pFile ) ), 0, 12 );

        if( $pFilePatchLevel > $simulato ) {

            $pId = '';
            $pQuery = '';
            $coda = false;

            foreach( file( $pFile, FILE_IGNORE_NEW_LINES ) as $row ) {

                if( substr( trim( $row ), 0, 4 ) == '-- |' ) {

                    if( ! empty( trim( $pQuery ) ) && $pId > $simulato ) {
                        $daApplicare[] = array( $pFile, $pId, $pQuery );
                        $simulato = $pId;
                    }

                    $pId = substr( $row, 5, 12 );
                    if( $pId == '------------' ) { $pId = date( 'YmdHis' ); }
                    $pQuery = '';

                } elseif( substr( trim( $row ), 0, 2 ) !== '--' ) {

                    $pQuery .= $row . PHP_EOL;

                }

            }

            // il task butta via in silenzio cio' che sta dopo l'ultimo marcatore: qui almeno si dice
            if( ! empty( trim( $pQuery ) ) ) {
                echo '  ATTENZIONE: ' . basename( $pFile ) . ' ha SQL dopo l\'ultimo marcatore, che non viene eseguito ( manca `-- | FINE` in fondo )' . PHP_EOL;
            }

        }

    }

    if( empty( $daApplicare ) ) {
        echo '  nessuna patch da applicare: il database e\' allineato' . PHP_EOL;
        exit( 0 );
    }

    // riepilogo per file: su un database vuoto le patch sono centinaia
    $perFile = array();
    foreach( $daApplicare as $p ) {
        $perFile[ $p[0] ][] = $p[1];
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

    }

    // la tabella delle patch, identica a quella che crea il task
    mysqli_query(
        $cn,
        'CREATE TABLE IF NOT EXISTS `__patch__` (
            `id` char(12) NOT NULL PRIMARY KEY,
            `patch` text COLLATE utf8_unicode_ci,
            `timestamp_esecuzione` int(11) DEFAULT NULL,
            `token` char(128) DEFAULT NULL,
            `note_esecuzione` text
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8;'
    );

    echo PHP_EOL;

    // applicazione, una patch per volta; ci si ferma al primo errore, come nel task
    foreach( $daApplicare as $p ) {

        list( $pFile, $pId, $pQuery ) = $p;

        mysqli_query( $cn, $pQuery );

        if( mysqli_errno( $cn ) ) {
            echo '  ERRORE nella patch ' . $pId . ' di ' . basename( $pFile ) . ': ' . mysqli_errno( $cn ) . ' ' . mysqli_error( $cn ) . PHP_EOL;
            echo trim( $pQuery ) . PHP_EOL;
            echo '  livello di patch fermo a ' . $patchLevel . ': le patch successive non sono state applicate' . PHP_EOL;
            exit( 1 );
        }

        $st = mysqli_prepare( $cn, 'INSERT IGNORE INTO `__patch__` ( id, patch, timestamp_esecuzione, note_esecuzione ) VALUES ( ?, ?, ?, ? )' );
        $testo = trim( $pQuery );
        $ora = time();
        $nota = 'OK';
        mysqli_stmt_bind_param( $st, 'ssis', $pId, $testo, $ora, $nota );
        mysqli_stmt_execute( $st );

        if( mysqli_errno( $cn ) ) {
            echo '  ERRORE nella scrittura di ' . $pId . ' sulla tabella delle patch: ' . mysqli_error( $cn ) . PHP_EOL;
            exit( 1 );
        }

        echo '  patch ' . $pId . ' applicata correttamente' . PHP_EOL;
        $patchLevel = $pId;

    }

    echo PHP_EOL . '  livello di patch: ' . $livelloIniziale . ' -> ' . $patchLevel . PHP_EOL;
PHP

ESITO=$?

echo
echo "fine"

exit $ESITO
