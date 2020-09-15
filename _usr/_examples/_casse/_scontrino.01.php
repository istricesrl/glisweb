<?php

    /**
     * gestione delle chiamate alle API REST
     *
     * l'infrastruttura di API REST del framework
     * ==========================================
     *
     *
     *
     *
     * ottenere una collezione di dati
     * -------------------------------
     * GET /api/<entità>
     *
     *
     *
     * creare un nuovo oggetto
     * -----------------------
     * POST /api/<entità>
     *
     *
     *
     * ottenere uno specifico oggetto
     * ------------------------------
     * GET /api/<entità>/<id>
     *
     *
     *
     * ottenere uno specifico oggetto in view mode
     * -------------------------------------------
     * GET /api/<entità>/<id>?<entità>[__view_mode__]=1
     *
     *
     *
     * aggiornare uno specifico oggetto
     * --------------------------------
     * PUT /api/<entità>/<id>
     *
     *
     *
     * eliminare uno specifico oggetto
     * -------------------------------
     * DELETE /api/<entità>/<id>
     *
     *
     *
     *
     * filtrare la collezione
     * ----------------------
     * GET /api/<entità>?<entità>[<campo>]=<valore>
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
/*
    // creo il socket per la comunicazione con la stampante fiscale
	$socket = XonXoff_creaSocket( '192.168.1.137', '9100' );

    // test
	$command = date( 'dmyHi' ) . 'D';
	$command = '1706150130D';
	socket_write( $socket, $command, strlen( $command ) );
	$status[] = socket_strerror( socket_last_error( $socket ) );

    // chiudo il socket
	XonXoff_chiudiSocket( $socket );
*/

    // creo il socket
#	$socket = fsockopen( '192.168.1.137', '9100', $errno, $errtx );
#	$socket = XonXoff_creaSocket( '192.168.1.137', '9100' );

    // debug
	// var_dump( $socket );
#	 var_dump( $errno );
#	 var_dump( $errtx );

    // test
#	fwrite( $socket, '1H1R1T' );
#	$command = "1H1R1T\n";
#	socket_write( $socket, $command, strlen( $command ) );

    // ritorno
#	while( !feof( $socket ) ) {
#	    echo fgets( $socket, 128 );
#	}

    // chiudo il socket
#	fclose( $socket );
#	XonXoff_chiudiSocket( $socket );

    // test
	use Mike42\Escpos\Printer;
	use Mike42\Escpos\PrintConnectors\NetworkPrintConnector;

	try {

	    $connector = new NetworkPrintConnector( '192.168.1.137', 9100 );
#	    $connector = new NetworkPrintConnector( '192.168.1.201', 9100 );

	    $printer = new Printer( $connector );
	    $printer -> text( '1H1R' );

	    usleep(1000000);

	    $printer -> text( '1T' );
#	    $printer -> cut();

	    $printer -> close();

	} catch( Exception $e ) {

	    logWrite( $e -> getMessage(), 'cassa', LOG_ERR );

	}

    // risposta con errore
	http_response_code( 200 );

    // output
	buildJson( $status );

?>
