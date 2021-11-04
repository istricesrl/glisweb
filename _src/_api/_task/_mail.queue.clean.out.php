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
	logWrite( 'richiesta di pulizia della coda delle mail in uscita', 'mail', LOG_DEBUG );

    // svuoto la coda
	if( mysqlQuery( $cf['mysql']['connection'], 'DELETE FROM mail_out' ) ) {
	    mysqlQuery( $cf['mysql']['connection'], 'OPTIMIZE TABLE mail_out' );
	    $status['__status__'] = 'OK';
	} else {
	    $status['__status__'] = 'NO';
	}

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
