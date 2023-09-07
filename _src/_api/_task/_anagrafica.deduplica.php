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

    // ...
    if( isset( $_REQUEST['src'] ) ) {

        // ...
        if( isset( $_REQUEST['dst'] ) ) {

            // ...
            $status = unisciAnagrafiche(
                $_REQUEST['src'],
                $_REQUEST['dst']
            );

        }

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
