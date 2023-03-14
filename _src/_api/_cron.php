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
	$cf['cron']['task']['results'] = array();

    // chiave di lock
	$cf['cron']['task']['results']['token'] = getToken( __FILE__ );

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
			array( 's' => $cf['cron']['task']['results']['token'] ),		//
			array( 's' => intval( date( 'i', $time ) ) ),			// 
			array( 's' => date( 'G', $time ) ),						// 
			array( 's' => date( 'j', $time ) ),						// 
			array( 's' => date( 'n', $time ) ),						// 
			array( 's' => date( 'w', $time ) ),						// 0 - 6, 0 -> domenica
			array( 's' => date( 'W', $time ) ),						// 1 - 52/53
			array( 's' => date( 'YmdHi', $time ) ),					//
			array( 's' => strtotime( '-10 minutes' ) )				//
	    )
	);

    // seleziono i task a cui ho applicato il lock
	$cf['cron']['task']['tasks'] = mysqlQuery(
	    $cf['mysql']['connection'],
	    'SELECT * FROM task WHERE token = ? ',
		array(
			array( 's' => $cf['cron']['task']['results']['token'] )
		)
	);

	// log
	logWrite( 'criteri di ricerca -> '
	    . date( 'i', $time ) . ' '
	    . date( 'G', $time ) . ' '
	    . date( 'j', $time ) . ' '
	    . date( 'n', $time ) . ' '
	    . date( 'w', $time ) . ' '
	    . date( 'W', $time ),
	    'task'
	);

	// verifico se ci sono dei job aperti
	if( is_array( $cf['cron']['task']['tasks'] ) ) {

		// log
		logWrite( 'task trovati: ' . print_r( $cf['cron']['task']['tasks'], true), 'cron' );

		// ciclo sui task
		foreach( $cf['cron']['task']['tasks'] as $task ) {
			if( file_exists( DIR_BASE . $task['task'] ) ) {

				// timestamp di esecuzione iniziale
				mysqlQuery(
					$cf['mysql']['connection'],
					'UPDATE task SET timestamp_esecuzione = ? WHERE id = ?',
					array(
					array( 's' => $time ),
					array( 's' => $task['id'] )
					)
				);

				// resetto lo status
					$status = array();

				// log
					logWrite( 'eseguo il task ' . $task['id'] . ' -> ' . $task['task'], 'cron' );

				// eseguo il task
					if( ! empty( $task['iterazioni'] ) ) {
						for( $iter = 0; $iter < $task['iterazioni']; $iter++ ) {
							logWrite( 'iterazione #' . $iter . ' per il task ' . $task['id'] . ' -> ' . $task['task'], 'cron' );
							// fwrite( $cHnd, 'iterazione #' . $iter . PHP_EOL );
							require DIR_BASE . $task['task'];
							$cf['cron']['task']['results']['task'][ $task['task'] ][] = array_replace_recursive( $status, array( 'esecuzione' => time() ) );
							if( ! isset( $task['delay'] ) || empty( $task['delay'] ) ) { $task['delay'] = mt_rand( 1, 2 ); }
							sleep( $task['delay'] );
						}
					} else {
						$cf['cron']['task']['results']['errors'][] = 'il task ' . $job['task'] . ' ha specificato un numero di iterazioni nullo, è voluto?';
						logWrite( 'il task ' . $task['task'] . ' ha iterazioni nulle', 'cron', LOG_ERR );
					}
		
			} else {
				$cf['cron']['task']['results']['errors'][] = 'il file di task ' . $task['task'] . ' non esiste';
				logWrite( 'il file di task ' . $task['task'] . ' non esiste', 'cron', LOG_ERR );
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

	} else {

		// log
		logWrite( 'nessun task trovato', 'cron' );

	}

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
		'AND ( token IS NULL OR timestamp_esecuzione < ? ) '.
		'AND se_foreground IS NULL ',
		array(
			array( 's' => $cf['cron']['task']['results']['token'] ),
			array( 's' => $time ),
			array( 's' => $time ),
			array( 's' => $time )
		)
	);
	
    // seleziono i job a cui ho applicato il lock
	$cf['cron']['job'] = mysqlQuery(
	    $cf['mysql']['connection'],
	    'SELECT * FROM job WHERE token = ? ',
		array(
			array( 's' => $cf['cron']['task']['results']['token'] )
		)
	);

	// verifico se ci sono dei job aperti
	if( is_array( $cf['cron']['job'] ) ) {

		// log
		logWrite( 'job trovati: ' . print_r( $cf['cron']['job'], true), 'cron' );

		// ciclo sui job
		foreach( $cf['cron']['job'] as $job ) {
			if( file_exists( DIR_BASE . $job['job'] ) ) {

				// log
					logWrite( 'eseguo il job ' . $job['id'] . ' -> ' . $job['job'], 'cron', LOG_DEBUG );

				// resetto lo status
					$status = array();

				// decodifica del workspace
					$job['workspace'] = json_decode( $job['workspace'], true );

				// eseguo il job
					if( ! empty( $job['iterazioni'] ) ) {
						for( $iter = 0; $iter < $job['iterazioni']; $iter++ ) {
							logWrite( 'iterazione #' . $iter . ' per il job ' . $job['id'] . ' -> ' . $job['job'], 'cron' );
							// fwrite( $cHnd, 'iterazione #' . $iter . PHP_EOL );
							require DIR_BASE . $job['job'];
							$cf['cron']['results']['job'][ $job['job'] ][] = array_replace_recursive( $status, array( 'esecuzione' => time() ) );
							if( ! isset( $job['delay'] ) || empty( $job['delay'] ) ) { $job['delay'] = mt_rand( 1, 2 ); }
							sleep( $job['delay'] );
						}
					} else {
						$cf['cron']['results']['errors'][] = 'il job ' . $job['job'] . ' ha specificato un numero di iterazioni nullo, è voluto?';
						logWrite( 'il job ' . $job['job'] . ' ha iterazioni nulle', 'cron', LOG_ERR );
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

				// log
					appendToFile( print_r( $status, true ), DIR_VAR_LOG_JOB . $job['id'] . '.log' );

			} else {

				$cf['cron']['results']['errors'][] = 'il file di job ' . $job['job'] . ' non esiste';
				logWrite( 'il file di job ' . $job['job'] . ' non esiste', 'cron', LOG_ERR );

				// aggiorno la tabella di avanzamento lavori
				mysqlQuery(
					$cf['mysql']['connection'],
					'UPDATE job SET timestamp_esecuzione = ?, token = NULL WHERE id = ?',
					array(
						array( 's' => $time ),
						array( 's' => $job['id'] )
					)
				);

			}

		}

	} else {

		// log
		logWrite( 'nessun job trovato', 'cron' );

	}

    // log
	appendToFile( '-- ' . date( 'Y-m-d H:i:s' ) . PHP_EOL . print_r( $cf['cron']['task']['results'], true ), DIR_VAR_LOG_CRON . date( 'YmdH' ) . '.log' );

	// log
	writeToFile( '-- ' . date( 'Y-m-d H:i:s' ) . PHP_EOL . print_r( $cf['cron']['task']['results'], true ), FILE_LATEST_CRON );

	// output
	buildJson( $cf['cron']['task']['results'] );
