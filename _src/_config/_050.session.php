<?php

    /**
     * file di configurazione della sessione PHP
     *
     * utilizzo delle sessioni
     * =======================
     * Il framework fa ampio ricorso alle sessioni per mantenere in memoria una grande quantità
     * di variabili. Se le sessioni non funzionano, GRAN PARTE DEL FRAMEWORK DARÀ PROBLEMI. Per ottimizzare le prestazioni
     * e per funzionare in ambiente containerizzato il framework cerca di stoccare le sessioni su Redis come opzione
     * di default; solo in caso di assenza del server Redis viene utilizzato il normale sistema di salvataggio su file
     * di Apache (che però non è compatibile con un ambiente containerizzato e orchestrato).
     *
     *
     *
     * TODO reimplementare il TTL per la durata massima delle sessioni
     * TODO reimplementare il TTL per la durata massima dell'inattività delle sessioni
     * TODO documentare
     *
     *
     *
     */

    // backend per il salvataggio delle sessioni
    if( isset( $cf['redis']['connection'] ) && ! empty( $cf['redis']['connection'] ) ) {

        // settaggi per Redis
        ini_set( 'session.save_handler', 'redis' );
        ini_set( 'session.save_path', 'tcp://'.$cf['redis']['server']['address'].':'.$cf['redis']['server']['port'] );

        // NOTA per testare le sessioni redis usare redis-cli sulla macchina dove gira redis e poi lanciare il comando
        // KEYS * per vedere tutte le chiavi registrate; si può anche fare FLUSHALL e poi dopo un po' KEYS * per controllare
        // che le nuove sessioni vengano correttamente create

        // tipo di sessione
        define( 'SESSION_TYPE', SESSION_REDIS );

        // log
        logger( 'sessione salvata su REDIS', 'session' );

    } elseif( isset( $cf['memcache']['connection'] ) && ! empty( $cf['memcache']['connection'] ) ) {

        // settaggi per Memcache
        ini_set( 'session.save_handler', 'memcached' );
        ini_set( 'session.save_path', $cf['memcache']['server']['address'].':'.$cf['memcache']['server']['port'] );
        ini_set( 'memcached.sess_locking', 'off' );

        // tipo di sessione
        define( 'SESSION_TYPE', SESSION_MEMCACHE );

        // log
        logger( 'sessione salvata su MEMCACHE', 'session' );

    } else {

        // tipo di sessione
        define( 'SESSION_TYPE', SESSION_APACHE );

        // log
        logger( 'sessione salvata su Apache', 'session' );

    }

    // debug
    // die( ini_get( 'session.save_handler' ) );
    // die( print_r( $cf['memcache'], true ) );
