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

    // se ho i dati
    if( isset( $_REQUEST['idAzienda'] ) && isset( $_REQUEST['idFattura'] ) ) {

        // chiamo la funzione archiviumGetListaAziende()
        $l = archiviumGetDownloadFePassiva( $_REQUEST['idAzienda'],  $_REQUEST['idFattura'] );

        // header
        header( 'content-type: text/plain');

        // output
        print_r( $l );

    }
