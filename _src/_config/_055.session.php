<?php

    /**
     * file di applicazione della configurazione della sessione PHP
     *
     * In questo file vengono applicate le configurazioni delle sessioni PHP.
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

    // costante per la durata massima della sessione
	if( ! defined( 'SESSION_LIMIT' ) ) {
	    define( 'SESSION_LIMIT'		, 3600 );
	}

    // controllo output
	if( headers_sent( $file, $line ) ) {
	    die( 'output iniziato in ' . $file . ' linea ' . $line );
	}

    // timer
	timerCheck( $cf['speed'], '-> inizio avvio sessione' );

	// policy di sicurezza
	ini_set( 'session.cookie_samesite', 'lax' );
	ini_set( 'session.cookie_httponly', 1 );
	ini_set( 'session.cookie_secure', 1 );

	// avvio della sessione php
	if( session_start() ) {

	    // registro l'id della sessione nell'array $cf
		$_SESSION['id']				= session_id();

		// imposto il tempo se la sessione è appena stata creata
		if( ! isset( $_SESSION['used'] ) ) {
			$_SESSION['used']			= time();
		}

	    // log
		logWrite( 'avviata la sessione ' . session_id(), 'session' );

	} else {

	    // log
		logWrite( 'impossibile avviare la sessione', 'session', LOG_CRIT );

	}

    // timer
	timerCheck( $cf['speed'], '-> fine avvio sessione' );

    // debug
	// $h = fopen( DIRECTORY_BASE . 'var/log/sessions.debug', 'a+' );
	// fwrite( $h, date('Y-m-d H:i:s') . ' ' . session_id() . ' -> current' . PHP_EOL );
	// fclose( $h );

    // connetto i dati della sessione all'array $cf
	$cf['session']				= &$_SESSION;

    // collegamento all'array $ct
	$ct['session']				= &$cf['session'];

    // debug
	// echo 'sessione ' . session_id();
	// print_r( $cf['session'] );
    // echo 'OUTPUT';
