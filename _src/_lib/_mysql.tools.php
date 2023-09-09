<?php

    /**
     * libreria di funzioni di supporto per MySQL
     *
     * introduzione
     * ============
     *
     *
     *
     * prepared statements
     * -------------------
     *
     *
     *
     * cache delle query
     * -----------------
     *
     *
     *
     * costanti
     * --------
     *
     *
     *
     * dipendenze
     * ----------
     *
     *
     *
     *
     *
     * @todo raggruppare in una funzione mysqlHandleError() il codice per la gestione degli errori che è duplicato in mysqlQuery() e in mysqlPreparedQuery()
     * @todo documentare
     *
     * @file
     *
     */

    /**
     *
	 * questa funzione restituisce un array delle tabelle coinvolte in una query mysql 
	 * 
     * @todo documentare
     *
     */
    function mysqlGetQueryTables( $q ) {

	$r = array();

	if( preg_match_all( '/((FROM|JOIN) ([a-z_]+))/', $q, $m ) ) {
	    $r = array_unique( $m[3] );
	    array_walk( $r, function( &$v, $k ) { $v = str_replace( '_view', '', $v ); } );
	}

	return $r;

    }

    /**
     *
     * @todo documentare
     *
     */
    function mysqlCachedIndexedQuery( &$i, $m, $c, $q, $p = false, $t = MEMCACHE_DEFAULT_TTL, &$e = array() ) {

		return mysqlCachedQuery( $m, $c, $q, $p, $t, $e, $i );

	}

    /**
     *
     * @todo documentare
     *
     */
    function mysqlCachedQuery( $m, $c, $q, $p = false, $t = MEMCACHE_DEFAULT_TTL, &$e = array(), &$i = array() ) {

	// calcolo la chiave della query
	    $k = md5( $q . serialize( $p ) );

	// cerco il valore in cache
	    $r = memcacheRead( $m, $k );

	// se il valore non è stato trovato
	    if( $r === false || $t === false ) {

			$d = mysqlQuery( $c, $q, $p, $e );
			memcacheWrite( $m, $k, $d, $t );
			logWrite( 'query ' . $k . ' non presente in cache', 'speed' );

			foreach( mysqlGetQueryTables( $q ) as $j ) {
				$i[ $j ]['query'][ memcacheUniqueKey( $k ) ] = time();
			}

			return $d;

		} else {
			logWrite( 'query ' . $k . ' letta dalla cache', 'speed' );
	    }

	// restituisco il risultato
	    return $r;

    }

    /**
     *
     * @todo documentare
     *
     */
    function mysqlQuery( $c, $q, $p = false, &$e = array() ) {

	// log
	    logWrite( md5( $q ) . ' ' . $q, 'mysql' );

	// log
		appendToFile( $q . PHP_EOL, FILE_LATEST_MYSQL );

	// verifico se c'è connessione e se la query è preparata o meno
	    if( empty( $c ) ) {

		// log
		    logWrite( 'chiamata a mysqlQuery() con connessione assente', 'mysql', LOG_ERR );

		// restituisco false
		    return false;

	    } elseif( $p !== false ) {

		// passo alla funzione con prepared statement
		    return mysqlPreparedQuery( $c, $q, $p, $e );

	    } else {

		// cronometro
		    $tStart = timerNow();

		// debug
		    // echo $q . PHP_EOL;

		// in base al tipo di comando eseguo la query
		    switch( current( explode( ' ', str_replace( "\n", ' ', trim( $q ) ) ) ) ) {

			case 'SELECT':
			case 'SHOW':
			    $r = mysqlFetchResult( mysqli_query( $c, $q ) );
			break;

			case 'CALL':
				$r = mysqli_query( $c, $q );
			break;
			
			case 'SET':
			    $r = mysqli_query( $c, $q );
			break;

			case 'BEGIN':
			case 'START':
			    $r = mysqli_begin_transaction( $c );
			break;

			case 'ROLLBACK':
			    $r = mysqli_rollback( $c );
			break;

			case 'COMMIT':
			    $r = mysqli_commit( $c );
			break;

			case 'LOCK':
			case 'UNLOCK':
			    $r = mysqli_query( $c, $q );
			break;

			case 'ALTER':
			case 'CREATE':
			case 'DROP':
			case 'OPTIMIZE':
			    $r = mysqli_query( $c, $q );
			break;

			case 'INSERT':
			    mysqli_query( $c, $q );
			    $r = mysqli_insert_id( $c );
			break;

			case 'REPLACE':
			case 'UPDATE':
			case 'DELETE':
			case 'TRUNCATE':
			    mysqli_query( $c, $q );
			    $r = mysqli_affected_rows( $c );
			break;

			default:
			    logWrite( 'comando MySQL sconosciuto: ' . current( explode( ' ', str_replace( "\n", ' ', $q ) ) ), 'mysql', LOG_ERR );
			    return false;
			break;

		    }

		// cronometro
		    $tElapsed = sprintf( '%0.11f', timerDiff( $tStart ) );

		// log
		    if( $tElapsed > 0.5 ) {
			logWrite( $q . ' -> TEMPO ' . str_pad( $tElapsed, 21, ' ', STR_PAD_LEFT ) . ' secondi', 'speed', LOG_ERR ); 
			appendToFile( str_pad( $tElapsed, 21, ' ', STR_PAD_LEFT ) . ' secondi -> ' . $q . PHP_EOL, '/var/log/slow/mysql/' . date( 'YmdH' ) . '.log' );
		    }

		// debug
			// var_dump( mysqli_errno( $c ) );
			// var_dump( $r );

		// gestione errore
		    if( mysqli_errno( $c ) ) {

			// log
			    logWrite( md5( $q ) . ' -> ERRORE ' . mysqli_errno( $c ) . ' ' . mysqli_error( $c ) . '§query -> ' . $q, 'mysql', LOG_ERR );

			// gestione specifici errori
			    switch( mysqli_errno( $c ) ) {

				case 1062:
				    $e['1062'][] = 'errore MySQL 1062, dati dupilcati';
				break;

				case 1054:
				    $e['1054'][] = 'errore MySQL 1054, nome colonna errato';
				break;

				default:
				    $e[ mysqli_errno( $c ) ][] = mysqli_error( $c );
				break;

			    }

			// restituisco false per indicare il fallimento della query
			    return false;

		    } else {

			// log
			    logWrite( md5( $q ) . ' -> OK', 'mysql' );

			// restituisco il risultato
			    return $r;

		    }

	    }

	// restituisco false di default
	    return false;

    }

    /**
     *
     * @todo documentare
     *
     */
    function mysqlFetchResult( $r ) {

	// array del risultato
	    $rs = array();

	// archivio il risultato in un array
	// @todo controllare che sia un object result mysql
#	    if( ( is_resource( $r ) ? get_resource_type( $r ) : gettype( $r ) ) == 'mysql' ) {
		while( $row = @mysqli_fetch_assoc( $r ) ) {
		    $rs[] = $row;
		}
#	    }

	// restituisco il risultato
	    return $rs;

    }

    /**
     *
     * @todo documentare
     *
     */
    function mysqlPreparedQuery( $c, $q, $params = array(), &$e = array() ) {

	// log
	    logWrite( md5( $q ) . ' PREPARED ' . $q, 'mysql' );

	// verifico se c'è connessione
	    if( empty( $c ) ) {

		// restituisco false
		    return false;

	    } else {

		// cronometro
		    $tStart = timerNow();

		// preparo la query...
		    $pq = mysqli_prepare( $c, $q );

		// se la preparazione dello statement è andata a buon fine...
		    if( $pq !== false ) {

			// se ci sono dei parametri da bindare...
			    if( is_array( $params ) && count( $params ) ) {

				// preparazione dei parametri per il bind
				    $aParams[0] = $pq;
				    $aParams[1] = '';
				    foreach( $params as $key => $val ) {
						$type = current( array_keys( $val ) );
						$aParams[1] .= $type;
						$aParams[] = &$params[ $key ][ $type ];
						if( ( $type == 'i' || $type == 'd' ) && empty( $params[ $key ][ $type ] ) ) {
							$params[ $key ][ $type ] = NULL;
						}
						if( is_array( $params[ $key ][ $type ] ) ) {
							die( 'passare solo stringhe come parametri della query: ' . PHP_EOL . $q . PHP_EOL . PHP_EOL . 'oggetto malformato: ' . print_r( $val, true ) );
						}
					}

				// bind dei parametri
				    call_user_func_array( 'mysqli_stmt_bind_param', $aParams );

			    }

			// esecuzione dello statement
			    $xStatement = mysqli_stmt_execute( $pq );

			// cronometro
			    $tElapsed = sprintf( '%0.11f', timerDiff( $tStart ) );

			// log
			    if( $tElapsed > 0.5 ) {
				logWrite( $q . ' -> TEMPO ' . str_pad( $tElapsed, 21, ' ', STR_PAD_LEFT ) . ' secondi', 'speed', LOG_ERR );
				appendToFile( str_pad( $tElapsed, 21, ' ', STR_PAD_LEFT ) . ' secondi -> ' . $q . PHP_EOL, '/var/log/slow/mysql/' . date( 'YmdH' ) . '.log' );
			    }

			// debug
				// var_dump( mysqli_errno( $c ) );

			// gestione errore
			    if( mysqli_errno( $c ) ) {

				// log
				    logWrite( md5( $q ) . ' -> ERRORE ' . mysqli_errno( $c ) . ' ' . mysqli_error( $c ) . '§query -> ' . $q, 'mysql', LOG_ERR );

				// gestione specifici errori
				    switch( mysqli_errno( $c ) ) {

					case 1062:
					    $e['1062'][] = 'errore MySQL 1062, dati dupilcati';
					break;

					default:
					    $e[ mysqli_errno( $c ) ][] = mysqli_error( $c );
					break;

				    }

				// restituisco false per indicare il fallimento della query
				    return false;

			    } else {

				// log
				    logWrite( md5( $q ) . ' -> OK', 'mysql' );

				// valore di ritorno a seconda del tipo di query
				    switch( current( explode( ' ', $q ) ) ) {

					case 'SELECT':
					    return mysqlFetchPreparedResult( $pq );
					break;

					case 'INSERT':
					    $id = mysqli_stmt_insert_id( $pq );
					    return ( ( ! empty( $id ) ) ? $id : ( ( isset( $params['id']['s'] ) ) ? $params['id']['s'] : NULL ) );
					break;

					case 'REPLACE':
					case 'UPDATE':
					case 'DELETE':
					case 'TRUNCATE':
					default:
					    return mysqli_stmt_affected_rows( $pq );
					break;

				    }

			    }

		    } else {

				// log
					logWrite( md5( $q ) . ' -> ERRORE ' . mysqli_errno( $c ) . ' ' . mysqli_error( $c ) . '§query -> ' . $q, 'mysql', LOG_ERR );

				// debug
					// var_dump( mysqli_errno( $c ) );

				// gestione errore
				if( mysqli_errno( $c ) ) {

					// log
						logWrite( md5( $q ) . ' -> ERRORE ' . mysqli_errno( $c ) . ' ' . mysqli_error( $c ) . '§query -> ' . $q, 'mysql', LOG_ERR );

					// gestione specifici errori
						switch( mysqli_errno( $c ) ) {

						case 1054:
							$e['1054'][] = 'errore MySQL 1054, nome colonna errato';
						break;
		
						default:
							$e[ mysqli_errno( $c ) ][] = mysqli_error( $c );
						break;

						}

					}

				// restituisco false
					return false;

		    }

	    }

	// restituisco false di default
	    return false;

    }

    /**
     *
     * @todo documentare
     *
     */
    function mysqlFetchPreparedResult( $pq ) {

		// array del risultato
			$arRs = array();

		// estraggo il resultset dallo statement
			$r = mysqli_stmt_get_result( $pq );

		// fetch del risultato
			while( $row = mysqli_fetch_assoc( $r ) ) {
				$arRs[] = $row;
			}

		// restituisco il risultato
			return $arRs;

    }

    /**
     *
     * @todo documentare
     *
     */
    function mysqlSelectValue( $c, $q, $p = false, &$e = array() ) {

	// valore di ritorno
	    $v = NULL;

	// risultato
	    $r = mysqlSelectRow( $c, $q, $p, $e );

	// controllo che ci siano righe
	    if( is_array( $r ) && count( $r ) > 0 ) {
		$v = array_shift( $r );
	    }

	// ritorno
	    return $v;

    }

    /**
     *
     * @todo documentare
     *
     */
    function mysqlSelectColumn( $f, $c, $q, $p = false, &$e = array() ) {

	// valore di ritorno
	    $r = array();

	// prelevo il risultato
	    $rs = mysqlQuery( $c, $q, $p, $e );

	// risultato
	    if( is_array( $rs ) ) {
		$r = array_column( $rs, $f );
	    }

	// ritorno
	    return $r;

    }

    /**
     *
     * @todo documentare
     *
     */
    function mysqlSelectCachedColumn( $m, $f, $c, $q, $p = false, &$e = array() ) {

	// valore di ritorno
	    $r = array();

	// prelevo il risultato
	    $rs = mysqlCachedQuery( $m, $c, $q, $p, $e );

	// risultato
	    if( is_array( $rs ) ) {
		$r = array_column( $rs, $f );
	    }

	// ritorno
	    return $r;

    }

    /**
     *
     * @todo documentare
     *
     */
    function mysqlSelectRow( $c, $q, $p = false, &$e = array() ) {

	// valore di ritorno
	    $v = array();

	// risultato
	    $r = mysqlQuery( $c, $q, $p, $e );

	// controllo che ci siano righe
	    if( is_array( $r ) && count( $r ) > 0 ) {
		$v = array_shift( $r );
	    } else {
		logWrite( 'nessuna riga trovata nel risultato', 'mysql' );
	    }

	// ritorno
	    return $v;

    }

    /**
     *
     * @todo documentare
     *
     */
    function mysqlSelectCachedValue( $m, $c, $q, $p = false, $t = MEMCACHE_DEFAULT_TTL, &$e = array() ) {

	// valore di ritorno
	    $v = NULL;

	// risultato
	    $r = mysqlSelectCachedRow( $m, $c, $q, $p, $t, $e );

	// controllo che ci siano righe
	    if( is_array( $r ) && count( $r ) > 0 ) {
		$v = array_shift( $r );
	    }

	// ritorno
	    return $v;

    }

    /**
     *
     * @todo documentare
     *
     */
    function mysqlSelectCachedRow( $m, $c, $q, $p = false, $t = MEMCACHE_DEFAULT_TTL, &$e = array() ) {

	// valore di ritorno
	    $v = array();

	// risultato
	    $r = mysqlCachedQuery( $m, $c, $q, $p, $t, $e );

	// controllo che ci siano righe
	    if( is_array( $r ) && count( $r ) > 0 ) {
		$v = array_shift( $r );
	    }

	// ritorno
	    return $v;

    }

    /**
	 * effettua la duplicazione ricorsiva di un oggetto e degli eventuali oggetti figli nelle tabelle correlate
	 * 
     * @param	mysqli		$c		connessione mysqli
	 * @param	string		$t		nome della tabella in cui si trova il record principale da duplicare
	 * @param	string		$o		id dell'oggetto da duplicare
	 * @param	string		$n		id dell'oggetto figlio ottenuto, passare NULL per autoincrement
	 * @param	string		$x		puntatore ad un array costruito come nell'esempio seguente, contenente due chiavi:
	 * 								- t: array delle tabelle coinvolte nella duplicazione
	 * 								- f: array che consente, per il nuovo record creato, di impostare un valore per determinati campi. contiene in chiave i nomi dei campi e in valore il corrispondente valore
	 * 
	 * esempio di array per la duplicazione di una pagina con relativi contenuti e immagini, e dei contenuti associati alle immagini
	 * 
	 * $tbls = array(
     *      't' => array(
     *          'pagine' => array(
     *               't' => array(
     *                   'contenuti' => array(),
     *                   'immagini' => array(
     *                       't' => array(
     *                           'contenuti' => array()
     *                       )
     *                   )
     *               ),
     *               'f' => array(
     *                   'nome' => $p['nome'] . ' - duplicata'
     *               )
     *           )
     *      )
     * );

     * @todo finire di documentare
     *
     */
    function mysqlDuplicateRowRecursive( $c, $t, $o, $n = NULL, &$x = array(), &$y = array() ) {

		// debug
	#	echo "chiamata mysqlDuplicateRowRecursive per array x" . PHP_EOL;
	#	print_r($x);
	#	echo "tabella principale: " . $t . " - stampo x[" . $t . "]" . PHP_EOL;
	#	print_r( $x['t'][ $t ] );

		// defaults
		if( ! isset( $x['t'][ $t ]['f'] ) ) { $x['t'][ $t ]['f'] = array(); }
		if( ! isset( $x['t'][ $t ]['t'] ) ) { $x['t'][ $t ]['t'] = array(); }

		// se non ho un ID di partenza
		if( empty( $o ) ) {
			die( 'ID da duplicare non passato' );
		}

		// defaults
		if( ! isset( $x['t'][ $t ]['f'] ) ) { $x['t'][ $t ]['f'] = array(); }
		if( ! isset( $x['t'][ $t ]['t'] ) ) { $x['t'][ $t ]['t'] = array(); }

		// duplico la riga
		$id = mysqlDuplicateRow( $c, $t, $o, $n, $x['t'][ $t ]['f'], $y );

		// debug
	#	 echo 'ID riga duplicata = ' . $id . PHP_EOL;

		// creo i placeholder per le tabelle richieste
		$pholders = array();
		$values = array( array( 's' => $t ) );
		foreach( array_keys( $x['t'][ $t ]['t'] ) as $rt ) {
			$pholders[] = '?';
			$values[] = array( 's' => $rt );
		}
		$values[] = array( 's' => $t );

		// cerco le tabelle collegate
		$ks = mysqlQuery( $c,
			'SELECT * FROM information_schema.key_column_usage '.
			'WHERE referenced_table_name = ? '.
#			'AND ( constraint_name NOT LIKE "%_nofollow" OR '.
#			'table_name IN ( ' . implode( ',', $pholders ) . ' ) ) '.
			( ( is_array( $pholders ) && count( $pholders ) > 0 ) ? 'AND table_name IN ( ' . implode( ',', $pholders ) . ' ) ' : NULL ).
			'AND table_name != ? '.
			'AND table_schema = database() ',
			$values
		);

		// debug
	#	echo "tabelle collegate". PHP_EOL;
	#	print_r( $ks );

	#	echo "per ogni relazione... ". PHP_EOL;
		// per ogni relazione
		foreach( $ks as $ksr ) {

		#	echo "tabella " . $ksr['TABLE_NAME'] . PHP_EOL;

		#	echo "aggiungo il campo di relazione alle sostituzioni" . PHP_EOL;

			// aggiungo il campo di relazione alle sostituzioni
			$x['t'][$t]['t'][ $ksr['TABLE_NAME'] ]['f'][ $ksr['COLUMN_NAME'] ] = $id;

			if( isset( $x['t'][$t]['t'][ $ksr['TABLE_NAME'] ]['r'] ) ) {
				$whr = ' AND ' . implode( ' AND ', $x['t'][$t]['t'][ $ksr['TABLE_NAME'] ]['r'] );
				die( $whr );
			} else {
				$whr = NULL;
			}

		#	echo "valore attuale di x". PHP_EOL;
		#	print_r($x);

			// compongo la query di ricerca relazioni
			$q = 'SELECT * FROM ' . $ksr['TABLE_NAME'] . ' WHERE ' . $ksr['COLUMN_NAME'] . ' = "' . $o . '" ' . $whr;

			// trovo le righe collegate
			$rls = mysqlQuery( $c, $q );

			// debug
		#	echo "query di ricerca relazioni" . PHP_EOL;
		#	 var_dump( $q );

		#	 echo "righe collegate" . PHP_EOL;
		#	 print_r( $rls );

		#	 echo "per ogni riga di relazione... ". PHP_EOL;
			// per ogni riga della relazione
			foreach( $rls as $rl ) {

			#	echo "stampo la riga di relazione". PHP_EOL;
				// debug
			#	 print_r( $rl );

			#	 echo "chiamo mysqlDuplicateRowRecursive". PHP_EOL;
				// chiamo mysqlDuplicateRowRecursive() per ogni tabella collegata
				mysqlDuplicateRowRecursive( $c, $ksr['TABLE_NAME'], $rl['id'], NULL, $x['t'][ $t ], $y[ $ksr['TABLE_NAME'] ] );

			}

		}

	}

    /**
     * 
     * @todo documentare
     * $c	connessione
     * $t	nome tabella
     * $o	id del record da duplicare
     * $n	id del record nuovo duplicato (settare NULL per autoincrement)
     * $x	array delle trasformazioni (contiene in chiave i nomi delle colonne da modificare e in valore il valore da aggiornare)
     *
	 * TODO: creare un meccanismo di sostituzione intelligente dei valori dei campi (oltre al settaggio manuale)
     */
    function mysqlDuplicateRow( $c, $t, $o, $n = NULL, $x = array(), &$y = array() ) {

		// salvo l'id
		$id = isset( $x['id'] ) ? $x['id'] : null;

	// campi da modificare
	    $x = array_merge( array( 'id' => $n ), $x );

	// debug
		// print_r( $x );

	// campi della tabella
	    $fields = mysqlSelectColumn( 'COLUMN_NAME', $c, 'SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ?', array( array( 's' => $t ) ) );
	    $fieldsChanged = array_keys( $x );
	    $fieldsCopied = array_diff( $fields, $fieldsChanged );
	    $fieldsInsert = array_merge( $fieldsChanged, $fieldsCopied );

	// valori da sostituire
	    $values = array();
	    foreach( $x as $xv ) {
			$values[] = array( 's' => $xv );
	    }
	    $values[] = array( 's' => $o );

	// composizione della query
	    $q = 'INSERT IGNORE INTO ' . $t . ' (' . implode( ',', $fieldsInsert ) . ') SELECT ' . str_repeat( '?,', count( $fieldsChanged ) ) . implode( ',', $fieldsCopied ) . ' FROM ' . $t . ' WHERE id = ?';

	// esecuzione della query
		$n = mysqlQuery( $c, $q, $values );

		if( empty( $n ) ){
			$n = $id;
		}

	// popolo l'oggetto
		$y = mysqlSelectRow(
			$c, 'SELECT * FROM ' . $t . ' WHERE id = ?',
			array( array( 's' => $n ) )
		);

	// debug
		// echo $q . PHP_EOL;
		// print_r( $values );
		// var_dump( $n );
	    // print_r( $fields );

	// ritorno l'id nel nuovo record inserito
	    return $n;

    }

    /**
     *
     * @todo documentare
	 * 
	 * la funzione effettua l'eliminazione ricorsiva di un oggetto e, a cascata, di tutti gli oggetti collegati da vincoli di chiave "NO ACTION".
	 * riceve in ingresso i parametri seguenti:
	 * - $m: connessione a memcache
	 * - $c: connessione al database
	 * - $t: nome della tabella
	 * - $d: id del record da eliminare
	 * 
	 * NOTA: poiché la funzione utilizza memcache, se si apportano modifiche alle tipologia dei vincoli di chiave tra le tabelle del database, svuotare sempre memcache
     *
     */
	function mysqlDeleteRowRecursive( $m, $c, $t, $d ) {

		// debug
	#	echo 'chiamata funzione cancellazione ricorsiva' . PHP_EOL;
	#	echo "richiesta la cancellazione della riga #${d} dalla tabella {$t}" . PHP_EOL;

		// cerco i vincoli di chiave esterna per l'entità $t
		// NOTA mi interessano TABLE_NAME, COLUMN_NAME, REFERENCED_COLUMN_NAME
		$x = mysqlCachedQuery(
			$m,
			$c,
			'SELECT information_schema.key_column_usage.TABLE_NAME, information_schema.key_column_usage.COLUMN_NAME, information_schema.key_column_usage.REFERENCED_COLUMN_NAME, information_schema.key_column_usage.REFERENCED_TABLE_NAME, '.
			'information_schema.referential_constraints.DELETE_RULE '.
			'FROM information_schema.key_column_usage '.
			'INNER JOIN information_schema.referential_constraints ON ( information_schema.referential_constraints.REFERENCED_TABLE_NAME = information_schema.key_column_usage.REFERENCED_TABLE_NAME '.
			'AND information_schema.referential_constraints.TABLE_NAME = information_schema.key_column_usage.TABLE_NAME ) '.
			'WHERE information_schema.key_column_usage.REFERENCED_TABLE_NAME = ? AND table_schema = database() AND information_schema.referential_constraints.DELETE_RULE = ? ',
			array(
				array( 's' => $t ),
				array( 's' => 'NO ACTION' )
			)
		);

		// dati prelevati
		foreach( $x as $x1 ) {

			// debug
		#	print_r( $x1 );

			// variabili in uso
			$t1 = $x1['TABLE_NAME'];
			$f1 = $x1['COLUMN_NAME'];
			$l1 = $x1['REFERENCED_COLUMN_NAME'];

			// debug
		#	echo "SELECT * FROM ${t1} WHERE ${t1}.${f1} = ?" . PHP_EOL;
		#	echo "cerco le righe di ${t1} che hanno ${t1}.${f1} uguale a ${d}" . PHP_EOL;

			// prelevo le righe referenziate
			$r = mysqlQuery(
				$c,
				"SELECT * FROM ${t1} WHERE ${t1}.${f1} = ?",
				array(
					array( 's' => $d )
				)
			);

			// debug
		#	print_r( $r );

			// per ogni riga delle tabelle referenziate chiamo ricorsivamente
			foreach( $r as $r1 ) {

				// chiamata ricorsiva
				mysqlDeleteRowRecursive( $m, $c, $t1, $r1[ $l1 ] );

			}

		}

		// debug
		# echo "elimino la riga #${d} dalla tabella {$t}" . PHP_EOL;

		// cancello l'oggetto richiesto
		$r = mysqlQuery(
			$c,
			"DELETE FROM ${t} WHERE ${t}.id = ?",
			array(
				array( 's' => $d )
			)
		);

	}

    /**
     *
     * @todo documentare
     *
     */
    function mysqlInsertRow( $c, $r, $t, $d = true, $n = false, $u = array() ) {

		if( ! empty( $u ) ) {

			$uQuery = 'SELECT id FROM ' . $t . ' WHERE ';

			foreach( $u as $uFld ) {
				$uConds[] = ' ' . $uFld . ( ( ! isset( $r[ $uFld ] ) || empty( $r[ $uFld ] ) ) ? ' IS NULL' : ' = "' . $r[ $uFld ] . '" ' );
			}

			// TODO migliorare questa query con i parametri posizionali
			$r['id'] = mysqlSelectValue( $c, $uQuery . implode( ' AND ', $uConds ) );

			// debug
			// var_dump( $uQuery );
			// var_dump( $r['id'] );

		}

		if( ! array_key_exists( 'id', $r ) && $n == false ) {
			$r['id'] = NULL;
		}

		$r = array_map( 'empty2null', $r );
		$r = array_map( 'string2num', $r );

		$i = mysqlQuery( $c,
			'INSERT ' . ( ( $d === true ) ? NULL : 'IGNORE' ) . ' INTO ' . $t . ' ( ' . array2mysqlFieldnames( $r ) . ' ) '
			.'VALUES ( ' . array2mysqlPlaceholders( $r ) . ' ) '
			.( ( $d === true ) ? 'ON DUPLICATE KEY UPDATE ' . array2mysqlDuplicateKeyUpdateValues( $r ) : NULL ),
			array2mysqlStatementParameters( $r )
		);

		// var_dump( $t . '/' . $i );

		memcacheCleanFromIndex( $t );
		memcacheCleanFromIndex( $t . '_static' );

		$static = getStaticView( NULL, $c, $t );

		if( ! empty( $static ) ) {

            mysqlQuery( $c, 'REPLACE INTO ' . $static . ' SELECT * FROM ' . $t . '_view WHERE id = ?', array( array( 's' => $i ) ) );
			// logWrite( 'aggiornata view statica ' . $t . ' per id #' . $d['id'], 'static' );
			logWrite( 'aggiornata view statica ' . $t . ' per id #' . $i, 'static' );

		}

		return $i;

    }

    /**
     *
     * @todo documentare
     *
     */
    function array2mysqlFieldnames( $a ) {

		return implode( ', ', addStr2arrayElements( array_keys( $a ), '`', '`' ) );

    }

    /**
     *
     * @todo documentare
     *
     */
    function array2mysqlPlaceholders( $a ) {

	return implode( ', ', array_fill( 0, count( $a ), '?' ) );

    }

    /**
     *
     * @todo documentare
     *
     */
    function array2mysqlDuplicateKeyUpdateValues( $a ) {

	$r = array();

	foreach( array_keys( $a ) as $k ) {

//	    $r[] = '`' . $k . '` = ' . ( ( $k == 'id' ) ? 'LAST_INSERT_ID' : 'VALUES' ) . '( `' . $k . '` )';
		$r[] = '`' . $k . '` = ' . ( ( $k == 'id' && empty( $a[ $k ] ) ) ? 'LAST_INSERT_ID' : 'VALUES' ) . '( `' . $k . '` )';

	}

	return implode( ', ', $r );

    }

    /**
     *
     * @todo documentare
     *
     */
    function array2mysqlStatementParameters( $a ) {

	$r = array();

	// OK foreach( $a as $v ) {
	foreach( $a as $k => $v ) {

		if( is_numeric( $v ) ) {
			$v = str_replace( ',', '.', $v );
		}

	    // OK $r[] = array( 's' => $v );
	    $r[ $k ] = array( 's' => $v );

	}

	return $r;

    }

	function split_sql($sql_text) {
		// Return array of ; terminated SQL statements in $sql_text.
		$re_split_sql = '%(?#!php/x re_split_sql Rev:20170816_0600)
			# Match an SQL record ending with ";"
			\s*                                     # Discard leading whitespace.
			(                                       # $1: Trimmed non-empty SQL record.
			  (?:                                   # Group for content alternatives.
				\'[^\'\\\\]*(?:\\\\.[^\'\\\\]*)*\'  # Either a single quoted string,
			  | "[^"\\\\]*(?:\\\\.[^"\\\\]*)*"      # or a double quoted string,
			  | /\*[^*]*\*+(?:[^*/][^*]*\*+)*/      # or a multi-line comment,
			  | \#.*                                # or a # single line comment,
			  | --.*                                # or a -- single line comment,
			  | [^"\';#]                            # or one non-["\';#-]
			  )+                                    # One or more content alternatives
			  (?:;|$)                               # Record end is a ; or string end.
			)                                       # End $1: Trimmed SQL record.
			%x';  // End $re_split_sql.
		if (preg_match_all($re_split_sql, $sql_text, $matches)) {
			return $matches[1];
		}
		return array();
	}

	function getStaticView( $m, $c, $t ) {

		// verifico se esiste la view statica
			$stv = mysqlSelectCachedValue(
				$m,
				$c,
				'SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = ?',
				array( array('s' => $t . '_view_static' ) )
			);

		// se esiste la vista statica...
			if( ! empty( $stv ) ) {
				return $t . '_view_static';
			} else {
				return false;
			}

	}

	function getStaticViewExtension( $m, $c, $t ) {

		// verifico se esiste la view statica
			$stv = mysqlSelectCachedValue(
				$m,
				$c,
				'SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = ?',
				array( array('s' => $t . '_view_static' ) )
			);

		// se esiste la vista statica...
			if( ! empty( $stv ) ) {
				return '_view_static';
			} else {
				return '_view';
			}

	}
