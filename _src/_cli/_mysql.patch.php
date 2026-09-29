<?php

    /**
     * applicazione delle patch del database da riga di comando
     *
     * Questo file e' l'entry point PHP con cui _src/_sh/_database.rebuild.check.sh applica le patch al database di
     * prova, e non va lanciato direttamente: lavora nella cartella da cui lo script wrapper ha fatto cd, cioe' la
     * document root.
     *
     * introduzione
     * ============
     * Applica al database indicato le patch di _usr/_database/_patch/ ( e di usr/database/patch/ ) che non ha ancora
     * ricevuto, con le funzioni mysqlPatch...() di _src/_lib/_mysql.tools.php: sono le stesse regole del task
     * _src/_api/_task/_mysql.patch.php e di _src/_sh/_mysql.upgrade.sh, scritte una volta sola. Su un database vuoto
     * le patch lo creano da zero. Si ferma al primo errore.
     *
     * uso: php _src/_cli/_mysql.patch.php <indirizzo> <porta> <utente> <database>
     *
     * La password arriva nella variabile d'ambiente MYSQL_PWD, come ai client mysql, e non compare mai sulla riga di
     * comando. Per ogni file stampa quante patch ha applicato, poi le segnalazioni della lettura e l'eventuale errore.
     * Esce con 0 se tutto e' andato bene, 1 se una patch e' fallita, 2 se non riesce a collegarsi o a leggere il
     * livello di patch.
     *
     * dipendenze
     * ==========
     * NON esegue il bootstrap del framework, per le stesse ragioni di _src/_cli/_docs.build.php: include soltanto
     * _src/_lib/_mysql.tools.php, le cui funzioni per le patch non dipendono da nient'altro.
     *
     * licenza
     * =======
     * Questo file fa parte del progetto GlisWeb (https://github.com/istricesrl/glisweb) ed e'
     * distribuita sotto licenza Open Source.
     *
     */

    // la document root e' la cartella da cui lo script wrapper ha gia' fatto cd
    $docroot = rtrim( getcwd(), '/' ) . '/';

    // libreria delle patch
    require_once $docroot . '_src/_lib/_mysql.tools.php';

    // argomenti
    if( count( $argv ) < 5 ) {
        fwrite( STDERR, 'uso: php ' . $argv[0] . ' <indirizzo> <porta> <utente> <database>' . PHP_EOL );
        exit( 2 );
    }

    list( , $addr, $port, $user, $db ) = $argv;

    // connessione; gli errori si leggono dai codici, come in _mysql.upgrade.sh
    mysqli_report( MYSQLI_REPORT_OFF );
    $cn = mysqli_init();
    mysqli_options( $cn, MYSQLI_OPT_CONNECT_TIMEOUT, 6 );
    if( ! @mysqli_real_connect( $cn, $addr, $user, (string) getenv( 'MYSQL_PWD' ), $db, (int) $port ) ) {
        echo '  ERRORE: connessione non riuscita: ' . mysqli_connect_errno() . ' ' . mysqli_connect_error() . PHP_EOL;
        exit( 2 );
    }

    // stessa collation della connessione del framework ( _src/_config/_125.mysql.php )
    mysqli_set_charset( $cn, 'utf8' );
    mysqli_query( $cn, 'SET NAMES utf8mb4 COLLATE utf8mb4_general_ci' );

    // livello di patch
    $level = mysqlPatchLevel( $cn );
    if( $level === false ) {
        echo '  ERRORE: livello di patch illeggibile: ' . mysqli_errno( $cn ) . ' ' . mysqli_error( $cn ) . PHP_EOL;
        exit( 2 );
    }

    // lettura e applicazione
    $files = mysqlPatchFiles( $docroot );
    $warnings = array();
    $patches = mysqlPatchRead( $files, $level, $warnings );
    $error = array();
    $done = mysqlPatchApply( $cn, $patches, $error );

    // riepilogo per file: su un database vuoto le patch sono migliaia
    $perFile = array();
    foreach( $done as $p ) {
        $perFile[ $p['file'] ][] = $p['id'];
    }
    echo '  ' . count( $files ) . ' file, livello di partenza ' . $level . PHP_EOL;
    foreach( $perFile as $f => $ids ) {
        printf( '    %-58s %4d  %s' . PHP_EOL, str_replace( $docroot, '', $f ), count( $ids ),
            ( count( $ids ) > 1 ) ? reset( $ids ) . ' .. ' . end( $ids ) : reset( $ids ) );
    }

    // segnalazioni della lettura
    foreach( $warnings as $w ) {
        echo '  ATTENZIONE: ' . $w . PHP_EOL;
    }

    // livello raggiunto
    $last = ( empty( $done ) ) ? $level : end( $done )['id'];

    // errore
    if( ! empty( $error ) ) {
        echo '  ERRORE nella patch ' . $error['id'] . ( ( empty( $error['file'] ) ) ? '' : ' di ' . str_replace( $docroot, '', $error['file'] ) ) . ': ' . $error['errno'] . ' ' . $error['error'] . PHP_EOL;
        echo '    ' . str_replace( PHP_EOL, PHP_EOL . '    ', substr( trim( $error['query'] ), 0, 600 ) ) . PHP_EOL;
        echo '  livello di patch fermo a ' . $last . ': le patch successive non sono state applicate' . PHP_EOL;
        exit( 1 );
    }

    echo '  patch applicate: ' . count( $done ) . ', livello di patch: ' . $level . ' -> ' . $last . PHP_EOL;
    exit( 0 );
