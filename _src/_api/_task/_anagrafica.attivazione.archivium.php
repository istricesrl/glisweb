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

    // verifica dei privilegi
    checkTaskPrivilege( 'GESTIONE_ACCOUNT' );

    // inizializzo l'array del risultato
	$status = array();

    // log
	logWrite( 'invio anagrafica ad Archivium', 'archivium', LOG_NOTICE );

    // esportazione azienda in Archivium
    if( getPrivilege( 'INVIO_ANAGRAFICA_ARCHIVIUM' ) ) {

        // verifica se l'anagrafica è presente
        if( isset( $_REQUEST['id'] ) ) {
            $status = archiviumPostInsertAzienda( $_REQUEST['id'] );
        }

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
