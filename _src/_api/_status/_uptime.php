<?php

    /**
     * stato per il controllo di uptime
     *
     * Risponde all'URL /status/uptime ( regola generica degli status in /.htaccess ) e dice solo se il sito funziona:
     * fa il bootstrap del framework e risponde OK, oppure KO con 503 se il deploy ha un database configurato e la
     * connessione non c'e'. Niente versioni, percorsi o nomi di database: la pagina e' pubblica.
     *
     * La legge il controllo di uptime, che dal 05/11/2026 non sta piu' nel framework ma e' il progetto
     * glisweb-check-24x7 ( https://github.com/istricesrl/glisweb-check-24x7 ): fino ad allora questa pagina serviva
     * anche, col token del cluster, la vista del server agli altri server, che adesso la pubblica il progetto da solo.
     * Quello che un deploy fornisce al controllo e' descritto nel capitolo 125.uptime del manuale sviluppatore.
     *
     * @file
     *
     */

    // inclusione del framework
    if( ! defined( 'INCLUDE_SUBDIR' ) ) {
        require '../../_config.php';
    } else {
        require INCLUDE_SUBDIR . '_config.php';
    }

    // output
    header( 'Content-type: text/plain' );
    header( 'Cache-Control: no-store, no-cache, must-revalidate, max-age=0, s-maxage=0' );
    header( 'Pragma: no-cache' );
    header( 'Expires: 0' );
    header( 'X-Proxy-Cache: BYPASS' );
    header( 'X-GlisWeb-No-Cache: true' );

    // il database conta solo se il deploy ne ha uno
    if( ! empty( $cf['mysql']['profiles'][ $cf['site']['status'] ]['servers'] ) && empty( $cf['mysql']['connection'] ) ) {
        http_response_code( 503 );
        echo 'KO' . PHP_EOL;
    } else {
        echo 'OK' . PHP_EOL;
    }
