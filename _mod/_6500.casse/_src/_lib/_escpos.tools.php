<?php

    function escpos_connect( $a, $p = 9100 ) {

	logWrite( 'connessione a ' . $a . ':' . $p, 'escpos' );
/*
	try {

	    $c = new Mike42\Escpos\PrintConnectors\NetworkPrintConnector( $a, $p );

	    $h = new Mike42\Escpos\Printer( $c );

	    $h->initialize();

	    return $h;

	} catch( Exception $e ) {

	    logWrite( $e -> getMessage(), 'escpos', LOG_ERR );

	}
*/
	$socket = socket_create(AF_INET, SOCK_STREAM, SOL_TCP);
	socket_connect( $socket, $a, $p );

	return $socket;

    }

    function escpos_write( $h, $t ) {

	appendToFile( date( 'Y-m-d H:i:s' ) . ' ' . $t . PHP_EOL, FILE_ESCPOS_TRANSCRIPT );

#	$h->text( $t );
	socket_write( $h, $t );

	sleep( 1 );

    }

    function escpos_disconnect( $h ) {

	socket_close( $h );
#	$h->close();

    }

    function escpos_setDate( $h, $d = NULL ) {

	escpos_write( $h, '"' . ( ( $d !== NULL ) ? $d : date( 'dmyHi' ) ) . '"D' );

    }
