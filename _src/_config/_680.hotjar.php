<?php

    /**
     * profili Hotjar
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
	$cf['hotjar']['profiles'][ DEVELOPEMENT ]		=
	$cf['hotjar']['profiles'][ TESTING ]		=
	$cf['hotjar']['profiles'][ PRODUCTION ]	= NULL;

    // configurazione extra
	if( isset( $cx['hotjar'] ) ) {
	    $cf['hotjar'] = array_replace_recursive( $cf['hotjar'], $cx['hotjar'] );
	}

    // configurazione extra per sito
	if( isset( $cf['site']['hotjar'] ) ) {
	    $cf['hotjar'] = array_replace_recursive( $cf['hotjar'], $cf['site']['hotjar'] );
	}

    // collegamento all'array $ct
	$ct['hotjar']					= &$cf['hotjar'];

