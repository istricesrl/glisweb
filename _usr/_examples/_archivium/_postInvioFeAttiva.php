<?php

    /**
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // inclusione del framework
	require '../../../_src/_config.php';

    // testo della pagina
    $t = null;

    // prelevo l'XML
    $x = restCall(
        $cf['site']['url'] . 'print/0400.documenti/fattura.xml',
        METHOD_GET,
        array( '__documento__' => $_REQUEST['idFattura'], 'f' => 1 ),
        NULL,
        MIME_APPLICATION_JSON
    );

    // chiamo la funzione archiviumPostInsertAzienda()
    if( ! empty( $x['file'] ) ) {
        $s = archiviumPostInvioFeAttiva( $_REQUEST['idAzienda'], $_REQUEST['idFattura'], $x['file'] );
    } else {
        $t .= '<p>XML fattura vuoto</p>';        
    }

    // output
    $t .= '<pre>' . var_dump( $s ) . '</pre>';
    $t .= '<pre>' . htmlentities( readFromFile( $x['file'], FILE_READ_AS_STRING ) ) . '</pre>';

    // output
    buildHTML( $t );
