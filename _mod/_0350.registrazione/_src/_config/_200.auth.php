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
	$cf['auth']['profili']['default'] = array(
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
	$cf['auth']['profili']['sito'] = array(
        'nome' => 'utente del sito',
	    'gruppi' => array( 'users' ),
	    'categorie' => array( 'lead' ),
        'sms' => false,
        'mail' => 'STANDARD_NUOVO_ACCOUNT',
        'landing' => 'profilo',
	    'attivo' => true
	);
