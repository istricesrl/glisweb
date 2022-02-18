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

    // svuoto la coda
	if( mysqlQuery( $cf['mysql']['connection'], 'DELETE FROM job WHERE timestamp_completamento IS NOT NULL' ) ) {
	    $status['__status__'] = 'OK';
	} else {
	    $status['__status__'] = 'NO';
	}

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
