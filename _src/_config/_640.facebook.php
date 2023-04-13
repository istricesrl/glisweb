<?php

    /**
     * server e profili facebook
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

    // profili di funzionamento
	$cf['facebook']['profiles'][ DEVELOPEMENT ]		=
	$cf['facebook']['profiles'][ TESTING ]		=
	$cf['facebook']['profiles'][ PRODUCTION ]	= NULL;

    // configurazione extra
	if( isset( $cx['facebook'] ) ) {
	    $cf['facebook'] = array_replace_recursive( $cf['facebook'], $cx['facebook'] );
	}

    // configurazione extra per sito
	if( isset( $cf['site']['facebook'] ) ) {
	    $cf['facebook'] = array_replace_recursive( $cf['facebook'], $cf['site']['facebook'] );
	}

    // collegamento all'array $ct
	$ct['facebook']					= &$cf['facebook'];
