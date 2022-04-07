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
    $r = archiviumGetInfoNotaAttiva( $_REQUEST['idAzienda'], $_REQUEST['idNota'] );

    // output
    $t .= '<pre>' . print_r( $r, true ) . '</pre>';

    // output
    buildHTML( $t );
