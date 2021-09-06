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
/*	if( ! defined( 'CRON_RUNNING' ) ) {
	    header( 'Access-Control-Allow-Origin: *' );
	    require '../../../../../_src/_config.php';
	}
*/
	header( 'Access-Control-Allow-Origin: *' );

    require '../../../../_src/_config.php';
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

   // print_r($_REQUEST);

    $documento = json_decode($_REQUEST['__data__'], true, 4,JSON_OBJECT_AS_ARRAY);
    // print_r( $documento );

    // array di stato
//	$status = array();

    // connessione
//	$h = escpos_connect( '192.168.1.137' );

    // scrittura di test
	// escpos_write( $h, '1H1R' );
	// escpos_write( $h, '"PROVA"1*1000H2R' );
	// escpos_write( $h, '1*1000H2R' );
	// escpos_write( $h, '1T' );

    $barcode = str_pad( $documento['id'] ,4,"0", STR_PAD_LEFT)."";
 
    // barcode documento
   escpos_write( $h, '"{BDOC.'.$barcode.'"4Z' );

    foreach(  $documento['righe'] as $riga ){

        $write_string = '"'.$riga['articolo'].'"'.str_replace('.00', '', $riga['quantita']).'*'.str_replace('.', '', $riga['importo']).'H'.$riga['id_reparto'].'R'.(  $riga['matricola'] ? '"'.$riga['label_matricola'].'"@' : '').(  $riga['ore'] ? '"+'.$riga['ore'].'h su '.$riga['id_progetto'].'"@' : '');
        escpos_write( $h, $write_string);

    }

    escpos_write( $h, '"   Grazie per il tuo acquisto!"@40F'); 
    escpos_write( $h, '"       Visita il sito"@40F');
    escpos_write( $h, '"   www.pc-stop.eu/recensioni"@40F');
    escpos_write( $h, '"   o inquadra il qrcode per"@40F');
    escpos_write( $h, '"    lasciare una recensione"@40F'); 
    


    if( $documento['id_modalita_pagamento'] == 1 ){
        // pagamento in contanti
        escpos_write( $h, '1T' );
    } else {
        // pagamento elettronico
        escpos_write( $h, '3T' );
    }
    
    escpos_write( $h, '"WWW.PC-STOP.EU/RECENSIONI"6Z' );

  //  escpos_write( $h, '"  "@'); 


    // chiusura
	escpos_disconnect( $h );

    // risposta con errore
	http_response_code( 200 );

    $status['result'] = 'OK';
    $status['msg'] = "stampate correttamente ".sizeof( $documento['righe'] )." righe di scontrino";

    // output
	buildJson( $status );
