<?php

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}

    // inizializzo l'array del risultato
	$status = array();

            // scrivo la riga
            updateReportCorsi( $_REQUEST['id'] );


    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
