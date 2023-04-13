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

    // NOTA rendiconto fiscale
    // 1f -> rendiconto

    // scrittura di test
	escpos_write( $h, '1f' );

    // chiusura
	escpos_disconnect( $h );
