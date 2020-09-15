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

    // elimino i log
	if( isset( $_REQUEST['hard'] ) ) {
	    recursiveDelete( DIR_VAR_LOG, false );
	} else {
	    $logs = glob( DIR_VAR_LOG . '*.log' );
	    foreach( $logs as $log ) {
		deleteFile( $log );
	    }
	}

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}

?>
