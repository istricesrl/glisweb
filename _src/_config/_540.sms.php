<?php

    /**
     * server e profili SMS
     *
     *
     *
     *
     *
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // server disponibili
	$cf['sms']['servers']			= array();

    // profili di funzionamento
	$cf['sms']['profiles'][ TESTING ]	=
	$cf['sms']['profiles'][ PRODUCTION ]	= NULL;

    // array dei template SMS di test
	$cf['sms']['tpl']['SMS_TEST_TEMPLATE'] = array(
		'type' => 'twig',
        'it-IT' => array(
            'from' => array( 'GLISWEB' => '+39 329 00 00 000' ),
            'testo' => 'SMS di test'
        )
	);

    // configurazione extra
	if( isset( $cx['sms'] ) ) {
	    $cf['sms'] = array_replace_recursive( $cf['sms'], $cx['sms'] );
	}
