<?php

    /**
     *
     *
     *
     *
     * @todo commentare
     *
     * @file
     *
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../_config.php';
	}

    // inizializzo l'array del risultato
	$status = array();

    // faccio il flush della cache
	$status['esito'] = recursiveDelete( DIR_VAR_CACHE_TWIG );

    // headers
	header( 'Access-Control-Allow-Origin: *' );

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
