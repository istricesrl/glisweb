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
	$cf['registrazione']['profili']['default'] = array(
        'nome' => 'utente di default',
	    'gruppi' => array( 'users' ),
	    'categorie' => array( 'lead' ),
        'sms' => false,
	    'attivo' => true
	);

    // configurazione extra
	if( isset( $cx['registrazione'] ) ) {
	    $cf['registrazione'] = array_replace_recursive( $cf['registrazione'], $cx['registrazione'] );
	}

    // configurazione extra per sito
	if( isset( $cf['site']['registrazione'] ) ) {
	    $cf['registrazione'] = array_replace_recursive( $cf['registrazione'], $cf['site']['registrazione'] );
	}
