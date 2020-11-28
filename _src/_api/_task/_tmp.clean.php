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

	    $cf['lvls']['skip'] = array(
		'300', '310', '320', '330', '345',
		'400', '420',
		'950', '980'
	    );

	    require '../../_config.php';

	}

    // inizializzo l'array del risultato
	$status = array();

    // faccio il flush della cache
	$status['esito'] = recursiveDelete( DIR_TMP );

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
