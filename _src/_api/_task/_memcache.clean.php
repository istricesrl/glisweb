<?php

    /**
     *
     *
     *
     *
     *
     *
     *
     *
     * TODO documentare
     *
     *
     */

    // NOTA potete chiamare questa API con l'URL /task/memcache.clean

    // TODO bisognerebbe che questo task svuotasse solo la cache del sito corrente

    // inclusione del framework
    if( ! defined( 'CRON_RUNNING' ) ) {
        define( 'MEMCACHE_REFRESH', 1 );
        if( ! defined( 'INCLUDE_SUBDIR' ) ) {
            require '../../_config.php';
        } else {
            require INCLUDE_SUBDIR . '_config.php';
        }
    }

    // inizializzo l'array del risultato
    $status = array();

    // chiave dell'indice
    $key = 'CACHE_INDEX';

    // controllo
    $status['controllo']['chiavi'] = memcacheRead( $cf['memcache']['connection'], memcacheUniqueKey( $key ) );

    // faccio il flush della cache
    $status['esito'] = memcacheFlush( $cf['memcache']['connection'], $cf['sites']['1']['domains'][ SITE_STATUS ] );

    // controllo
    $status['controllo']['residue'] = memcacheRead( $cf['memcache']['connection'], memcacheUniqueKey( $key ) );

    // headers
    header( 'Access-Control-Allow-Origin: *' );

    // output
    if( ! defined( 'CRON_RUNNING' ) ) {
        buildJson( $status );
    }
