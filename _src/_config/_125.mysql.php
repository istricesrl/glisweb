<?php

    /**
     * connessioni MySQL
     *
     * In questo file vengono effettuate le connessioni ai server MySQL configurati.
     *
     *
     *
     *
     * @file
     *
     */

    // debug
	// die( $cf['site']['status'] );
	// die( print_r( $cf['mysql'], true ) );

    // link alla connessione corrente
	$cf['mysql']['connection']			= NULL;

    // link al profilo corrente
	$cf['mysql']['profile']				= &$cf['mysql']['profiles'][ $cf['site']['status'] ];

    // verifico che sia presente alemno un server
	if( isset( $cf['mysql']['profile']['servers'] ) && is_array( $cf['mysql']['profile']['servers'] ) ) {

	    // verifico che sia presente almeno un server
		if( count( $cf['mysql']['profile']['servers'] ) > 0 ) {

		    // ciclo sui server attivi per lo stato corrente
			foreach( $cf['mysql']['profile']['servers'] as $server ) {

			    // log
				logWrite( 'tento la connessione a: ' . $server, 'mysql' );

			    // inizializzo la connessione
				$cn = mysqli_init();

			    // riduco il tempo massimo di connessione per evitare rallentamenti
				mysqli_options( $cn, MYSQLI_OPT_CONNECT_TIMEOUT, 3 );

			    // connessione
				mysqli_real_connect(
				    $cn,
				    $cf['mysql']['servers'][ $server ]['address'],
				    $cf['mysql']['servers'][ $server ]['username'],
				    $cf['mysql']['servers'][ $server ]['password']
				);

			    // controllo errori
				if( mysqli_connect_errno() ) {

				    // log
					logWrite( 'errore di connessione a ' . $server . ': ' . mysqli_connect_errno() . ' ' . mysqli_connect_error(), 'mysql', LOG_ERR );

				} else {

				    // versione del server
					$cf['mysql']['servers'][ $server ]['version'] = mysqli_get_server_info( $cn );

				    // selezione database
					if( mysqli_select_db( $cn, $cf['mysql']['servers'][ $server ]['db'] ) ) {
					    logWrite( 'database selezionato: ' . $cf['mysql']['servers'][ $server ]['db'], 'mysql' );
					} else {
					    logWrite( 'impossibile selezionare il database: ' . $cf['mysql']['servers'][ $server ]['db'], 'mysql', LOG_ERR );
					}

				    // character set
#					mysqli_set_charset( $cn, 'utf8' );

				    // collation
					mysqlQuery( $cn, 'SET character_set_connection = utf8' );
					mysqlQuery( $cn, 'SET collation_connection = utf8_general_ci' );

				    // timezone
					mysqlQuery( $cn, 'SET time_zone = ?', array( array( 's' => $cf['localization']['timezone']['name'] ) ) );

				    // localizzazione
					mysqlQuery( $cn, 'SET lc_time_names = ?', array( array( 's' => str_replace( '-', '_', $cf['localization']['language']['ietf'] ) ) ) );

				    // log
					logWrite( 'connessione stabilita: ' . $server, 'mysql' );
					logWrite( 'dettagli: ' . mysqli_get_host_info( $cn ), 'mysql' );

				    // aggiungo la connessione all'array
					$cf['mysql']['connections'][ $server ] = $cn;

				}

			}

		    // connessione di default
			if( count( $cf['mysql']['connections'] ) ) {
			    $keys = array_keys( $cf['mysql']['connections'] );
			    $key = array_shift( $keys );
			    $cf['mysql']['connection'] = &$cf['mysql']['connections'][ $key ];
			    $cf['mysql']['server'] = &$cf['mysql']['servers'][ $key ];
			}

		} else {

		    // log
			logWrite( 'nessun server MySQL impostato per il livello di funzionamento corrente', 'mysql' );

		}

	} else {

	    // log
		logWrite( 'backend MySQL non configurato', 'mysql' );

	}

    // debug
	// print_r( $cf['mysql']['profile'] );
	// print_r( $cf['mysql']['connections'] );
	// print_r( $cf['mysql'] );
