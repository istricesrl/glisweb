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

    // NOTA scontrino di prova 0,01 € su REP.1

    // test
	try {

	    $connector = new Mike42\Escpos\PrintConnectors\NetworkPrintConnector( '192.168.1.137', 9100 );
#	    $connector = new Mike42\Escpos\PrintConnectors\NetworkPrintConnector( '192.168.1.201', 9100 );

	    $printer = new Mike42\Escpos\Printer( $connector );

	    $printer -> text( '1H1R' );

	    usleep(1000000);

	    $printer -> text( '1T' );

	    $printer -> close();

	} catch( Exception $e ) {

	    logWrite( $e -> getMessage(), 'cassa', LOG_ERR );

	}
