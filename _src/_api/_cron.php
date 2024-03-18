<?php

    /**
     *
     *
     *
     * @todo commentare
     *
     * @file
     *
     */

    // costanti che descrivono lo stato di funzionamento del framework
	define( 'CRON_RUNNING'			, 'CRONRUN' );

    // inclusione del framework
	require '../_config.php';

    // apro il report
	writeToFile( date( 'Y/m/d H:i:s' ), FILE_LATEST_CRON );

    // log
	appendToFile( 'avvio API cron' . PHP_EOL, FILE_LATEST_RUN );

    // log
	logWrite( 'chiamata cron API', 'cron' );

    // tempo
	$time = time();

    // output
	$status = array();

    // chiave di lock
	$status['token'] = getToken( __FILE__ );

    // provo a recuperare i task fermi
    mysqlQuery(
        $cf['mysql']['connection'],
        'UPDATE task SET token = NULL WHERE token IS NOT NULL AND timestamp_esecuzione < ?',
        array(
            array( 's' => strtotime( '-10 minutes' ) )
        )
    );

    // metto il lock sui task con profili di schedulazione compatibili con l'orario corrente
	$tasks = mysqlQuery(
	    $cf['mysql']['connection'],
	    'UPDATE task SET token = ? WHERE '.
	    '( minuto = ?												OR minuto IS NULL ) AND '.
	    '( ora = ?													OR ora IS NULL ) AND '.
	    '( giorno_del_mese = ?										OR giorno_del_mese IS NULL ) AND '.
	    '( mese = ?													OR mese IS NULL ) AND '.
	    '( giorno_della_settimana = ?								OR giorno_della_settimana IS NULL ) AND '.
	    '( settimana = ?											OR settimana IS NULL ) AND '.
		'( from_unixtime( timestamp_esecuzione, "%Y%m%d%H%i") < ?	OR timestamp_esecuzione IS NULL ) AND '.
		'( token IS NULL OR ( timestamp_esecuzione < ? ) )',
	    array(
			array( 's' => $status['token'] ),		                //
			array( 's' => intval( date( 'i', $time ) ) ),			// 
			array( 's' => date( 'G', $time ) ),						// 
			array( 's' => date( 'j', $time ) ),						// 
			array( 's' => date( 'n', $time ) ),						// 
			array( 's' => date( 'N', $time ) ),						// 1 - 7, 1 -> lunedì
			array( 's' => date( 'W', $time ) ),						// 1 - 52/53
			array( 's' => date( 'YmdHi', $time ) ),					//
			array( 's' => strtotime( '-10 minutes' ) )				//
	    )
	);

    // seleziono i task a cui ho applicato il lock
	$cf['cron']['task'] = mysqlQuery(
	    $cf['mysql']['connection'],
	    'SELECT * FROM task WHERE token = ? ',
		array(
			array( 's' => $status['token'] )
		)
	);

	// log
	logWrite( 'criteri di ricerca -> '
	    . date( 'i', $time ) . ' '
	    . date( 'G', $time ) . ' '
	    . date( 'j', $time ) . ' '
	    . date( 'n', $time ) . ' '
	    . date( 'N', $time ) . ' '
	    . date( 'W', $time ),
	    'task'
	);

	// verifico se ci sono dei job aperti
	if( is_array( $cf['cron']['task'] ) ) {

		// log
		logWrite( 'task trovati: ' . print_r( $cf['cron']['task'], true), 'cron' );

		// ciclo sui task
		foreach( $cf['cron']['task'] as $task ) {

            // controllo che il file del task esista
            if( file_exists( DIR_BASE . $task['task'] ) ) {

                /*
                    // timestamp di esecuzione iniziale
                    mysqlQuery(
                        $cf['mysql']['connection'],
                        'UPDATE task SET timestamp_esecuzione = ? WHERE id = ?',
                        array(
                        array( 's' => $time ),
                        array( 's' => $task['id'] )
                        )
                    );
                */

				// resetto lo status
					// $status = array();

				// log
					logWrite( 'eseguo il task ' . $task['id'] . ' -> ' . $task['task'], 'cron' );

				// eseguo il task
					if( ! empty( $task['iterazioni'] ) ) {

                        // iterazioni del task
                        for( $iter = 0; $iter < $task['iterazioni']; $iter++ ) {

                            // ...
                            // $task['timer'][ $iter ]['start'] = microtime( true );

                            // ...
                            logWrite( 'iterazione #' . $iter . ' per il task ' . $task['id'] . ' -> ' . $task['task'], 'cron' );

                            // ...
                            require DIR_BASE . $task['task'];

                            // $status['task'][ $task['id'] ][ $iter ] = array_replace_recursive( $task['status'], array( 'esecuzione' => time() ) );

                            // ...
                            // $task['timer'][ $iter ]['end'] = microtime( true );

                            // ...
                            // $task['timer'][ $iter ]['elapsed'] = $task['timer'][ $iter ]['end'] - $task['timer'][ $iter ]['start'];

                            // ...
                            writeToFile( print_r( $task, true ), DIR_VAR_LOG_TASK . $task['id'] . '/' . microtime( true ) . '.log' );

                            // if( ! isset( $task['delay'] ) || empty( $task['delay'] ) ) { $task['delay'] = mt_rand( 1, 2 ); }
							// sleep( $task['delay'] );

                        }

                        // aggiorno la tabella di pianificazione
                        mysqlQuery(
                            $cf['mysql']['connection'],
                            'UPDATE task SET timestamp_esecuzione = ?, token = NULL WHERE id = ?',
                            array(
                                array( 's' => $time ),
                                array( 's' => $task['id'] )
                            )
                        );

                    } else {

                        // status
                        $status['task'][ $task['id'] ]['errors'][] = 'il task ' . $task['id'] . ' ha specificato un numero di iterazioni nullo, è voluto?';

                        // log
                        logWrite( 'il task ' . $task['id'] . ' ha iterazioni nulle', 'cron', LOG_ERR );

                    }
		
			} else {

                // status
                $status['task'][ $task['id'] ]['errors'][] = 'il file di task ' . $task['task'] . ' non esiste';

                // log
                logWrite( 'il file di task ' . $task['task'] . ' non esiste', 'cron', LOG_ERR );

            }

        }

        /*	$cf['cron']['cache']['view']['static']['refresh'] = array_unique( $cf['cron']['cache']['view']['static']['refresh'] );
		
            if( !empty($cf['cron']['cache']['view']['static']['refresh']  ) ){
                foreach( $cf['cron']['cache']['view']['static']['refresh'] as $s ){
                    // riattivo i trigger per l'entità
                    triggerOn( $s );

                    // chiamo le statiche per ripopolare
                    $exec = mysqlQuery(
                        $cf['mysql']['connection'],
                        'CALL ' . $s . '_view_static(NULL)'
                    );
                }
            }
        */

        // log
        writeToFile( print_r( $task, true ), DIR_VAR_LOG_TASK . $task['id'] . '.log' );

	} else {

		// log
		logWrite( 'nessun task trovato', 'cron' );

	}

    // provo a recuperare i job fermi
    mysqlQuery(
        $cf['mysql']['connection'],
        'UPDATE job SET token = NULL WHERE token IS NOT NULL AND timestamp_completamento IS NULL AND timestamp_esecuzione < ?',
        array(
            array( 's' => strtotime( '-10 minutes' ) )
        )
    );

    // porto in background i job fermi in foreground
    mysqlQuery(
        $cf['mysql']['connection'],
        'UPDATE job SET se_foreground = NULL WHERE timestamp_completamento IS NULL AND timestamp_esecuzione < ?',
        array(
            array( 's' => strtotime( '-10 minutes' ) )
        )
    );

	// metto il lock sui job aperti
	$jobs = mysqlQuery(
		$cf['mysql']['connection'],
		'UPDATE job SET token = ?, timestamp_esecuzione = ? WHERE '.
		'( timestamp_apertura <= ? OR timestamp_apertura IS NULL ) '.
		'AND timestamp_completamento IS NULL '.
		'AND ( token IS NULL ) '.
		'AND se_foreground IS NULL ',
		array(
			array( 's' => $status['token'] ),
			array( 's' => $time ),
			array( 's' => $time )
		)
	);
	
    // seleziono i job a cui ho applicato il lock
	$cf['cron']['job'] = mysqlQuery(
	    $cf['mysql']['connection'],
	    'SELECT * FROM job WHERE token = ? ',
		array(
			array( 's' => $status['token'] )
		)
	);

	// verifico se ci sono dei job aperti
	if( is_array( $cf['cron']['job'] ) ) {

		// log
		logWrite( 'job trovati: ' . print_r( $cf['cron']['job'], true), 'cron' );

		// ciclo sui job
		foreach( $cf['cron']['job'] as $job ) {

            // controllo che il file del job esista
            if( file_exists( DIR_BASE . $job['job'] ) ) {

				// log
					logWrite( 'eseguo il job ' . $job['id'] . ' -> ' . $job['job'], 'cron', LOG_DEBUG );

				// resetto lo status
					// $status = array();

				// decodifica del workspace
					$job['workspace'] = json_decode( $job['workspace'], true );

				// eseguo il job
					if( ! empty( $job['iterazioni'] ) ) {

                        for( $iter = 0; $iter < $job['iterazioni']; $iter++ ) {

                            // ...
                            // $job['timer'][ $iter ]['start'] = microtime( true );

                            // ...
                            logWrite( 'iterazione #' . $iter . ' per il job ' . $job['id'] . ' -> ' . $job['job'], 'cron' );

                            // ...
                            require DIR_BASE . $job['job'];

                            // $status['job'][ $job['job'] ][ $iter ] = array_replace_recursive( $job['status'], array( 'esecuzione' => time() ) );

                            // ...
                            // $job['timer'][ $iter ]['end'] = microtime( true );

                            // ...
                            // $job['timer'][ $iter ]['elapsed'] = $job['timer'][ $iter ]['end'] - $job['timer'][ $iter ]['start'];

                            // ...
                            writeToFile( print_r( $job, true ), DIR_VAR_LOG_JOB . $job['id'] . '/' . $job['corrente'] . '.' . microtime( true ) . '.log' );

                            // if( ! isset( $job['delay'] ) || empty( $job['delay'] ) ) { $job['delay'] = mt_rand( 1, 2 ); }
							// sleep( $job['delay'] );

                        }

                        // aggiorno la tabella di avanzamento lavori
                        mysqlQuery(
                            $cf['mysql']['connection'],
                            'UPDATE job SET timestamp_esecuzione = ?, workspace = ?, token = NULL WHERE id = ?',
                            array(
                                array( 's' => $time ),
                                array( 's' => json_encode( $job['workspace'] ) ),
                                array( 's' => $job['id'] )
                            )
                        );

                } else {

                        // status
                        $status['job'][ $job['id'] ]['errors'][] = 'il job ' . $job['job'] . ' ha specificato un numero di iterazioni nullo, è voluto?';

                        // log
                        logWrite( 'il job ' . $job['job'] . ' ha iterazioni nulle', 'cron', LOG_ERR );

                    }

			} else {

                // status
				$status['job'][ $job['id'] ]['errors'][] = 'il file di job ' . $job['job'] . ' non esiste';

                // log
                logWrite( 'il file di job ' . $job['job'] . ' non esiste', 'cron', LOG_ERR );

			}

            /*
                // aggiorno la tabella di avanzamento lavori
                mysqlQuery(
                    $cf['mysql']['connection'],
                    'UPDATE job SET timestamp_esecuzione = ?, token = NULL WHERE id = ?',
                    array(
                        array( 's' => $time ),
                        array( 's' => $job['id'] )
                    )
                );
            */

            // log
            writeToFile( print_r( $job, true ), DIR_VAR_LOG_JOB . $job['id'] . '.log' );

		}

	} else {

		// log
		logWrite( 'nessun job trovato', 'cron' );

	}

    // log
	appendToFile( '-- ' . date( 'Y-m-d H:i:s' ) . PHP_EOL . print_r( $status, true ), DIR_VAR_LOG_CRON . date( 'YmdH' ) . '.log' );

	// log
	writeToFile( '-- ' . date( 'Y-m-d H:i:s' ) . PHP_EOL . print_r( $status, true ), FILE_LATEST_CRON );

	// output
	buildJson( $status );
