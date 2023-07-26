<?php

    /**
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     * @file
     *
     */

    // debug
	// print_r( $cf['google'] );

	// debug
	// print_r( $cf['privacy']['cookie'] );

	/*
    // aggiustamenti automatici ai cookie per Google Tag Manager
	if( isset( $cf['google']['profile']['gtm'] ) ) {
	    $k = ( ( $cf['google']['profile']['gtm']['anonymous'] == true ) ? 'anonimi' : 'identificativi' );
	    $cf['privacy']['cookie']['terzi']['analitici'][ $k ] = array(
		'GoogleTagManager' => array(
		    'nome' => 'Google Tag Manager',
		    'policy' => 'https://policies.google.com/privacy',
		    'motivazione' => array( 'it-IT' => 'analisi statistica di utilizzo del sito da parte dei visitatori e monitoraggio del funzionamento del sito' ),
		    'conservazione' => array( 'it-IT' => 'due anni' )
		)
	    );
	}

    // aggiustamenti automatici ai cookie per Google Analytics
	if( isset( $cf['google']['profile']['analytics'] ) ) {
	    $k = ( ( $cf['google']['profile']['analytics']['anonymous'] == true ) ? 'anonimi' : 'identificativi' );
	    $cf['privacy']['cookie']['terzi']['analitici'][ $k ] = array(
		'GoogleAnalytics' => array(
		    'nome' => 'Google Analytics',
		    'policy' => 'http://www.google.it/intl/it/policies/privacy/',
		    'motivazione' => array( 'it-IT' => 'analisi statistica di utilizzo del sito da parte dei visitatori e monitoraggio del funzionamento del sito' ),
		    'conservazione' => array( 'it-IT' => 'due anni' )
		)
	    );
	}

    // se è stato inviato un modulo di consenso
	if( isset( $_REQUEST['__cookie__'] ) ) {

	    // registro il consenso nel cookie dei consensi
		$cf['privacy']['cookie'][ $_REQUEST['__cookie__']['owner'] ][ $_REQUEST['__cookie__']['type'] ]['identificativi'][ $_REQUEST['__cookie__']['name'] ]['consenso'] = $_REQUEST['__cookie__']['value'];

	    // setto il cookie
		setcookie( 'privacy', serialize( $cf['privacy']['cookie'] ), time()+60*60*24*30 );

	    // TODO log del consenso
		// @todo implementare il log dei consensi

	}
*/
    // debug
	// print_r( $cf['privacy']['cookie'] );
	// print_r( $_REQUEST['__cookie__'] );
	// print_r( $cf['contents']['pages']['licenza']['content'] );
