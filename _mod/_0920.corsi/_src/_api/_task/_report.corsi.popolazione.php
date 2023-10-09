<?php

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}

    // inizializzo l'array del risultato
	$status = array();

	// ...
	if( isset( $_REQUEST['id'] ) ) {

		// scrivo la riga
		updateReportCorsi( $_REQUEST['id'] );

	} else {

		// TODO trovo un corso da aggiornare
		// $idCorso = ...

		// TODO aggiorno il corso
		// updateReportCorsi( $idCorso );

	}

	// output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
