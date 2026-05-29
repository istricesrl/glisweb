<?php

    /**
     * file di applicazione della configurazione della sessione PHP
     *
     * In questo file vengono applicate le policy di sessione (durata massima, sicurezza dei cookie,
     * lazy write) e viene avviata la sessione PHP. La sessione viene poi collegata agli array $cf
     * e $ct tramite puntatore in modo che i dati di sessione siano disponibili sia internamente al
     * framework sia al template manager. Questo runlevel segue il 050 che ha già scelto il backend di
     * salvataggio (Redis, Memcache o Apache), quindi qui ci si concentra solo sull'apertura della
     * sessione e sull'integrazione con il resto del framework.
     *
     */

    // debug
    // print_r( $cf['debug'] );
    // error_reporting( E_ALL );
    // ini_set( 'display_errors', TRUE );
    // echo 'OUTPUT';

    /**
     * dichiarazione delle costanti
     * ============================
     * In questa sezione viene definita la costante SESSION_LIMIT che esprime in secondi la durata
     * massima della sessione (default 3600 = 1 ora). La costante viene definita solo se non è già
     * stata dichiarata altrove, in modo da consentirne la sovrascrittura da custom.
     *
     */

    // costante per la durata massima della sessione
    if( ! defined( 'SESSION_LIMIT' ) ) {
        define( 'SESSION_LIMIT', 3600 );
    }

    /**
     * avvio della sessione
     * ====================
     * In questa sezione vengono applicate le policy della sessione e viene avviata. Si controlla
     * preventivamente che l'output non sia già iniziato (in caso contrario session_start() fallirebbe
     * silenziosamente); si imposta lazy_write a 0 per scrivere immediatamente sui backend di rete;
     * si applicano le policy di sicurezza sui cookie (HttpOnly, Secure). Una volta avviata la
     * sessione viene registrato il session_id e, se la sessione è appena nata, viene salvato il
     * timestamp di creazione in $_SESSION['used'] (utile per il TTL).
     *
     */

    // controllo output
    if( headers_sent( $wf, $wl ) ) {
        die( 'output iniziato in ' . $wf . ' linea ' . $wl );
    }

    // timer
    timerCheck( $cf['speed'], '-> inizio avvio sessione' );

    // policy di performance
    ini_set( 'session.lazy_write', 0 );

    // policy di sicurezza
    // ini_set( 'session.cookie_samesite', 'strict' );
    ini_set( 'session.cookie_samesite', 'Lax' );
    ini_set( 'session.cookie_httponly', 1 );
    ini_set( 'session.cookie_secure', 1 );

    // gestione degli header di sessione per la cache
    // session_cache_limiter('');
    // ini_set('session.cache_limiter', '');

    // avvio della sessione php
    if( session_start() ) {

        // registro l'id della sessione nell'array $cf
        $_SESSION['id']                = session_id();

        // imposto il tempo se la sessione è appena stata creata
        if( ! isset( $_SESSION['used'] ) ) {
            $_SESSION['used']            = time();
        }

        // log
        logger( 'avviata la sessione ' . $_SESSION['id'], 'session' );

    } else {

        // log
        logger( 'impossibile avviare la sessione', 'session', LOG_CRIT );

        // errore
        die( 'impossibile avviare la sessione' );

    }

    // timer
    timerCheck( $cf['speed'], '-> fine avvio sessione' );

    // debug
    // $h = fopen( DIRECTORY_BASE . 'var/log/sessions.debug', 'a+' );
    // fwrite( $h, date('Y-m-d H:i:s') . ' ' . session_id() . ' -> current' . PHP_EOL );
    // fclose( $h );

    /**
     * connessione della sessione a $cf e $ct
     * ======================================
     * I dati di sessione vengono collegati per riferimento all'array $cf e da qui all'array $ct,
     * in modo che siano disponibili sia internamente al framework sia al template manager senza
     * doverli copiare.
     *
     */

    // connetto i dati della sessione all'array $cf
    $cf['session'] = &$_SESSION;

    // collegamento all'array $ct
    $ct['session'] = &$cf['session'];

    /**
     * debug del runlevel
     * ==================
     * In questa sezione sono presenti, commentate, delle righe utili per il debug di questo runlevel,
     * fra cui la stampa del session_id e dell'intero array $cf['session'].
     *
     */

    // debug
    // echo 'sessione ' . session_id();
    // print_r( $cf['session'] );
    // echo 'OUTPUT';
