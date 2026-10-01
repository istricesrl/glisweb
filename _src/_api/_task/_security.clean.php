<?php

    /**
     * pulizia notturna e resoconto del firewall applicativo
     *
     * Pota lo stato del firewall ( _src/_inc/_macro/_security.php ) e ne scrive il resoconto del giorno prima. Il
     * firewall regge anche senza questo task, perché i bandi scaduti li toglie lui a ogni nuovo bando; qui si fa il
     * resto:
     *
     * - si tolgono i bandi scaduti in var/spool/security/ban/, che Apache altrimenti continuerebbe a respingere;
     * - si cancellano i registri di rateLimitCheck() in var/spool/security/limiti/ fermi da più di
     *   SECURITY_RECIDIVE_TTL, la finestra più lunga che vi si usa;
     * - si cancellano i registri degli IP, i resoconti e i registri migrati più vecchi di SECURITY_LOG_TTL;
     * - si scrive in var/spool/security/resoconti/ il resoconto di ieri, ricavato dai registri degli IP: gli eventi
     *   per tipo, e gli allarmi.
     *
     * Gli allarmi sono i segni di un falso positivo: ogni sblocco con la verifica umana, e un bando o un blocco su una
     * richiesta con un referer dello stesso sito. Quando ce ne sono il resoconto va anche nel log del framework al
     * livello LOG_CRIT, così lo vede chi guarda i log.
     *
     * Va pianificato una volta al giorno, dopo mezzanotte, con una riga nella tabella task:
     *
     *     INSERT INTO task ( minuto, ora, task, iterazioni ) VALUES ( 15, 3, '_src/_api/_task/_security.clean.php', 1 );
     *
     */

    // inclusione del framework
    if( ! defined( 'CRON_RUNNING' ) ) {
        if( ! defined( 'INCLUDE_SUBDIR' ) ) {
            require '../../_config.php';
        } else {
            require INCLUDE_SUBDIR . '_config.php';
        }
    }

    // verifica dei privilegi
    checkTaskPrivilege( 'GESTIONE_SISTEMA' );

    // inizializzo l'array del risultato
    $status = array( 'bandi' => 0, 'limiti' => 0, 'log' => 0, 'allarmi' => array() );

    // bandi scaduti
    foreach( scandir2array( DIR_VAR_SPOOL_SECURITY_BAN ) as $f ) {
        if( filemtime( DIR_VAR_SPOOL_SECURITY_BAN . $f ) < time() && @unlink( DIR_VAR_SPOOL_SECURITY_BAN . $f ) ) {
            $status['bandi']++;
        }
    }

    // registri dei limiti fermi, e registri degli IP, resoconti e registri migrati vecchi
    foreach( array( 'limiti' => array( DIR_VAR_SPOOL_SECURITY . 'limiti/*/*', SECURITY_RECIDIVE_TTL ), 'log' => array( DIR_VAR_SPOOL_SECURITY . '{*.log,banned.hosts.migrato.*.conf,resoconti/*.txt}', SECURITY_LOG_TTL ) ) as $k => $v ) {
        foreach( glob( $v[0], GLOB_BRACE ) as $f ) {
            if( filemtime( $f ) < time() - $v[1] && @unlink( $f ) ) {
                $status[ $k ]++;
            }
        }
    }

    // resoconto di ieri dai registri degli IP scritti da ieri in poi; ogni evento è un blocco di righe che comincia con
    // la data e il testo ( "match per la regola X, bandito per N secondi" ) e ha una riga "indizi:"
    $giorno = date( 'Y-m-d', strtotime( 'yesterday' ) );
    $conteggi = array();
    foreach( glob( DIR_VAR_SPOOL_SECURITY . '*.log' ) as $f ) {
        if( filemtime( $f ) < strtotime( 'yesterday' ) ) {
            continue;
        }
        foreach( explode( PHP_EOL . PHP_EOL, file_get_contents( $f ) ) as $blocco ) {
            if( substr( $blocco, 0, 10 ) != $giorno ) {
                continue;
            }
            $righe = explode( PHP_EOL, $blocco );
            $evento = explode( ', ', substr( $righe[0], 20 ), 2 );
            $esito = ( isset( $evento[1] ) ) ? $evento[1] : '';
            $indizi = preg_grep( '/^indizi: /', $righe );
            $indizi = ( ! empty( $indizi ) ) ? reset( $indizi ) : '';
            $chiave = ( ( strpos( $esito, 'bandito per' ) === 0 ) ? 'bando ' : ( ( strpos( $esito, 'non bandito' ) === 0 ) ? 'risparmiato ' : '' ) ) . $evento[0];
            $conteggi[ $chiave ] = ( isset( $conteggi[ $chiave ] ) ) ? $conteggi[ $chiave ] + 1 : 1;
            // allarmi: uno sblocco, oppure un bando o un blocco su una richiesta con referer interno
            if( strpos( $evento[0], 'sblocco con' ) === 0 || ( strpos( $evento[0], 'match per' ) === 0 && strpos( $indizi, 'referer interno' ) !== false ) ) {
                $status['allarmi'][] = str_replace( PHP_EOL, ' | ', $blocco );
            }
        }
    }
    arsort( $conteggi );

    // scrittura del resoconto
    $resoconto = 'resoconto del firewall applicativo per il ' . $giorno . PHP_EOL . PHP_EOL . 'eventi per tipo' . PHP_EOL;
    foreach( $conteggi as $chiave => $n ) {
        $resoconto .= str_pad( $n, 8, ' ', STR_PAD_LEFT ) . '  ' . $chiave . PHP_EOL;
    }
    $resoconto .= PHP_EOL . 'allarmi: ' . count( $status['allarmi'] ) . PHP_EOL . implode( PHP_EOL, $status['allarmi'] ) . PHP_EOL;
    $resoconto .= PHP_EOL . 'pulizia: ' . $status['bandi'] . ' bandi scaduti, ' . $status['limiti'] . ' registri dei limiti, ' . $status['log'] . ' registri vecchi' . PHP_EOL;
    checkPath( DIR_VAR_SPOOL_SECURITY . 'resoconti/' );
    writeToFile( $resoconto, DIR_VAR_SPOOL_SECURITY . 'resoconti/' . $giorno . '.txt' );
    $status['resoconto'] = DIR_VAR_SPOOL_SECURITY . 'resoconti/' . $giorno . '.txt';

    // con gli allarmi il resoconto va anche nel log del framework
    if( ! empty( $status['allarmi'] ) ) {
        logWrite( $resoconto, 'security', LOG_CRIT );
    }

    // output
    if( ! defined( 'CRON_RUNNING' ) ) {
        buildJson( $status );
    }
