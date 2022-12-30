<?php

    /**
     * server e profili google
     *
     *
     *
     *
     *
     * - https://developers.google.com/analytics/help
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // profili di funzionamento
	$cf['google']['profiles'][ DEVELOPEMENT ]		=
	$cf['google']['profiles'][ TESTING ]		=
	$cf['google']['profiles'][ PRODUCTION ]	= NULL;

    // configurazione extra
	if( isset( $cx['google'] ) ) {
	    $cf['google'] = array_replace_recursive( $cf['google'], $cx['google'] );
	}

    // configurazione extra per sito
	if( isset( $cf['site']['google'] ) ) {
	    $cf['google'] = array_replace_recursive( $cf['google'], $cf['site']['google'] );
	}

    // collegamento all'array $ct
	$ct['google']					= &$cf['google'];

    // debug
    // print_r( $cx['google'] );
