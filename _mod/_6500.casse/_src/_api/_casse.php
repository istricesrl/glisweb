<?php

    /**
     * gestione delle chiamate alle API per la cassa
     *
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
	require '../../../../_src/_config.php';

    // array di stato
	$status = array();

    // connessione
	$h = escpos_connect( '192.168.1.137' );

    // scrittura di test
	escpos_write( $h, '1H1R' );
	escpos_write( $h, '1T' );

    // chiusura
	escpos_disconnect( $h );

    // risposta con errore
	http_response_code( 200 );

    // output
	buildJson( $status );

?>
