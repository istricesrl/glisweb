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

    // configurazione extra
	if( isset( $cx['sms'] ) ) {
	    $cf['sms'] = array_replace_recursive( $cf['sms'], $cx['sms'] );
	}
