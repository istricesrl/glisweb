<?php

    function escpos_connect( $a, $p = 9100 ) {

	logWrite( 'connessione a ' . $a . ':' . $p, 'escpos' );

	try {

	    $c = new Mike42\Escpos\PrintConnectors\NetworkPrintConnector( $a, $p );

	    $h = new Mike42\Escpos\Printer( $c );

	    return $h;

	} catch( Exception $e ) {

	    logWrite( $e -> getMessage(), 'escpos', LOG_ERR );

	}

	return false;

    }

    function escpos_write( $h, $t ) {

	$h->text( $t );
	sleep( 1 );

    }

    function escpos_disconnect( $h ) {

	$h->close();

    }

?>
