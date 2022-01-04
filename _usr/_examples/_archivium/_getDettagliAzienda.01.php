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
    $r = archiviumGetDettagliAzienda( $_REQUEST['idAzienda'] );

    // output
    $t .= '<pre>' . print_r( $r, true ) . '</pre>';

    // output
    buildHTML( $t );
