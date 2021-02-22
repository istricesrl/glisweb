<?php

    /**
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

    // costanti
	define( 'ROW_CREATED'			, 'INSERITO' );
	define( 'ROW_MODIFIED'			, 'MODIFICATO' );
	define( 'ROW_UNMODIFIED'		, 'INVARIATO' );

    /**
     *
     * @todo documentare
     *
     */
    function controller( $c, &$d, $t, $a = METHOD_GET, $p = NULL, &$e = array(), &$i = array(), &$pi = array(), &$ci = array() ) {

	// log
	    logWrite( "${t}/${a}", 'controller' );

	// inizializzazioni
	    $q					= NULL;				// la query MySQL che verrà eseguita
	    $s					= array();			// 
	    $r					= false;			// 
	    $ks					= array();			// 
	    $vs					= array();			// 
	    $vm					= false;			// 
		$rm					= '_view';			// 

	// inclusione dei controller
	    $cb					= DIR_SRC_INC_CONTROLLERS . '_{default,' . str_replace( '_', '.', $t ) . '}.';
	    $cm					= DIR_MOD_ATTIVI_SRC_INC_CONTROLLERS;

	// inizializzazione array dati
	    if( empty( $d ) ) { $d		= array(); }

	// debug
		// var_dump( $d );

	// modifico in NULL tutti i valori vuoti
	    $d = array_map( 'empty2null', $d );

	// genero l'array delle chiavi, dei valori e dei sottomoduli
	    foreach( $d as $k => $v ) {
		if( is_array( $v ) && substr( $k, 0, 2 ) !== '__' ) {		// nel caso il valore sia un subform, viene
		    $s[ $k ] = $v;						// passato così com'è per la ricorsione
		} elseif( strtolower( $k )	== '__method__' ) {		//
		    $a = strtoupper( $v );					// impostazione esplicita del method del form
		} elseif( strtolower( $k )	== '__table__' ) {		//
		    $t = $v;							// impostazione esplicita della tabella del form
		} elseif( strtolower( $k )	== '__reset__' ) {		//
		    $r = string2boolean( $v );					// richiesta esplicita di svuotare $_REQUEST[ $t ]
		} elseif( strtolower( $k )	== '__view_mode__' ) {		//
		    $vm = true;							//
		} elseif( strtolower( $k )	== '__report_mode__' ) {	//
		    $rm = NULL;							//
		} elseif( substr( $k, 0, 2 )	!== '__' ) {			//

		    if( strtolower( $v )	== '__null__' )		{ $v = NULL; }
		    if( strtolower( $v )	== '__parent_id__' )	{ $v = $p; }
		    if( strtolower( $v )	== '__self_id__' )	{ $v = ( isset( $d['id'] ) ) ? $d['id'] : NULL; }
		    if( strtolower( $v )	== '__timestamp__' )	{ $v = time(); }
		    if( strtolower( $v )	== '__date__' )		{ $v = date( 'Y-m-d' ); }

		    $vs[ $k ]			= array( 's' => $v );		// array dei valori per il bind dei parametri
		    $ks[]			= $k;				// array delle chiavi per la costruzione della query

		}
	    }

	// controllo permessi (il gruppo può eseguire l'azione sull'entità?) getAclPermission()
	    if( getAclPermission( $t, $a, $i ) ) {

		// se è stata effettuata una GET senza ID, passo alla modalità view
		    if( $a === METHOD_GET && ( ! array_key_exists( 'id', $d ) || $vm === true ) ) {

			// TODO verifico se esiste la view statica
				// ...
				// ... $rm = '_view_static';

			// log
			    logWrite( "permessi sufficienti per ${t}/${a}", 'controller', LOG_DEBUG );

			// debug
			    // print_r( $d );
			    // print_r( $i );

			// vado a cercare il campo e la tabella per le ACL
			    $aclTb = getAclRightsTable( $c, $t );
			    $aclId = getAclRightsAccountId();

			// campi da selezionare dalla vista
			    if( isset( $i['__fields__'] ) ) {
				$fld = implode( ', ', preg_filter( '/^/', "${t}$rm.", $i['__fields__'] ) );
			    } else {
				$fld = "${t}$rm.*";
			    }

			/*
			 * @todo testare __fields__ per eventuale SQL injection
			 */

			// preparo la query
			    $q = "SELECT SQL_CALC_FOUND_ROWS ${fld} FROM ${t}$rm";

			// inizializzo l'array per ricerca e filtri
			    $whr = array();

			// unisco la tabella di ACL se presente
			    if( ! empty( $aclTb ) ) {
				$q .= " LEFT JOIN $aclTb ON ${aclTb}.id_entita = ${t}$rm.id ";
				$q .= " LEFT JOIN account_gruppi ON ( account_gruppi.id_gruppo = ${aclTb}.id_gruppo OR gruppi_path_check( ${aclTb}.id_gruppo, account_gruppi.id_gruppo ) )";
				$whr[] = "( account_gruppi.id_account = ? OR ${t}$rm.id_account_inserimento = ? )";
				$vs[] = array( 's' => $aclId );
				$vs[] = array( 's' => $aclId );
				$i['__group__'] = array( $t . $rm . '.id' );
			    }

			// ricerca nella vista
			    if( isset( $i['__fields__'] ) && isset( $i['__search__'] ) && ! empty( $i['__search__'] ) ) {
				foreach( explode( ' ', $i['__search__'] ) as $tks ) {
				    $like = "%${tks}%";
				    $cond = array();
				    foreach( preg_filter( '/^/', "${t}$rm.", $i['__fields__'] ) as $field ) {
					$cond[] = $field . ' LIKE ?';
					$vs[] = array( 's' => $like );
				    }
				    $whr[] = '(' . implode( ' OR ', $cond ) . ')';
				}
			    }

			// filtri per i campi
			    foreach( $ks as $fk ) {
				$whr[] = "${fk} = ?";
			    }

			// debug
			    // print_r( $i['__filters__'] );

			/*
			 * @todo IMPORTANTE
			 * implementare filtri che implichino una JOIN con filtro sulla tabella di JOIN
			 * ad es. cercare sull'anagrafica quelli che hanno un'associazione con la categoria clienti
			 * sulla tabella anagrafica_categorie (adesso la cosa è gestita maldestramente con LK)
			 */

			// gestione locale dei filtri
			    if( isset( $i['__filters__'] ) && ! empty( $i['__filters__'] ) ) {
				$filters = $i['__filters__'];
			    } else {
				$filters = array();
			    }

			// restrizioni in atto
			    if( isset( $i['__restrict__'] ) && ! empty( $i['__restrict__'] ) ) {
				$filters = array_replace_recursive(
				    $filters, $i['__restrict__']
				);
			    }

			// filtri della vista
			    if( isset( $filters ) && ! empty( $filters ) ) {
				foreach( $filters as $fc => $sn ) {
				    foreach( $sn as $sk => $sv ) {
					if( (string) $sv != '' ) {
					    switch( $sk ) {
						case 'NN':
						    $whr[] = "${fc} IS NOT NULL";
						break;
						case 'NL':
						    $whr[] = "${fc} IS NULL";
						break;
						case 'EQ':
						    $whr[] = "${fc} = ?";
						    $vs[] = array( 's' => $sv );
						break;
						case 'GT':
						    $whr[] = "${fc} > ?";
						    $vs[] = array( 's' => $sv );
						break;
						case 'GE':
						    $whr[] = "${fc} >= ?";
						    $vs[] = array( 's' => $sv );
						break;
						case 'LT':
						    $whr[] = "${fc} < ?";
						    $vs[] = array( 's' => $sv );
						break;
						case 'LE':
						    $whr[] = "${fc} <= ?";
						    $vs[] = array( 's' => $sv );
						break;
						case 'LK':
						    $whr[] = "${fc} LIKE ?";
						    $vs[] = array( 's' => '%'.$sv.'%' );
						break;
					    }
					}
				    }
				}
			    }

			// aggiungo le clausole WHERE alla query
			    if( ! empty( $whr ) ) {
				$q .= ' WHERE ' . implode( ' AND ', $whr );
			    }

			// raggruppamenti della vista
			    if( isset( $i['__group__'] ) && array_filter( $i['__group__'] ) ) {
				$q .= ' GROUP BY ' . implode( ', ', $i['__group__'] );
			    }

			/*
			 * @todo testare __group__ per eventuale SQL injection
			 */

			// ordinamenti della vista
			    if( isset( $i['__sort__'] ) && array_filter( $i['__sort__'] ) ) {
				$q .= ' ORDER BY ' . arrayKeyValuesImplode( $i['__sort__'], ' ', ', ' );
			    }

			/*
			 * @todo testare __sort__ per eventuale SQL injection
			 */

			// paginazione della vista
			    if( isset( $i['__pager__']['page'] ) && isset( $i['__pager__']['rows'] ) ) {
				$q .= ' LIMIT ' . ( $i['__pager__']['page'] * $i['__pager__']['rows'] ) . ',' . $i['__pager__']['rows'];
			    }

			/*
			 * @todo testare __pager__ per eventuale SQL injection
			 */

			// debug
			    // print_r( $i );
			    //  echo $q . PHP_EOL;

			// eseguo la query
			    $d = mysqlQuery( $c, $q, $vs, $e['__codes__'] );

			// registro il numero totale di righe
			    $i['__pager__']['total'] = mysqlSelectValue( $c, 'SELECT found_rows() AS t' );
			    if( isset( $i['__pager__']['rows'] ) ) {
				$i['__pager__']['pages'] = ceil( $i['__pager__']['total'] / $i['__pager__']['rows'] );
			    }

			// debug
			    // echo $i['__pager__']['total'] . ' / ' . $i['__pager__']['rows'] . ' = ' . $i['__pager__']['pages'];
			    // echo $q;

			// log
			    logWrite( "eseguo (${a}) la query: ${q}", 'controller', LOG_DEBUG );

			// TODO il valore di ritorno dipende da eventuali errori
			    $i['__status__'] = 200;
			    return $i['__status__'];

		// controllo diritti
		    } elseif( ! isset( $d['id'] ) || getAclRights( $c, $t, $a, $d['id'], $i, $pi ) != false ) {

			// log
			    logWrite( "diritti sufficienti per ${t}/${a}", 'controller', LOG_DEBUG );

			// debug
			    // echo 'controller ' . $t . '/' . $a . ' OK' . PHP_EOL;

			// variabile per confronto prima/dopo
			    $before = NULL;

			// recupero dati per confronto prima/dopo
			    switch( strtoupper( $a ) ) {
				case METHOD_PUT:
				case METHOD_REPLACE:
				case METHOD_UPDATE:
				    $before = md5( serialize( mysqlSelectRow( $c, 'SELECT ' . implode( ',', array_diff( $ks, array( 'id_account_aggiornamento', 'timestamp_aggiornamento' ) ) ) . ' FROM ' . $t . ' WHERE id = ?', array( array( 's' => $d['id'] ) ) ) ) );
				break;
			    }

			// debug
			    // echo( print_r( mysqlSelectRow( $c, 'SELECT ' . implode( ',', array_diff( $ks, array( 'id_account_aggiornamento', 'timestamp_aggiornamento' ) ) ) . ' FROM ' . $t . ' WHERE id = ?', array( array( 's' => $d['id'] ) ) ), true ) ) . PHP_EOL;
			    // echo $before . PHP_EOL;

			// controller pre query (before)
			    $cn = 'before.php';
			    $ct = array_merge(
				glob( $cb . $cn, GLOB_BRACE ),
				glob( $cm . $cn, GLOB_BRACE ),
				glob( path2custom( $cb . $cn ), GLOB_BRACE ),
				glob( path2custom( $cm . $cn ), GLOB_BRACE )
			    );
			    foreach( $ct as $f ) { require $f; }

			// composizione della query in base all'azione richiesta
			    switch( strtoupper( $a ) ) {

				// inserimento di un nuovo record
				    case METHOD_POST:

					// compongo la query
					    $q = "INSERT INTO $t (" . implode( ',' , $ks ) . ") VALUES (" . implode( ',' , array_fill( 0, count( $ks ), '?' ) ) . ") ";

				    break;

				// modifica di un record già esistente
				    case METHOD_PUT:

					// compongo la query
					    $q = "UPDATE $t SET ";

					// compongo i campi della query
					    foreach( $ks as $k ) {
						$tks[] = "$k = ?";
					    }

					// compongo la condizione WHERE
					    $q .= implode( ', ' , $tks ) . " WHERE id = ?";

					// aggiungo l'id per la clausola WHERE
					    $vs[] = array( 's' => $d['id'] );

				    break;

				// rimpiazzo di un record già esistente
				    case METHOD_REPLACE:

					// compongo la query
					    $q = "REPLACE INTO $t (" . implode( ',' , $ks ) . ") VALUES (" . implode( ',' , array_fill( 0 , count( $ks ) , '?' ) ) . ") ";

				    break;

				// aggiornamento di un record già esistente con INSERT INTO ... ON DUPLICATE KEY UPDATE
				    case METHOD_UPDATE:

					// compongo la query
					    $q = "INSERT INTO $t (" . implode( ',' , $ks ) . ") VALUES (" . implode( ',' , array_fill( 0 , count( $ks ) , '?' ) ) . ") ";
					    foreach( $ks as $k ) { $vks[] = "$k=VALUES($k)"; }
					    $q .= "ON DUPLICATE KEY UPDATE " . ( ( ! in_array( 'id', $ks ) ) ? "id=LAST_INSERT_ID(id)," : NULL ) . implode( ',' , $vks );

				    break;

				// eliminazione di un record già esistente
				    case METHOD_DELETE:

					// compongo la query
					    $q = "DELETE FROM $t WHERE id = ?";

					// forzo il reset del form
					    $r = true;

				    break;

				// prelevamento di un record già esistente
				    case METHOD_GET:

					// compongo la query
					    $q = "SELECT * FROM ${t}";

					// compongo i campi della query
					    foreach( $ks as $k ) {
						$tks[] = "${k} = ?";
					    }

					// compongo la condizione WHERE
					    if( is_array( $tks ) && array_filter( $tks ) ) {
						$q .= " WHERE " . implode( ' AND ' , $tks );
					    }

				    break;

			    }

			// controller in query (append)
			    $cn = 'append.php';
			    $ct = array_merge(
				glob( $cb . $cn, GLOB_BRACE ),
				glob( $cm . $cn, GLOB_BRACE ),
				glob( path2custom( $cb . $cn ), GLOB_BRACE ),
				glob( path2custom( $cm . $cn ), GLOB_BRACE )
			    );
			    foreach( $ct as $f ) { require $f; }

			// esecuzione della query
			    switch( strtoupper( $a ) ) {

				// inserimento di un nuovo record
				    case METHOD_POST:

					// eseguo la query
					    $d['id'] = mysqlQuery( $c, $q, $vs, $e['__codes__'] );

				    break;

				// modifica o cancellazione di un oggetto esistente
				    case METHOD_PUT:
				    case METHOD_DELETE:

					// eseguo la query
					    mysqlQuery( $c, $q, $vs, $e['__codes__'] );

				    break;

				// rimpiazzo di un oggetto esistente
				    case METHOD_REPLACE:
				    case METHOD_UPDATE:

					// eseguo la query
					    $id = mysqlQuery( $c, $q, $vs, $e['__codes__'] );
					    $d['id'] = ( isset( $d['id'] ) && ! empty( $d['id'] ) ) ? $d['id'] : $id;

				    break;

				// prelevamento di un oggetto esistente
				    case METHOD_GET:

					// eseguo la query
					    $d = mysqlQuery( $c, $q, $vs, $e['__codes__'] );
					    if( is_array( $d ) ) {
						$d = array_shift( $d );
					    }

				    break;

			    }

			// log
			    logWrite( "eseguo ($a) la query: $q", 'controller', LOG_DEBUG );

			// debug
			    // echo 'controller ' . $t . '/' . $a . ' -> ' . $q . PHP_EOL;

			// di default imposto lo stato a 'OK'
			    $i['__status__'] = 200;

			// gestione degli errori
			    // @todo gestire gli errori
			    // print_r( $e['__codes__'] );
			    if( isset( $e['__codes__'] ) && array_key_exists( '1062', $e['__codes__'] ) ) {
				$i['__status__'] = 409;
				$i['__err__'] = $e['__codes__']['1062'][0];
			    }

			// variabile per confronto prima/dopo
			    $after = NULL;

			// recupero dati per confronto prima/dopo
			    switch( strtoupper( $a ) ) {
				case METHOD_POST:
				case METHOD_PUT:
				case METHOD_REPLACE:
				case METHOD_UPDATE:
				    $after = md5( serialize( mysqlSelectRow( $c, 'SELECT ' . implode( ',', array_diff( $ks, array( 'id_account_aggiornamento', 'timestamp_aggiornamento' ) ) ) . ' FROM ' . $t . ' WHERE id = ?', array( array( 's' => $d['id'] ) ) ) ) );
				break;
			    }

			// esito del controllo prima/dopo
			    $comparison = ( $before !== $after ) ? ( ( empty( $before ) ) ? ROW_CREATED : ROW_MODIFIED ) : ROW_UNMODIFIED;

			// debug
			    // echo( print_r( mysqlSelectRow( $c, 'SELECT ' . implode( ',', array_diff( $ks, array( 'id_account_aggiornamento', 'timestamp_aggiornamento' ) ) ) . ' FROM ' . $t . ' WHERE id = ?', array( array( 's' => $d['id'] ) ) ), true ) ) . PHP_EOL;
			    // echo $after . PHP_EOL;
			    // echo $comparison . PHP_EOL;

			// log
			    logWrite( "record $comparison per la query: ${q}", 'controller', LOG_DEBUG );

			// controller post query (after)
			    $cn = 'after.php';
			    $ct = array_merge(
				glob( $cb . $cn, GLOB_BRACE ),
				glob( $cm . $cn, GLOB_BRACE ),
				glob( path2custom( $cb . $cn ), GLOB_BRACE ),
				glob( path2custom( $cm . $cn ), GLOB_BRACE )
			    );
			    foreach( $ct as $f ) { require $f; }

			// reintegrazione dei sottomoduli
			    if( is_array( $d ) ) {
				$d = array_merge( $d, $s );
			    }

			/*
			 * @todo a cosa serve questa cosa qui sopra? inoltre, verificare come si comportano __info__, __err__, e __auth__ in scenari ricorsivi
			 */

			// elaborazione dei sottomoduli
			    switch( strtoupper( $a ) ) {
				case METHOD_POST:
				case METHOD_PUT:
				case METHOD_REPLACE:
				case METHOD_UPDATE:
				    foreach( $d as $k => $v ) {
					if( is_array( $v ) ) {
					    foreach( $v as $x => $y ) {
						controller( $c, $d[$k][$x], $k, $a, $d['id'], $e, $i[$k][$x], $i['__auth__'] );
					    }
					}
				    }
				break;
				case METHOD_GET:
#				default:
				    if( in_array( 'id', $ks ) ) {
					$x = mysqlQuery( $c, 'SELECT * FROM information_schema.key_column_usage WHERE referenced_table_name = ? AND constraint_name NOT LIKE "%_nofollow" AND table_schema = database()', array( array( 's' => $t ) ) );
#echo "cerco le referenze a $t" . PHP_EOL;
#print_r( $x );
					foreach( $x as $ref ) {
#print_r( $ref );
#if( ! is_array($d) ) {
#	var_dump($t);
#	var_dump($q);
#	var_dump($d);
#}
					    $idx = array_column( mysqlQuery( $c, 'SHOW INDEX FROM ' . $ref['TABLE_NAME'] . ' WHERE key_name = "SORTING"' ), 'Column_name' );
					    $q = "SELECT id FROM ".$ref['TABLE_NAME']." WHERE ".$ref['COLUMN_NAME']." = '".$d['id']."'" . ( ( count( $idx ) ) ? ' ORDER BY ' . implode( ', ', $idx ) : NULL );
					    $rows = mysqlQuery( $c, $q );
					    logWrite( "cerco le referenze a ".$ref['TABLE_NAME']." dove ".$ref['COLUMN_NAME']." è ".$d['id'].", ".count( $rows )." referenze trovate", 'controller', LOG_DEBUG );
					    $tStart = timerNow();
					    $ix = 0;
					    foreach( $rows as $row ) {
#echo $q . PHP_EOL;
#print_r( $row );
#echo $ref['TABLE_NAME'] . PHP_EOL;
#echo $i . PHP_EOL;
#var_dump( $d[ $ref['TABLE_NAME'] ] );
#var_dump( $d[ $ref['TABLE_NAME'] ][ $i ] );
#var_dump( $d[ $ref['TABLE_NAME'] ][ $i ]['id'] );
						if( ! empty( $row['id'] ) ) {
						    $d[ $ref['TABLE_NAME'] ][ $ix ]['id'] = $row['id'];
						    $e[ $ref['TABLE_NAME'] ][ $ix ] = array();
						    $i[ $ref['TABLE_NAME'] ][ $ix ] = array();
//						    controller( $c, $d[ $ref['TABLE_NAME'] ][ $ix ], $ref['TABLE_NAME'], $a, NULL, $r, $e[ $ref['TABLE_NAME'] ][ $ix ], $i[ $ref['TABLE_NAME'] ][ $ix ] );
						    controller( $c, $d[ $ref['TABLE_NAME'] ][ $ix ], $ref['TABLE_NAME'], $a, NULL, $e[ $ref['TABLE_NAME'] ][ $ix ], $i[ $ref['TABLE_NAME'] ][ $ix ], $i['__auth__'] );
						    $ix++;
						}
					    }
					    $tDone = timerDiff( $tStart );
					    if( count( $rows ) > 10 || $tDone > 1.5 ) {
						logWrite($ref['TABLE_NAME'].'.'.$ref['COLUMN_NAME'].' causa overload: '.$tDone.' secondi, '.count($rows).' righe', 'speed', LOG_ERR);
					    }
					}
				    }
				break;
			    }

			// controller post elaborazione (finally)
			    $cn = 'finally.php';
			    $ct = array_merge(
				glob( $cb . $cn, GLOB_BRACE ),
				glob( $cm . $cn, GLOB_BRACE ),
				glob( path2custom( $cb . $cn ), GLOB_BRACE ),
				glob( path2custom( $cm . $cn ), GLOB_BRACE )
			    );
			    foreach( $ct as $f ) { require $f; }

			// svuotamento o integrazione del blocco dati
			    if( $r ) {
				$_SESSION['__latest__'][ $t ] = $d;
				$d = array();
			    } else {
				switch( strtoupper( $a ) ) {
				    case METHOD_GET:
				    case METHOD_POST:
				    case METHOD_PUT:
				    case METHOD_REPLACE:
				    case METHOD_UPDATE:
					$w = mysqlSelectRow( $c, "SELECT * FROM ${t}$rm WHERE id = ?", array( array( 's' => $d['id'] ) ) );
					if( is_array( $w ) && is_array( $d ) ) { $d = array_merge( $w, $d ); }
				    break;
				}
			    }

			// TODO il valore di ritorno di questo ramo dipende dall'esito delle operazioni sopra
			    return $i['__status__'];

		    }

	    }

	// restituisco 401 unauthorized
	    $i['__status__'] = 401;
	    return $i['__status__'];

    }
