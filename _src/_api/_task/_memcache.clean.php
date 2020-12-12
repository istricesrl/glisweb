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
     * @todo commentare
     *
     * @file
     *
     */

    // NOTA potete chiamare questa API con l'URL /task/memcache.clean

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    define( 'MEMCACHE_REFRESH', 1 );
	    require '../../_config.php';
	}

    // inizializzo l'array del risultato
	$status = array();

    // faccio il flush della cache
	$status['esito'] = memcacheFlush( $cf['memcache']['connection'] );

    // headers
	header( 'Access-Control-Allow-Origin: *' );

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
