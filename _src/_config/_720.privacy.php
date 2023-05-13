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
	// print_r( $cf['privacy'] );

    // recupero i consensi dai cookie
	if( isset( $_COOKIE['privacy'] ) ) {
	    $cf['privacy']['cookie'] = array_replace_recursive( $cf['privacy']['cookie'], unserialize( $_COOKIE['privacy'] ) );
	}

	// se è stato inviato un modulo di consenso
	if( isset( $_REQUEST['__cookie__'] ) ) {
/*
	    // registro il consenso nel cookie dei consensi
		$cf['privacy']['cookie'][ $_REQUEST['__cookie__']['owner'] ][ $_REQUEST['__cookie__']['type'] ][ $_REQUEST['__cookie__']['name'] ]['consenso'] = $_REQUEST['__cookie__']['value'];

	    // TODO log del consenso
		// @todo implementare il log dei consensi
*/
		foreach( $_REQUEST['__cookie__'] as $cookie => $val ) {
			$cf['privacy']['cookie'][ $val['owner'] ][ $val['type'] ][ $cookie ]['consenso'] = $_REQUEST['__cookie__'][ $cookie ]['value'];
		}

	    // setto il cookie
		setcookie( 'privacy', serialize( $cf['privacy']['cookie'] ), time()+60*60*24*30, '/; SameSite=strict' );

	}

	/*
    // aggiustamenti automatici ai cookie per Google Tag Manager
	if( isset( $cf['google']['gtm']['profile'] ) ) {
	    $k = ( ( $cf['google']['gtm']['profile']['anonymous'] == true ) ? 'anonimi' : 'identificativi' );
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
	if( isset( $cf['google']['analytics']['profile'] ) ) {
	    $k = ( ( $cf['google']['analytics']['profile']['anonymous'] == true ) ? 'anonimi' : 'identificativi' );
	    $cf['privacy']['cookie']['terzi']['analitici'][ $k ] = array(
		'GoogleAnalytics' => array(
		    'nome' => 'Google Analytics',
		    'policy' => 'http://www.google.it/intl/it/policies/privacy/',
		    'motivazione' => array( 'it-IT' => 'analisi statistica di utilizzo del sito da parte dei visitatori e monitoraggio del funzionamento del sito' ),
		    'conservazione' => array( 'it-IT' => 'due anni' )
		)
	    );
	}
	*/

	// debug
	// print_r( $cf['privacy']['cookie'] );
	// print_r( $_REQUEST['__cookie__'] );
	// print_r( $cf['contents']['pages']['licenza']['content'] );
