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
        'username' => true,
        'sms' => false,
        'mail' => 'DEFAULT_NUOVO_ACCOUNT',
        'landing' => 'registrazione',
	    'attivo' => true
	);

    // registrazione breve per il sito
	$cf['registrazione']['profili']['sito'] = array(
        'nome' => 'utente di default',
	    'gruppi' => array( 'users' ),
	    'categorie' => array( 'lead' ),
        'sms' => false,
        'mail' => 'STANDARD_NUOVO_ACCOUNT',
        'landing' => 'profilo',
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
