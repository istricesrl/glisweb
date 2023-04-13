<?php

    /**
     * API file standard
     *
     *
     *
     * @todo commentare
     *
     * @file
     *
     */

    // inclusione del framework
	require '../_config.php';

    // debug
    // print_r( $_REQUEST );

    // variabile generale per il comportamento
    $authorized = false;

    // determino il mime type
    $finfo = finfo_open( FILEINFO_MIME );
    $mimetype = finfo_file( $finfo, DIR_BASE . $_REQUEST['__download__'] );
    finfo_close( $finfo );

    // verifico se il file è associato a oggetti del database
    $check = mysqlSelectRow(
        $cf['mysql']['connection'],
        'select id from ( select id, path from file union select id, path from immagini ) as var where var.path = ?',
        array( array( 's' => $_REQUEST['__download__']))
    );

    // TODO qui logiche standard di protezione dei file
    if( empty( $check ) ) {
        $authorized = true;
    }

    // logiche custom di protezione dei file
    // TODO includere logiche aggiuntive anche per moduli, sia standard che custom
    // TODO continuare a includere finché ci sono file o finché qualcuno non dice true
    if( file_exists( DIR_BASE . 'src/inc/macro/download.finally.php' ) ) {
        require DIR_BASE . 'src/inc/macro/download.finally.php';
    }

    // restituzione contenuto
    if( $authorized === true ) {

        header( 'content-type: ' . $mimetype );
        echo file_get_contents( DIR_BASE . $_REQUEST['__download__'] );
    
    } else {

	    http_response_code( 403 );
        header( 'content-type: text/plain' );
        echo 'accesso negato per ' . $_REQUEST['__download__'];

    }
