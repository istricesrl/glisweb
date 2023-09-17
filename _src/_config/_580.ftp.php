<?php

    /**
     * server e profili FTP
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
	$cf['ftp']['servers']				= array();

    // profili di funzionamento
	$cf['ftp']['profiles'][ DEVELOPEMENT ]		=
	$cf['ftp']['profiles'][ TESTING ]		=
	$cf['ftp']['profiles'][ PRODUCTION ]		= array();

    // link al server corrente
	$cf['ftp']['server']				= NULL;

    // configurazione extra
	if( isset( $cx['ftp'] ) ) {
	    $cf['ftp'] = array_replace_recursive( $cf['ftp'], $cx['ftp'] );
	}

    // configurazione extra per sito
	if( isset( $cf['site']['ftp'] ) ) {
	    $cf['ftp'] = array_replace_recursive( $cf['ftp'], $cf['site']['ftp'] );
	}

    // debug
	// print_r( $cf['contents']['pages']['licenza']['content'] );
	// print_r( $cf['contents']['page'] );
	// print_r( $ct['page'] );
