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

    /**
     *
     *
     *
     * @todo documentare
     *
     */
#    function getAccessPermission( $p ) {
    function getPagePermission( $p ) {

	// namespace globale
	    global $cf;

	// se viene passato $cf['page'] anziché l'ID della pagina
	    if( is_array( $p ) ) { $p = $p['id']; }

	// pagina su cui lavorare
	    if( isset( $cf['contents']['pages'][ $p ] ) ) {

		// scorciatoia
		    $pag = $cf['contents']['pages'][ $p ];

		// controllo
		    if( ! isset( $pag['auth']['groups'] ) ) {

			// la pagina non ha restrizioni di accesso
			    return true;

		    } elseif( ! isset( $_SESSION['account']['gruppi'] ) ) {

			// l'utente non ha gruppi con cui richiedere l'accesso
			    return false;

		    } elseif( count( array_intersect( $pag['auth']['groups'], $_SESSION['account']['gruppi'] ) ) > 0 ) {

			// c'è un intersezione fra i gruppi dell'utente e quelli autorizzati a visualizzare la pagina
			    return true;

		    }

	    }

	// di default, ritorno false
	    return false;

    }

    /**
     *
     *
     *
     * @todo documentare
     *
     */
    function getAclPermission( $t, $a, &$i = NULL ) {

	// log
	    logWrite( 'richiesta di accesso per ' . $t . '/' . $a, 'auth' );

	// debug
	    // echo 'getAclPermission ' . $t . '/' . $a . PHP_EOL;

	// controllo permessi
	    if( isset( $_SESSION['account']['permissions'][ $t ] ) ) {

		// passaggio ricorsivo dei permessi
		    $i['__auth__'] = $_SESSION['account']['permissions'][ $t ];

		// stringa dei permessi ricorsivi
		    $auth = implode( ',',$i['__auth__'] );

		// autorizzazione
		    if( in_array( $a, $i['__auth__'] ) ) {

			// log
			    logWrite( 'accesso consentito per permessi espliciti ' . $t . '/' . $a . ' -> ' . $auth, 'auth' );

			// concessione del permesso
			    return true;

		    } elseif( in_array( CONTROL_FULL, $i['__auth__'] ) ) {

			// log
			    logWrite( 'accesso consentito per FULL CONTROL ' . $t . '/' . $a . ' -> ' . $auth, 'auth' );

			// concessione del permesso
			    return true;

		    } elseif( in_array( CONTROL_FILTERED, $i['__auth__'] ) ) {

			// log
			    logWrite( 'accesso consentito per FILTERED CONTROL ' . $t . '/' . $a . ' -> ' . $auth, 'auth' );

			// concessione del permesso
			    return true;

		    } else {

			// log
			    logWrite( 'accesso non consentito per ' . $t . '/' . $a . ' in ' . $auth, 'auth', LOG_INFO );

			// negazione del permesso
			    return false;

		    }

	    }

	// debug
	    // echo 'getAclPermission ' . $t . '/' . $a . ' NO' . PHP_EOL;

	// log
	    logWrite( 'permessi non settati in SESSION per ' . $t, 'auth', LOG_INFO );

	// default
	    return false;

    }

    /**
     *
     *
     *
     * @todo documentare
     *
     */
