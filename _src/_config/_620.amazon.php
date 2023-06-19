<?php

    /**
     * server e profili amazon
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
	$cf['amazon']['profiles'][ DEVELOPEMENT ]		=
	$cf['amazon']['profiles'][ TESTING ]		=
	$cf['amazon']['profiles'][ PRODUCTION ]	= NULL;

    // configurazione extra
	if( isset( $cx['amazon'] ) ) {
	    $cf['amazon'] = array_replace_recursive( $cf['amazon'], $cx['amazon'] );
	}

    // configurazione extra per sito
	if( isset( $cf['site']['amazon'] ) ) {
	    $cf['amazon'] = array_replace_recursive( $cf['amazon'], $cf['site']['amazon'] );
	}

    // collegamento all'array $ct
	$ct['amazon']					= &$cf['amazon'];
