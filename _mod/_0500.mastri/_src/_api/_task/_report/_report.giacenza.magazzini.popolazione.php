<?php

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../../_src/_config.php';
	}

    // inizializzo l'array del risultato
	$status = array();

	// ...
	if( ! isset( $_REQUEST['idArticolo'] ) && ! isset( $_REQUEST['matricola'] ) ) {

		// TODO trovo una riga da aggiornare

		// TODO aggiorno la riga

    } elseif( isset( $_REQUEST['idMastro'] ) && isset( $_REQUEST['idArticolo'] ) && isset( $_REQUEST['matricola'] ) ) {

		// scrivo la riga
		updateReportGiacenzaMagazzini( $_REQUEST['idMastro'], $_REQUEST['idArticolo'], $_REQUEST['matricola'] );

    } elseif( isset( $_REQUEST['idMastro'] ) && isset( $_REQUEST['matricola'] ) ) {

        // TODO ricavo l'articolo dalla matricola

        // TODO scrivo la riga

    } elseif( isset( $_REQUEST['idMastro'] ) && isset( $_REQUEST['idArticolo'] ) ) {

        // scrivo la riga
		updateReportGiacenzaMagazzini( $_REQUEST['idMastro'], $_REQUEST['idArticolo'] );

    }

    // debug
    // print_r( $_REQUEST );

	// output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
