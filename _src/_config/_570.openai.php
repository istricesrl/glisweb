<?php

    /**
     * server e profili openai
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
	$cf['openai']['servers']			= array();

    // profili di funzionamento
	$cf['openai']['profiles'][ DEVELOPEMENT ]		=
	$cf['openai']['profiles'][ TESTING ]		=
	$cf['openai']['profiles'][ PRODUCTION ]	= NULL;

    // configurazione extra
	if( isset( $cx['openai'] ) ) {
	    $cf['openai'] = array_replace_recursive( $cf['openai'], $cx['openai'] );
	}

    // collegamento all'array $ct
	$ct['openai']					= &$cf['openai'];

/*
    // link al profilo corrente
	$cf['openai']['profile']			= &$cf['openai']['profiles'][ $cf['site']['status'] ];

    // link al server corrente
	$cf['openai']['server']			= NULL;
*/
