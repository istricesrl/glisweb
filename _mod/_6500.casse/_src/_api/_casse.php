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
    
	// print_r( $_GET );
	// die();

    // inclusione del framework
	require '../../../../_src/_config.php';


    // print_r($_REQUEST['__data__']); 
    //  echo("<br>");
    $documento = json_decode($_REQUEST['__data__'], true, 4,JSON_OBJECT_AS_ARRAY);
    // print_r( $documento );

    // array di stato
	$status = array();

    // connessione
	$h = escpos_connect( '192.168.1.137' );

    // scrittura di test
	// escpos_write( $h, '1H1R' );
	// escpos_write( $h, '"PROVA"1*1000H2R' );
	// escpos_write( $h, '1*1000H2R' );
	// escpos_write( $h, '1T' );

    foreach(  $documento['righe'] as $riga ){

        $write_string = '"'.$riga['articolo'].'"'.str_replace('.00', '', $riga['quantita']).'*'.str_replace('.', '', $riga['importo_netto_totale']).'H'.$riga['id_reparto'].'R';
        escpos_write( $h, $write_string);

    }

    if( $documento['id_modalita_pagamento'] == 1 ){
        // pagamento in contanti
        escpos_write( $h, '1T' );
    } else {
        // pagamento elettronico
        escpos_write( $h, '3T' );
    }
    

    // chiusura
	escpos_disconnect( $h );

    // risposta con errore
	http_response_code( 200 );

    $status[] = 'OK';
    $status[] = "stampate correttamente ".sizeof( $documento['righe'] )." righe di scontrino";

    // output
	buildJson( $status );
