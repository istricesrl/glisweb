<?php

    /**
     *
     *
     *
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // debug
	// print_r( $_REQUEST );
	// print_r( $_GET );
	// die();

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    header( 'Access-Control-Allow-Origin: *' );
	    require '../../../../../_src/_config.php';
	}

    // inizializzo l'array del risultato
	$status = array();

    // connessione
	$h = escpos_connect(
	    $cf['casse']['printer']['address'],
	    $cf['casse']['printer']['port']
	);

    // informazioni
	$status['info'] = array(
	    $cf['casse']['printer']['address'],
	    $cf['casse']['printer']['port']
	);

    // NOTA rendiconto fiscale
    // 1f -> rendiconto

    // scrittura di test
	escpos_write( $h, '1f' );

    // chiusura
	escpos_disconnect( $h );

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
