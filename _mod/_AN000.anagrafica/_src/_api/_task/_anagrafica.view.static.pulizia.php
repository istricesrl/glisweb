<?php

	/**
	 * 
	 * 
	 * 
	 * 
	 * 
	 * 
	 * TODO documentare
	 * 
	 * 
	 */

	// inclusione del framework
    if( ! defined( 'CRON_RUNNING' ) ) {
        if( ! defined( 'INCLUDE_SUBDIR' ) ) {
            require '../../../../../_src/_config.php';
        } else {
            require INCLUDE_SUBDIR . '_config.php';
        }
    }

    // inizializzo l'array del risultato
	$status = array();

	// ...
	$status['esito'] = cleanAnagraficaViewStatic();

    // debug
    // print_r( $_REQUEST );

	// output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
