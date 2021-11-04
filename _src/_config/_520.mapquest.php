<?php

    /**
     * server e profili Mapquest
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
	$cf['mapquest']['servers']			= array();

    // profili di funzionamento
	$cf['mapquest']['profiles'][ DEVELOPEMENT ]		=
	$cf['mapquest']['profiles'][ TESTING ]		=
	$cf['mapquest']['profiles'][ PRODUCTION ]	= NULL;

    // configurazione extra
	if( isset( $cx['mapquest'] ) ) {
	    $cf['mapquest'] = array_replace_recursive( $cf['mapquest'], $cx['mapquest'] );
	}

    // collegamento all'array $ct
	$ct['mapquest']					= &$cf['mapquest'];

/*
    // link al profilo corrente
	$cf['mapquest']['profile']			= &$cf['mapquest']['profiles'][ $cf['site']['status'] ];

    // link al server corrente
	$cf['mapquest']['server']			= NULL;
*/
