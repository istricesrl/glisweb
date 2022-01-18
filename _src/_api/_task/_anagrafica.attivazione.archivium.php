<?php

    /**
     *
     *
     *
     *
     * @todo commentare
     *
     * @file
     *
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../_config.php';
	}

    // inizializzo l'array del risultato
	$status = array();

    // log
	logWrite( 'invio anagrafica ad Archivium', 'archivium', LOG_NOTICE );

    // esportazione azienda in Archivium
    if( in_array( 'INVIO_ANAGRAFICA_ARCHIVIUM', array_keys( $_SESSION['account']['privilegi'] ) ) ) {

        // verifica se l'anagrafica è presente
        if( isset( $_REQUEST['id'] ) ) {
            $status = archiviumPostInsertAzienda( $_REQUEST['id'] );
        }

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
