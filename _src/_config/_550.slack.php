<?php

    /**
     * server e profili Slack
     *
     *
     *
     *
     *
     * https://api.slack.com/apps/
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // server disponibili
	$cf['slack']['servers']			= array();

    // profili di funzionamento
	$cf['slack']['profiles'][ DEVELOPEMENT ]		=
	$cf['slack']['profiles'][ TESTING ]		=
	$cf['slack']['profiles'][ PRODUCTION ]	= NULL;

    // configurazione extra
	if( isset( $cx['slack'] ) ) {
	    $cf['slack'] = array_replace_recursive( $cf['slack'], $cx['slack'] );
	}

    // configurazione extra per sito
	if( isset( $cf['site']['slack'] ) ) {
	    $cf['slack'] = array_replace_recursive( $cf['slack'], $cf['site']['slack'] );
	}

    // collegamento all'array $ct
	$ct['slack']					= &$cf['slack'];
