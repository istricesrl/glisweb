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

    // chiamo la funzione archiviumGetListaAziende()
    $l = archiviumGetDownloadFePassiva( $_REQUEST['idAzienda'],  $_REQUEST['idFattura'] );

    // output
    $t .= '<pre>' . print_r( $l, true ) . '</pre>';

    // output
    buildHTML( $t );
