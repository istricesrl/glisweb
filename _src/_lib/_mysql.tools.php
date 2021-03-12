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
     * @todo documentare
     *
     */
    function mysqlGetQueryTables( $q ) {

	$r = array();

	if( preg_match_all( '/((FROM|JOIN) ([a-z_]+))/', $q, $m ) ) {
	    $r = array_unique( $m[3] );
	    array_walk( $r, function( &$v, $k ) { $v = str_replace( '_view', NULL, $v ); } );
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
	    if( empty( $r ) || $t === false ) {
		$r = mysqlQuery( $c, $q, $p, $e );
		memcacheWrite( $m, $k, $r, $t );
		logWrite( 'query ' . $k . ' non presente in cache', 'speed' );
		foreach( mysqlGetQueryTables( $q ) as $j ) {
		    $i[ $j ]['query'][ memcacheUniqueKey( $k ) ] = time();
		}
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
		    $tElapsed = timerDiff( $tStart );

		// log
		    if( $tElapsed > 0.5 ) { logWrite( $q . ' -> TEMPO ' . $tElapsed . ' secondi', 'speed', LOG_ERR ); }

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
				    }

				// bind dei parametri
				    call_user_func_array( 'mysqli_stmt_bind_param', $aParams );

			    }

			// esecuzione dello statement
			    $xStatement = mysqli_stmt_execute( $pq );

			// cronometro
			    $tElapsed = timerDiff( $tStart );

			// log
			    if( $tElapsed > 0.5 ) {
				logWrite( $q . ' -> TEMPO ' . $tElapsed . ' secondi', 'speed', LOG_ERR );
				appendToFile( $tElapsed . ' secondi -> ' . $q . PHP_EOL, '/var/log/slow/mysql/' . date( 'YmdH' ) . '.log' );
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
     *
     * @todo documentare
     *
     */
    function mysqlDuplicateRowRecursive( $c, $t, $o, $n = NULL, &$x = array() ) {

		// debug
		// print_r( $x[ $t ] );

		// se non ho un ID di partenza
		if( empty( $o ) ) {
			die( 'ID da duplicare non passato' );
		}

		// duplico la riga
		$id = mysqlDuplicateRow( $c, $t, $o, $n, $x[ $t ] );

		// debug
		// echo 'ID riga duplicata = ' . $id . PHP_EOL;

		// creo i placeholder per le tabelle richieste
		$pholders = array();
		$values = array( array( 's' => $t ) );
		foreach( array_keys( $x ) as $rt ) {
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
		// print_r( $ks );

		// per ogni relazione
		foreach( $ks as $ksr ) {

			// aggiungo il campo di relazione alle sostituzioni
			$x[ $ksr['TABLE_NAME'] ][ $ksr['COLUMN_NAME'] ] = $id;

			// compongo la query di ricerca relazioni
			$q = 'SELECT * FROM ' . $ksr['TABLE_NAME'] . ' WHERE ' . $ksr['COLUMN_NAME'] . ' = "' . $o . '"';

			// trovo le righe collegate
			$rls = mysqlQuery( $c, $q );

			// debug
			// var_dump( $q );
			// print_r( $rls );

			// per ogni riga della relazione
			foreach( $rls as $rl ) {

				// debug
				// print_r( $rl );

				// chiamo mysqlDuplicateRowRecursive() per ogni tabella collegata
				mysqlDuplicateRowRecursive( $c, $ksr['TABLE_NAME'], $rl['id'], NULL, $x );

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
     */
    function mysqlDuplicateRow( $c, $t, $o, $n = NULL, $x = array() ) {

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
	    $q = 'INSERT INTO ' . $t . ' (' . implode( ',', $fieldsInsert ) . ') SELECT ' . str_repeat( '?,', count( $fieldsChanged ) ) . implode( ',', $fieldsCopied ) . ' FROM ' . $t . ' WHERE id = ?';

	// esecuzione della query
		$n = mysqlQuery( $c, $q, $values );

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
     */
    function mysqlInsertRow( $c, $r, $t, $d = true ) {

	return mysqlQuery( $c,
	    'INSERT INTO ' . $t . ' ( ' . array2mysqlFieldnames( $r ) . ' ) '
	    .'VALUES ( ' . array2mysqlPlaceholders( $r ) . ' ) '
	    .( ( $d === true ) ? 'ON DUPLICATE KEY UPDATE ' . array2mysqlDuplicateKeyUpdateValues( $r ) : NULL ),
	    array2mysqlStatementParameters( $r )
	);

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

	    $r[] = '`' . $k . '` = ' . ( ( $k == 'id' ) ? 'LAST_INSERT_ID' : 'VALUES' ) . '( `' . $k . '` )';

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

	foreach( $a as $v ) {

	    $r[] = array( 's' => $v );

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
