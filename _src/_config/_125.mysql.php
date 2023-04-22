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
    			appendToFile( 'connessione database -> ' . $server . PHP_EOL, FILE_LATEST_RUN );

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

				// character set
				mysqli_set_charset( $cn, 'utf8' );

			    // controllo errori
				if( mysqli_connect_errno() ) {

				    // log
					logWrite( 'errore di connessione a ' . $server . ': ' . mysqli_connect_errno() . ' ' . mysqli_connect_error(), 'mysql', LOG_ERR );
					appendToFile( 'errore connessione database -> ' . $server . PHP_EOL, FILE_LATEST_RUN );

				} else {

				    // versione del server
					$cf['mysql']['servers'][ $server ]['version'] = mysqli_get_server_info( $cn );

					// selezione database
					try{
						mysqli_select_db( $cn, $cf['mysql']['servers'][ $server ]['db'] );
						logWrite( 'database selezionato: ' . $cf['mysql']['servers'][ $server ]['db'], 'mysql' );
						appendToFile( 'connesso database -> ' . $server . PHP_EOL, FILE_LATEST_RUN );
					}
					catch(\Exception $e){
						logWrite( 'impossibile selezionare il database: ' . $cf['mysql']['servers'][ $server ]['db'], 'mysql', LOG_ERR );
						appendToFile( 'fallita selezione database -> ' . $server . PHP_EOL, FILE_LATEST_RUN );
						die('Impossibile selezionare il database '. $e->getMessage());
					}
					
				    
					/*	if( mysqli_select_db( $cn, $cf['mysql']['servers'][ $server ]['db'] ) == NULL ) {
					    logWrite( 'database selezionato: ' . $cf['mysql']['servers'][ $server ]['db'], 'mysql' );
						appendToFile( 'connesso database -> ' . $server . PHP_EOL, FILE_LATEST_RUN );
					} else {
					    logWrite( 'impossibile selezionare il database: ' . $cf['mysql']['servers'][ $server ]['db'], 'mysql', LOG_ERR );
						appendToFile( 'fallita selezione database -> ' . $server . PHP_EOL, FILE_LATEST_RUN );
						die('impossibile selezionare il database, verificare i permessi sul server MySQL');
					} */

				    // collation
					// mysqlQuery( $cn, 'SET character_set_connection = utf8' );
					mysqlQuery( $cn, 'SET collation_connection = utf8_general_ci' );

				    // timezone
					// mysqlQuery( $cn, 'SET time_zone = ?', array( array( 's' => $cf['localization']['timezone']['name'] ) ) );

				    // localizzazione
					mysqlQuery( $cn, 'SET lc_time_names = ?', array( array( 's' => str_replace( '-', '_', $cf['localization']['language']['ietf'] ) ) ) );

					// modalità SQL
					// mysqlQuery( $cn, 'SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,"ONLY_FULL_GROUP_BY",""));' );

				    // log
					logWrite( 'connessione stabilita: ' . $server, 'mysql' );
					logWrite( 'dettagli: ' . mysqli_get_host_info( $cn ), 'mysql' );

					// log
					writeToFile( 'connessione effettuata' . PHP_EOL, FILE_LATEST_MYSQL );

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

			/*

			// controllo livello di patch database
			$cf['mysql']['profile']['patch']['current'] = readStringFromFile( FILE_MYSQL_PATCH );
			if( file_exists( path2custom( FILE_MYSQL_PATCH ) ) ) {
				$cf['mysql']['profile']['patch']['current'] = readStringFromFile( path2custom( FILE_MYSQL_PATCH ), true );
			} else {
				writeToFile( $cf['mysql']['profile']['patch']['current'], path2custom( FILE_MYSQL_PATCH ) );
			}

			// debug
			// echo $cf['mysql']['profile']['patch']['current'] . '<br>';

			// cerco nuove patch
			$cf['mysql']['profile']['patch']['list'] = getFileList( DIR_USR_DATABASE_PATCH, true );
			sort( $cf['mysql']['profile']['patch']['list'] );

			// eseguo le patch
			foreach( $cf['mysql']['profile']['patch']['list'] as $patch ) {
				$cf['mysql']['profile']['patch']['latest'] = getFileNameWithoutExtension( $patch );
				if( $cf['mysql']['profile']['patch']['latest'] > $cf['mysql']['profile']['patch']['current'] ) {

					// applico la patch
					$query = readStringFromFile( $patch );
					$qRes = mysqlQuery( $cf['mysql']['connection'], $query );

					// aggiorno il livello di patch
					$cf['mysql']['profile']['patch']['current'] = $cf['mysql']['profile']['patch']['latest'];
					writeToFile( $cf['mysql']['profile']['patch']['current'], path2custom( FILE_MYSQL_PATCH ) );

					// log
					if( $qRes !== false ) {
						writeToFile( $query, DIR_VAR_LOG_MYSQL_PATCH . 'done/' . basename( $patch ) );
						logWrite( 'applicata patch ' . $cf['mysql']['profile']['patch']['current'], 'mysql/patch' );
					} else {
						writeToFile( $query, DIR_VAR_LOG_MYSQL_PATCH . 'fail/' . basename( $patch ) );
						logWrite( 'impossibile applicare la patch ' . $cf['mysql']['profile']['patch']['current'], 'mysql/patch', LOG_CRIT );
					}

				}
			}

			// debug
			// echo print_r( $cf['mysql']['profile']['patch']['list'], true );

			*/

			// debug
			// die();

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