//    function getAclRights( $c, $t, $a, $id, &$i = NULL, $pi = NULL ) {
    function getAclRights( $c, $t, $a, $id, &$i = NULL ) {

	// log
	    logWrite( 'richiesta di accesso per ' . $t . '/' . $id . '/' . $a, 'auth' );

	// passaggio ricorsivo dei permessi
	    $i['__auth__'] = $_SESSION['account']['permissions'][ $t ];

	// debug
	    // echo 'getAclRights ' . $t . '/' . $id . '/' . $a . PHP_EOL;
	    // echo 'getAclRights parent id -> ' . $p . PHP_EOL;
	    // print_r( $i );
	    // print_r( $pi );

	// verifico se l'utente non è root
//	    if( $_SESSION['account']['username'] == 'root' || in_array( 'roots', $_SESSION['account']['gruppi'] ) ) {
//	    if( getAclPermission( $t, CONTROL_FULL ) ) {
	    if( in_array( CONTROL_FULL, $i['__auth__'] ) ) {

		// log
		    logWrite( 'accesso FULL per ' . $t . '/' . $id . '/' . $a, 'auth' );

		// debug
		    // echo 'getAclRights ' . $t . '/' . $id . '/' . $a . ' FULL OK' . PHP_EOL;

		// default
		    return true;

	    } else {

		// prelevo la tabella delle ACL
		    $aclTb = getAclRightsTable( $c, $t );

		// prelevo l'utente per il controllo ACL
		    $aclId = getAclRightsAccountId();

		// log
		    logWrite( 'accesso FULL non consentito per ' . $t . '/' . $id . '/' . $a . ', procedo...', 'auth' );

		// debug
		    // echo 'tabella: ' . $aclTb . PHP_EOL;
		    // echo 'id account: ' . $aclId . PHP_EOL;

		// se esistono ACL per questa entità
		    if( empty( $aclTb ) ) {

			// debug
			    // echo 'getAclRights ' . $t . '/' . $id . '/' . $a . ' ACL table non esiste' . PHP_EOL;

			// log
			    logWrite( 'nessuna tabella di ACL presente per ' . $t . ', autorizzazione concessa', 'auth' );

			// default
			    return true;

		    } else {

			// log
			    logWrite( 'tabella di ACL presente per ' . $t . ', procedo...', 'auth' );

			// debug
			    // echo 'getAclRights ' . $t . '/' . $id . '/' . $a . ' ACL table esiste' . PHP_EOL;

/*
			// valuto la riga
			    $r = mysqlSelectValue(
				$c,
				"SELECT concat_ws( ',', group_concat( ${aclTb}.permesso SEPARATOR ',' ), if( ${t}_view.id_account_inserimento = ?, 'FULL', NULL ) ) AS t ".
				"FROM ${t}_view ".
				"LEFT JOIN ${aclTb} ON ${aclTb}.id_entita = ${t}_view.id ".
				"LEFT JOIN account_gruppi ON account_gruppi.id_gruppo = ${aclTb}.id_gruppo ".
				"WHERE ( account_gruppi.id_account = ? OR ${t}_view.id_account_inserimento = ? ) ".
				"AND ${t}_view.id = ? ",
				array( array( 's' => $aclId ), array( 's' => $aclId ), array( 's' => $aclId ), array( 's' => $id ) )
			    );
*/
/*
			// genero l'array dei diritti
//			    if( getAclPermission( $t, CONTROL_FILTERED ) ) {
			    if( in_array( CONTROL_FILTERED, $i['__auth__'] ) ) {
				logWrite( 'accesso FILTERED per ' . $t . '/' . $id . '/' . $a, 'auth', LOG_NOTICE );
				// echo 'getAclRights ' . $t . '/' . $id . '/' . $a . ' accesso FILTRATO' . PHP_EOL;
				$y = ( ! empty( $pi ) ) ? 'GET' : NULL;
				$r = mysqlSelectValue(
				    $c,
//				    "SELECT if( ${t}_view.id_account_inserimento = ?, 'FULL', '${y}' ) AS t ".
				    "SELECT if( ${t}_view.id_account_inserimento = ?, 'FULL', NULL ) AS t ".
				    "FROM ${t}_view ".
				    "WHERE ${t}_view.id = ? ",
				    array( array( 's' => $aclId ), array( 's' => $id ) )
				);
			    } else {
				logWrite( 'accesso STANDARD per ' . $t . '/' . $id . '/' . $a, 'auth', LOG_NOTICE );
				// echo 'getAclRights ' . $t . '/' . $id . '/' . $a . ' accesso STANDARD' . PHP_EOL;
				$r = mysqlSelectValue(
				    $c,
				    "SELECT concat_ws( ',', group_concat( ${aclTb}.permesso SEPARATOR ',' ), if( ${t}_view.id_account_inserimento = ?, 'FULL', NULL ) ) AS t ".
				    "FROM ${t}_view ".
				    "LEFT JOIN ${aclTb} ON ${aclTb}.id_entita = ${t}_view.id ".
				    "LEFT JOIN account_gruppi ON account_gruppi.id_gruppo = ${aclTb}.id_gruppo ".
				    "WHERE ( account_gruppi.id_account = ? OR ${t}_view.id_account_inserimento = ? ) ".
				    "AND ${t}_view.id = ? ",
				    array( array( 's' => $aclId ), array( 's' => $aclId ), array( 's' => $aclId ), array( 's' => $id ) )
				);
			    }
*/

			// valuto la riga
				$r = mysqlSelectValue(
				    $c,
# NON CONSIDERA EDITOR
//					"SELECT concat_ws( ',', group_concat( ${aclTb}.permesso SEPARATOR ',' ), if( ( ${t}_view.id_account_inserimento = ? ), 'FULL', NULL ) ) AS t ".
					"SELECT concat_ws( ',', group_concat( ${aclTb}.permesso SEPARATOR ',' ), if( ( ${t}.id_account_inserimento = ? ), 'FULL', NULL ) ) AS t ".

# CONSIDERA EDITOR				    "SELECT concat_ws( ',', group_concat( ${aclTb}.permesso SEPARATOR ',' ), if( ( ${t}_view.id_account_inserimento = ? OR ${t}_view.id_account_editor = ? ), 'FULL', NULL ) ) AS t ".
//				    "FROM ${t}_view ".
					"FROM ${t} ".
//					"LEFT JOIN ${aclTb} ON ${aclTb}.id_entita = ${t}_view.id ".
					"LEFT JOIN ${aclTb} ON ${aclTb}.id_entita = ${t}.id ".
# NON GERARCHICO		    "LEFT JOIN account_gruppi ON account_gruppi.id_gruppo = ${aclTb}.id_gruppo ".
				    "LEFT JOIN account_gruppi ON ( account_gruppi.id_gruppo = ${aclTb}.id_gruppo OR gruppi_path_check( ${aclTb}.id_gruppo, account_gruppi.id_gruppo ) OR ${aclTb}.id_account = ? ) ".
# NON CONSIDERA EDITOR
//		    "WHERE ( account_gruppi.id_account = ? OR ${t}_view.id_account_inserimento = ? ) ".
			"WHERE ( account_gruppi.id_account = ? OR ${t}.id_account_inserimento = ? ) ".
# CONSIDERA EDITOR				    "WHERE ( account_gruppi.id_account = ? OR ${t}_view.id_account_inserimento = ? OR ${t}_view.id_account_editor = ? ) ".
//				    "AND ${t}_view.id = ? ",
					"AND ${t}.id = ? ",
# NON CONSIDERA EDITOR
		    array( array( 's' => $aclId ), array( 's' => $aclId ), array( 's' => $aclId ), array( 's' => $aclId ), array( 's' => $id ) )
# CONSIDERA EDITOR				    array( array( 's' => $aclId ), array( 's' => $aclId ), array( 's' => $aclId ), array( 's' => $aclId ), array( 's' => $aclId ), array( 's' => $id ) )
				);


			// creo l'array delle autorizzazioni
			// @todo verificare cosa fa questa cosa esattamente
			    $i['__auth__'] = explode( ',', $r );

			// debug
			    // echo 'risultato: ' . $r . ' per ' . $a . PHP_EOL;
			    // echo $a . PHP_EOL;
			    // print_r( $i['__auth__'] );

			// controllo dei diritti
			    if( in_array( $a, $i['__auth__'] ) ) {

				// debug
				    // echo 'getAclRights ' . $t . '/' . $id . '/' . $a . ' OK' . PHP_EOL;

				// log
				    logWrite( 'diritti concessi per tabella di ACL su ' . $t . '/' . $id . '/' . $a, 'auth' );

				// concedo i diritti
				    return true;

			    } elseif( in_array( CONTROL_FULL, $i['__auth__'] ) ) {

				// log
				    logWrite( 'diritti concessi per FULL CONTROL su ' . $t . '/' . $id . '/' . $a, 'auth' );

				// concedo i diritti
				    return true;

			    } elseif( in_array( CONTROL_FILTERED, $i['__auth__'] ) ) {

				// log
				    logWrite( 'diritti concessi per FILTERED CONTROL su ' . $t . '/' . $id . '/' . $a, 'auth' );

				// concedo i diritti
				    return true;

			    } else {

				// log
				    logWrite( 'diritti negati su ' . $t . '/' . $id . '/' . $a . ' in (' . $r . ')', 'auth' );

				// nego i diritti
				    return false;

			    }

/*
			// valuto la riga
			    $r = mysqlSelectValue(
				$cf['mysql']['connection'],
				"SELECT count( ${t}_view.id ) FROM ${t}_view ".
				"LEFT JOIN ${aclTb} ON ${aclTb}.id_entita = ${t}_view.id ".
				"LEFT JOIN account_gruppi ON account_gruppi.id_gruppo = ${aclTb}.id_gruppo ".
				"WHERE ( account_gruppi.id_account = ? OR ${t}_view.id_account_inserimento = ? ) ".
				"AND ${t}_view.id = ? ",
				array( array( 's' => $aclId ), array( 's' => $aclId ), array( 's' => $id ) )
			    );

			// debug
			    // echo 'risultato ' . $r . PHP_EOL;

			// risultato
			    return $r;
*/
		    }

	    }

	// debug
	    // echo 'getAclRights ' . $t . '/' . $id . '/' . $a . ' NO' . PHP_EOL;

	// default
	    return false;

    }

    /**
     *
     *
     *
     * @todo documentare
     *
     */
    function getAclRightsAccountId() {
	return ( isset( $_SESSION['account']['id'] ) ) ? $_SESSION['account']['id'] : false;
    }

    /**
     *
     *
     *
     * @todo documentare
     *
     */
    function getAclRightsTable( $c, $t ) {

	// verifico se l'utente non è root
	    if( $_SESSION['account']['username'] == 'root' || in_array( 'roots', $_SESSION['account']['gruppi'] ) ) {

			// log
			logWrite( 'accesso root concesso a ' . $_SESSION['account']['username'] . ' (' . implode(',',$_SESSION['account']['gruppi']) . ') per ' . $t, 'auth' );

			// default
			return NULL;

		} elseif( in_array( CONTROL_FULL, $_SESSION['account']['permissions'][ $t ] ) ) {

			// log
			logWrite( 'accesso FULL concesso a ' . $_SESSION['account']['username'] . ' (' . implode(',',$_SESSION['account']['gruppi']) . ') per ' . $t, 'auth' );

			// default
			return NULL;
			
		} else {

		// verifico se esiste la tabella $t_gruppi
#		    $r = mysqlSelectCachedValue(
		    $r = mysqlSelectValue(
			$c,
			"SELECT table_name FROM information_schema.tables WHERE table_name = '__acl_${t}__' AND table_schema = database()"
		    );

		// log
		    logWrite( $_SESSION['account']['username'] . ' (' . implode(',',$_SESSION['account']['gruppi']) . ') tabella di ACL ' . $r . ' trovata per ' . $t, 'auth' );

		// risultato
		    return $r;

	    }

	// log
	    logWrite( 'accesso non filtrato concesso a ' . $_SESSION['account']['username'] . ' (' . implode(',',$_SESSION['account']['gruppi']) . ') per ' . $t, 'auth' );

	// default
	    return NULL;

    }
