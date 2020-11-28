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

    // inclusione del framework
	require '../_config.php';

    // costanti che descrivono lo stato di funzionamento del framework
	define( 'CRON_RUNNING'			, 'CRONRUN' );

    // apro il report
	writeToFile( date( 'Y/m/d H:i:s' ), FILE_LATEST_CRON );

    // log
	logWrite( 'chiamata cron API', 'cron' );

    // lock delle tabelle
	// mysqlQuery( $cf['mysql']['connection'], 'LOCK TABLES cron WRITE, cron_log WRITE, job WRITE' );

    // tempo
	$time = time();

    // output
	$cf['cron']['results'] = array();

    // chiave di lock
	$cf['cron']['results']['token'] = getToken();

    // metto il lock sui task con profili di schedulazione compatibili con l'orario corrente
	$tasks = mysqlQuery(
	    $cf['mysql']['connection'],
	    'UPDATE cron SET token = ? WHERE '.
	    '( minuto = ?												OR minuto IS NULL ) AND '.
	    '( ora = ?													OR ora IS NULL ) AND '.
	    '( giorno_del_mese = ?										OR giorno_del_mese IS NULL ) AND '.
	    '( mese = ?													OR mese IS NULL ) AND '.
	    '( giorno_della_settimana = ?								OR giorno_della_settimana IS NULL ) AND '.
	    '( settimana = ?											OR settimana IS NULL ) AND '.
		'( from_unixtime( timestamp_esecuzione, "%Y%m%d%H%i") < ?	OR timestamp_esecuzione IS NULL ) AND '.
		'token IS NULL',
	    array(
			array( 's' => $cf['cron']['results']['token'] ),		//
			array( 's' => intval( date( 'i', $time ) ) ),			// 
			array( 's' => date( 'G', $time ) ),						// 
			array( 's' => date( 'j', $time ) ),						// 
			array( 's' => date( 'n', $time ) ),						// 
			array( 's' => date( 'w', $time ) ),						// 0 - 6, 0 -> domenica
			array( 's' => date( 'W', $time ) ),						// 1 - 52/53
			array( 's' => date( 'YmdHi', $time ) )					//
	    )
	);

    // seleziono i task a cui ho applicato il lock
	$cf['cron']['tasks'] = mysqlQuery(
	    $cf['mysql']['connection'],
	    'SELECT * FROM cron WHERE token = ? ',
		array(
			array( 's' => $cf['cron']['results']['token'] )
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
	    'cron'
	);

	/*

    // timestamp di esecuzione iniziale
	foreach( $tasks as $task ) {
	    if( file_exists( DIR_BASE . $task['task'] ) ) {
		mysqlQuery(
		    $cf['mysql']['connection'],
		    'UPDATE cron SET timestamp_esecuzione = ? WHERE id = ?',
		    array(
			array( 's' => $time ),
			array( 's' => $task['id'] )
		    )
		);
	    } else {
		logWrite( 'il file di task ' . $task['task'] . ' non esiste', 'cron', LOG_ERR );
	    }
	}

    // seleziono i job attivi
	$jobs = mysqlQuery(
	    $cf['mysql']['connection'],
	    'SELECT * FROM job WHERE '.
	    'timestamp_apertura <= ? AND timestamp_apertura IS NOT NULL AND timestamp_completamento IS NULL '.
	    'AND ( from_unixtime( timestamp_esecuzione, "%Y%m%d%H%i") < ? OR timestamp_esecuzione IS NULL )',
	    array(
		array( 's' => $time ),
		array( 's' => date( 'YmdHi', $time ) )
	    )
	);

    // log
	logWrite( 'trovati ' . count( $jobs ) . ' job', 'cron' );

    // timestamp di esecuzione iniziale
	foreach( $jobs as $job ) {
	    if( file_exists( DIR_BASE . $job['job'] ) ) {
		mysqlQuery(
		    $cf['mysql']['connection'],
		    'UPDATE job SET timestamp_esecuzione = ? WHERE id = ?',
		    array(
			array( 's' => $time ),
			array( 's' => $job['id'] )
		    )
		);
	    } else {
		logWrite( 'il file di job ' . $job['job'] . ' non esiste', 'cron', LOG_ERR );
	    }
	}

	*/

    // unlock delle tabelle
	// mysqlQuery( $cf['mysql']['connection'], 'UNLOCK TABLES' );

    // ciclo sui task
	foreach( $cf['cron']['tasks'] as $task ) {
	    if( file_exists( DIR_BASE . $task['task'] ) ) {

			// timestamp di esecuzione iniziale
			mysqlQuery(
				$cf['mysql']['connection'],
				'UPDATE cron SET timestamp_esecuzione = ? WHERE id = ?',
				array(
				array( 's' => $time ),
				array( 's' => $task['id'] )
				)
			);

			// resetto lo status
				$status = array();

			// latest
				// fwrite( $cHnd, 'eseguo ' . $task['task']  . ' x' . $task['iterazioni'] . PHP_EOL );

			// log
				logWrite( 'eseguo il task ' . $task['id'] . ' -> ' . $task['task'], 'cron' );

	#		// array dei risultati
	#		    $cf['cron']['results'] = array();

			// eseguo il task
				for( $iter = 0; $iter < $task['iterazioni']; $iter++ ) {
					logWrite( 'iterazione #' . $iter . ' per il task ' . $task['id'] . ' -> ' . $task['task'], 'cron' );
					// fwrite( $cHnd, 'iterazione #' . $iter . PHP_EOL );
					require DIR_BASE . $task['task'];
					$cf['cron']['results']['task'][ $task['task'] ][] = array_replace_recursive( $status, array( 'esecuzione' => time() ) );
					if( ! isset( $task['delay'] ) || empty( $task['delay'] ) ) { $task['delay'] = 3; }
					sleep( $task['delay'] );
				}

			// aggiorno il log
				// mysqlQuery( $cf['mysql']['connection'], 'INSERT INTO cron_log ( id_cron, testo, timestamp_esecuzione ) VALUES ( ?, ?, ? )', array( array( 's' => $task['id'] ), array( 's' => json_encode( $cf['cron']['results'] ) ), array( 's' => $time ) ) );

			// aggiorno la tabella di pianificazione
				mysqlQuery(
					$cf['mysql']['connection'],
					'UPDATE cron SET timestamp_esecuzione = ?, token = NULL WHERE id = ?',
					array(
						array( 's' => $time ),
						array( 's' => $task['id'] )
					)
				);

			// latest
				// fwrite( $cHnd, print_r( $status, true ) . PHP_EOL );

		} else {
			$cf['cron']['results']['errors'][] = 'il file di task ' . $task['task'] . ' non esiste';
			logWrite( 'il file di task ' . $task['task'] . ' non esiste', 'cron', LOG_ERR );
		}

	}

	// metto il lock sui job aperti
		$jobs = mysqlQuery(
			$cf['mysql']['connection'],
			'UPDATE job SET token = ? WHERE '.
			'timestamp_apertura <= ? AND timestamp_apertura IS NOT NULL AND timestamp_completamento IS NULL AND token IS NULL ',
			array(
				array( 's' => $cf['cron']['results']['token'] ),
				array( 's' => $time )
			)
		);
	
    // seleziono i job a cui ho applicato il lock
	$cf['cron']['jobs'] = mysqlQuery(
	    $cf['mysql']['connection'],
	    'SELECT * FROM job WHERE token = ? ',
		array(
			array( 's' => $cf['cron']['results']['token'] )
		)
	);

    // ciclo sui job
	foreach( $cf['cron']['jobs'] as $job ) {
	    if( file_exists( DIR_BASE . $job['job'] ) ) {

		// log
		    logWrite( 'eseguo il job ' . $job['id'] . ' -> ' . $job['job'], 'cron', LOG_DEBUG );

#		// array dei risultati
#		    $cf['cron']['results'] = array();

		// decodifica del workspace
			$job['workspace'] = json_decode( $job['workspace'], true );

		// eseguo il job
			for( $iter = 0; $iter < $job['iterazioni']; $iter++ ) {
				logWrite( 'iterazione #' . $iter . ' per il job ' . $job['id'] . ' -> ' . $job['job'], 'cron' );
				// fwrite( $cHnd, 'iterazione #' . $iter . PHP_EOL );
				require DIR_BASE . $job['job'];
				$cf['cron']['results']['job'][ $job['job'] ][] = array_replace_recursive( $status, array( 'esecuzione' => time() ) );
				if( ! isset( $job['delay'] ) || empty( $job['delay'] ) ) { $job['delay'] = 3; }
				sleep( $job['delay'] );
			}

		// integro la timestamp di esecuzione
		    $cf['cron']['results']['job'][ $job['job'] ][ $job['id'] ] = array_replace_recursive( $status, array( 'esecuzione' => time() ) );

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
			$cf['cron']['results']['errors'][] = 'il file di job ' . $job['job'] . ' non esiste';
			logWrite( 'il file di job ' . $job['job'] . ' non esiste', 'cron', LOG_ERR );
		}
	}

    // log
	appendToFile( '-- ' . date( 'Y-m-d H:i:s' ) . PHP_EOL . print_r( $cf['cron']['results'], true ), 'var/log/cron/' . date( 'YmdH' ) . '.log' );

	// log
	writeToFile( '-- ' . date( 'Y-m-d H:i:s' ) . PHP_EOL . print_r( $cf['cron']['results'], true ), FILE_LATEST_CRON );

    // output
	buildJson( $cf['cron']['results'] );
