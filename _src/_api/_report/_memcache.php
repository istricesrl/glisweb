<?php

    /**
     * report sulla gestione della cache Memcache
     * 
     * Questo report visualizza tutte le chiavi presenti nella cache Memcache e verifica se sono gestite dal framework.
     * 
     * 
     * TODO documentare
     * 
     */

    // inclusione del framework
    require '../../_config.php';

    // header
    header( 'Content-type: text/plain' );

    // chiave per la lettura dell'indice
    $key = 'CACHE_INDEX';

    // lettura dell'indice di memcache
    $m = memcacheRead( $cf['memcache']['connection'], memcacheUniqueKey( $key ) ) ?? [];

    // visualizzazione delle chiavi memcache
    if ( !empty( $m ) ) {
        print_r( $m );
    }
