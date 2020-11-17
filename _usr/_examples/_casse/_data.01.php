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
	require '../../../_src/_config.php';

    // connessione
	$h = escpos_connect( '192.168.1.137' );
#	$h = escpos_connect( '192.168.1.201' );

    // scrittura di test
	escpos_setDate( $h, '0101181200' );
	escpos_setDate( $h );

    // chiusura
	escpos_disconnect( $h );
