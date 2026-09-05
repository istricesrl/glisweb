<?php

    // inclusione del framework
	require '../../../../../_src/_config.php';

    // verifica dei privilegi
    checkTaskPrivilege( 'GESTIONE_ECOMMERCE' );

    // debug
    buildJson( ( isset( $_SESSION['carrello'] ) ? $_SESSION['carrello'] : array( 'status' => 'nessun carrello trovato' ) ) );
