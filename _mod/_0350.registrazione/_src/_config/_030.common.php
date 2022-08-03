<?php

    /**
     *
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // comportamento di default
	$cf['registrazione']['default'] = array(
	    'gruppi' => array( 'users' ),
	    'categorie' => array( 'lead' ),
        'sms' => false,
	    'attivo' => true
	);

    // configurazione extra
	if( isset( $cx['registrazione']['default'] ) ) {
	    $cf['registrazione']['default'] = array_replace_recursive( $cf['registrazione']['default'], $cx['registrazione']['default'] );
	}

    // configurazione extra per sito
	if( isset( $cf['site']['registrazione']['default'] ) ) {
	    $cf['registrazione']['default'] = array_replace_recursive( $cf['registrazione']['default'], $cf['site']['registrazione']['default'] );
	}
