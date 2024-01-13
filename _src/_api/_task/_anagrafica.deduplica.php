<?php

    /**
     *
     *
     *
     *
     * @todo documentare
     * @todo spiegare bene la logica con cui vengono uniti i dati, quali prevalgono, eccetera
     * @todo fornire queste informazioni anche nell'interfaccia grafica quando l'utente deve cliccare
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
