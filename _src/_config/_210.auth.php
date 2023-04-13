<?php

    /**
     * questo file gestisce il login
     *
     * meccanismo di login
     * ===================
     * L'autenticazione nella piattaforma può avvenire in diversi modi, e nuove
     * modalità possono essere aggiunte nei file custom; quelle principali sono:
     *
     * - autenticazione HTTP
     * - invio dati tramite $_REQUEST
     *
     * In caso di autenticazione HTTP i dati di login vengono intercettati e
     * trasferiti nell'array $_REQUEST in modo da sfruttare il meccanismo di login
     * standard. L'autenticazione tramite $_REQUEST prevede l'invio di un blocco
     * dati costituito da un array multidimensionale con la seguente struttura:
     *
     * chiave           | dettagli
     * -----------------|-----------------------------------------------------------------------
     * __login__        | la chiave di primo livello che identifica il blocco dati di login
     * __login__.user   | il nome utente per il login
     * __login__.pasw   | la password per il login
     *
     * Realizzare un blocco dati del genere è abbastanza semplice, un form di login minimale
     * potrebbe essere, ad esempio:
     *
     * \code{.html}
     * <form method="post">
     *   <input type="text" name="__login__[user]">
     *   <input type="password" name="__login__[pasw]">
     *   <input type="submit">
     * </form>
     * \endcode
     *
     * L'uso del doppio underscore nel framework indica in generale oggetti che non devono
     * seguire un iter standard, quindi per esempio in questo caso viene usato per indicare
     * che il blocco dati è un blocco di controllo e non un blocco riguardante un'entità.
     *
     * Se si utilizza il framework per esporre dei webservice REST, e in generale accedendo alle
     * API del framework, è possibile effettuare l'autenticazione anche tramite HTTP o JSON.
     *
     * Volendo, anche se è sconsigliabile per ovvi motivi di sicurezza, si può effettuare in
     * teoria il login anche tramite parametri GET aggiunti all'URL:
     *
     * http://glisweb.example.bho?__login__[user]=bogus&__login__[pasw]=bogus
     *
     * effetti del login
     * -----------------
     *
     *
     *
     *
     *
     * password di default
     * -------------------
     *
     *
     *
     *
     * $cf['auth']['status']
     * ---------------------
     *
     *
     *
     *
     *
     *
     *
     *
     * definizione di meccanismi custom per il login
     * =============================================
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

    // debug
	// print_r( $_SESSION );

    /*
     * @todo $cf['auth']['status'] potrebbe contenere anche l'informazione se c'è un utente loggato o se si sta navigando come guest?
     */

    // stato del login
	$cf['auth']['status'] = NULL;
	$cf['auth']['jwt']['pass'] = NULL;

    if( isset( $cf['auth']['jwt']['secret'] ) ) {
        $cf['auth']['jwt']['secret'] .= date( 'Y-m-d' );
    }

	// $cf['session']['jwt']['token'] = NULL;

	// intercetto eventuali richieste di autenticazione HTTP
	if( ! empty( $_SERVER['PHP_AUTH_USER'] ) && ! empty( $_SERVER['PHP_AUTH_PW'] ) ) {
	    $_REQUEST['__login__']['user'] = $_SERVER['PHP_AUTH_USER'];
	    $_REQUEST['__login__']['pasw'] = $_SERVER['PHP_AUTH_PW'];
	}

	// header della richiesta HTTP
	$httpHeaders = apache_request_headers();

	// debug
	// die( substr( $httpHeaders['Authorization'], 0, 7 ) );

	// intercetto l'header bearer autentication
	if( array_key_exists( 'Authorization', $httpHeaders ) ) {
		if( substr( $httpHeaders['Authorization'], 0, 6 ) == 'Bearer' ) {
			$_REQUEST['jwt'] = substr( $httpHeaders['Authorization'], 7 );
		}
	}

	// intercetto eventuali richieste di autenticazione tramite token JWT
	if( ! empty( $_REQUEST['jwt'] ) ) {
		if( isset( $cf['auth']['jwt']['secret'] ) ) {
			$jwt = jwt2array( $_REQUEST['jwt'], $cf['auth']['jwt']['secret'] );
			$_REQUEST['__login__']['user'] = $jwt['data']['user'];
			$cf['auth']['jwt']['pass'] = mysqlSelectValue(
				$cf['mysql']['connection'],
				'SELECT password FROM account WHERE username = ? AND id = ?',
				array(
					array( 's' => $jwt['data']['user'] ),
					array( 's' => $jwt['data']['id'] )
				)
			);
		}
	}

	// NOTA per login via JWT, mandare { "id": "<idAccount>", "user": "<username>" }
	// vedi _usr/_examples/_jwt/_jwt.write.01.php

    // intercetto eventuali tentativi di login in corso
	if( isset( $_REQUEST['__login__'] ) && is_array( $_REQUEST['__login__'] ) ) {

	    // log
		logWrite( 'tentativo di login in corso per ' . $_REQUEST['__login__']['user'], 'auth', LOG_INFO );

	    // verifico che sia stato inviato un modulo di login compilato
		if( isset( $_REQUEST['__login__']['user'] ) ) {

		    // ricalcolo la password
			if( isset( $_REQUEST['__login__']['pasw'] ) ) {
				$_REQUEST['__login__']['pasw'] = md5( $_REQUEST['__login__']['pasw'] );
			} elseif( isset( $cf['auth']['jwt']['pass'] ) ) {
				$_REQUEST['__login__']['pasw'] = $cf['auth']['jwt']['pass'];
			}

		    // login con gli utenti del framework
			if( in_array( $_REQUEST['__login__']['user'], array_keys( $cf['auth']['accounts'] ) ) ) {

			    // se la password combacia
				if( $cf['auth']['accounts'][ $_REQUEST['__login__']['user'] ]['password'] == $_REQUEST['__login__']['pasw'] ) {

				    // attribuzione dell'account
					$_SESSION['account'] = &$cf['auth']['accounts'][ $_REQUEST['__login__']['user'] ];

				    // attribuzione dei gruppi e dei privilegi di gruppo
					foreach( $_SESSION['account']['gruppi'] as $gr ) {
					    $_SESSION['groups'][ $gr ] = &$cf['auth']['groups'][ $gr ];
					    if( isset( $cf['auth']['groups'][ $gr ]['privilegi'] ) ) {
	  						foreach( $cf['auth']['groups'][ $gr ]['privilegi'] as $pr ) {
  								if( ! in_array( $pr, $_SESSION['account']['privilegi'] ) ) {
									  $_SESSION['account']['privilegi'][] = $pr;
								  }
							  }
					    }
					}
/*
				    // attribuzione dei privilegi utente
					foreach( $_SESSION['account']['privilegi'] as $pr ) {
					    $_SESSION['privilegi'][ $pr ] = &$cf['auth']['privileges'][ $pr ];
					}
*/
				    // debug
					// print_r( $_SESSION['account']['privilegi'] );

				    // status
					$cf['auth']['status'] = LOGIN_SUCCESS;

					// JWT per il login corrente
					// NOTA a cosa serve questo? quando viene usato $cf['auth']['jwt']['token']?
					if( ! empty( $cf['auth']['jwt']['secret'] ) ) {
						$cf['session']['jwt']['token'] = getJwt(
							array(
								'id' => $_SESSION['account']['id'],
								'user' => $_SESSION['account']['username']
							),
							$cf['auth']['jwt']['secret']
						);
					}

				    // log
					logWrite( 'login effettuato correttamente per ' . $_REQUEST['__login__']['user'], 'auth' );

				} else {

				    // status
					$cf['auth']['status'] = LOGIN_ERR_WRONG_PW;

				    // log
					logWrite( 'password errata per ' . $_REQUEST['__login__']['user'], 'auth', LOG_ERR );
					logWrite( 'mancata corrispondenza degli hash per ' . $_REQUEST['__login__']['user'] . ': ' . $cf['auth']['accounts'][ $_REQUEST['__login__']['user'] ]['password'] . '/' . $_REQUEST['__login__']['pasw'], 'auth' );

				}

			} else {

			    // status
				$cf['auth']['status'] = LOGIN_ERR_NO_USER;

			    // log
				logWrite( $_REQUEST['__login__']['user'] . ' non presente nei file di configurazione', 'auth', LOG_INFO );

			}

		    // speed
			timerCheck( $cf['speed'], '-> fine login via framework' );

		    // debug
			// echo 'status: ' . $cf['auth']['status'] . '/' . LOGIN_SUCCESS . PHP_EOL;

		    // login su database MySQL
			if( $cf['auth']['status'] != LOGIN_SUCCESS ) {

			    // se è presente una connessione MySQL
				if( ! empty( $cf['mysql']['connection'] ) ) {

				    // log
					logWrite( 'fallback al login su database', 'auth' );

				    // query di login
					$r = mysqlSelectRow(
					    $cf['mysql']['connection'],
					    'SELECT * FROM account_view WHERE username = ? AND password = ?',
					    array(
							array( 's' => $_REQUEST['__login__']['user'] ),
							array( 's' => $_REQUEST['__login__']['pasw'] )
					    )
					);

				    // controllo il risultato
					if( count( $r ) && $r['se_attivo'] == true ) {

					    // verifica se si tratta del primo accesso e in tal caso valorizza il campo che andrà in $_SESSION['account']['first_access']
						if( is_null( $r['timestamp_login'] ) ) {
						    $r['first_access'] = true;
						} else {
						    $r['last_access'] = $r['timestamp_login'];
						}

					    // qui aggiornare la colonna timestamp_login dell'account connesso
						$login = mysqlQuery(
						    $cf['mysql']['connection'],
						    'UPDATE account SET timestamp_login = ? WHERE id = ? ',
						    array(
								array( 's' => time() ),
								array( 's' => $r['id'] )
						    )
						);

					    // attribuzione dell'account
						$_SESSION['account'] = $r;

					    // nella view questi dati sono in forma di stringa e invece servono come array
						string2array( $_SESSION['account']['gruppi'] );
						string2array( $_SESSION['account']['id_gruppi'] );
						string2array( $_SESSION['account']['categorie'] );
						string2array( $_SESSION['account']['id_categorie'] );

					    // inizializzo i permessi
						$_SESSION['account']['permissions'] = array();

					    // valorizzo i dati dei gruppi
						if( isset( $_SESSION['account']['id_gruppi'] ) && is_array( $_SESSION['account']['id_gruppi'] ) ) {
							foreach( $_SESSION['account']['id_gruppi'] as $g ) {
								$r = mysqlSelectCachedRow(
									$cf['memcache']['connection'],
									$cf['mysql']['connection'],
									'SELECT * FROM gruppi_view WHERE id = ?',
									array( array( 's' => $g ) )
								);
								if( count( $r ) > 0 ) {
									if( isset( $cf['auth']['groups'][ $r['nome'] ] ) ) {
										$cf['auth']['groups'][ $r['nome'] ] = array_replace_recursive( $r, $cf['auth']['groups'][ $r['nome'] ] );
									} else {
										$cf['auth']['groups'][ $r['nome'] ] = $r;
									}
									$_SESSION['groups'][ $r['nome'] ] = &$cf['auth']['groups'][ $r['nome'] ];
								}
							}
						} else {
							logWrite( 'attenzione, utente senza gruppi associati: ' . $_REQUEST['__login__']['user'], 'auth', LOG_ERR );
						}

					    // dati anagrafici
						$_SESSION['account'] = array_replace_recursive(
						    $_SESSION['account'],
						    mysqlSelectRow(
								$cf['mysql']['connection'],
								'SELECT se_collaboratore, se_cliente, se_fornitore, se_commerciale, se_amministrazione FROM anagrafica_view_static WHERE id = ?',
								array( array( 's' => $_SESSION['account']['id_anagrafica'] ) )
						    )
						);

					    // attribuzione dei gruppi e dei privilegi di gruppo
						if( isset( $_SESSION['groups'] ) && is_array( $_SESSION['groups'] ) ) {
						    foreach( $_SESSION['groups'] as $gr ) {
								  if( isset( $gr['nome'] ) ) {
							  		if( isset( $cf['auth']['groups'][ $gr['nome'] ]['privilegi'] ) ) {
						  				foreach( $cf['auth']['groups'][ $gr['nome'] ]['privilegi'] as $pr ) {
					  						if( ! isset( $_SESSION['account']['privilegi'] ) || ! in_array( $pr, $_SESSION['account']['privilegi'] ) ) {
				  								$_SESSION['account']['privilegi'][] = $pr;
			  								}
		  								}
	  								}
  								}
						    }
						} else {
							logWrite( 'attenzione, utente senza gruppi associati: ' . $_REQUEST['__login__']['user'], 'auth', LOG_ERR );
						}

/*
					    // attribuzione dei privilegi utente
						if( isset( $_SESSION['account']['privilegi'] ) ) {
							foreach( $_SESSION['account']['privilegi'] as $pr ) {
								$_SESSION['privilegi'][ $pr ] = &$cf['auth']['privileges'][ $pr ];
							}
						}
*/

						// gruppi di attribuzione automatica dell'utente
						if( ! empty( $_SESSION['account']['id_gruppi_attribuzione'] ) ) {
						    $aGroups = explode( '|', $_SESSION['account']['id_gruppi_attribuzione'] );
						    $_SESSION['account']['id_gruppi_attribuzione'] = array();
						    foreach( $aGroups as $aGroup ) {
								$aGrData = explode( '#', $aGroup );
								$_SESSION['account']['id_gruppi_attribuzione'][ $aGrData[0] ][] = $aGrData[1];
						    }
						}

					    // debug
						// print_r( $_SESSION );

					    // status
						$cf['auth']['status'] = LOGIN_SUCCESS;

						// JWT per il login corrente
						if( ! empty( $cf['auth']['jwt']['secret'] ) ) {
							$cf['session']['jwt']['token'] = getJwt(
								array(
									'id' => $_SESSION['account']['id'],
									'user' => $_SESSION['account']['username']
								),
								$cf['auth']['jwt']['secret']
							);
						}

					    // log
						logWrite( 'login effettuato correttamente via database per ' . $_REQUEST['__login__']['user'], 'auth', LOG_DEBUG );

					} elseif( count( $r ) && $r['se_attivo'] != true ) {

					    // status
						$cf['auth']['status'] = LOGIN_ERR_INACTIVE;

					    // log
						logWrite( 'UTENTE INATTIVO, impossibile effettuare il login via database per ' . $_REQUEST['__login__']['user'] . '/' . $_REQUEST['__login__']['pasw'], 'auth', LOG_INFO );

					} else {

					    // status
						$cf['auth']['status'] = LOGIN_ERR_WRONG_PW;

					    // log
						logWrite( 'impossibile effettuare il login via database per ' . $_REQUEST['__login__']['user'] . '/' . $_REQUEST['__login__']['pasw'], 'auth', LOG_ERR );

					}

				} else {

				    // status
					$cf['auth']['status'] = LOGIN_ERR_NO_CONNECTION;

				    // log
					logWrite( 'login sul database per ' . $_REQUEST['__login__']['user'] . ' impossibile per mancanza di connessione', 'auth', LOG_DEBUG );

				}

			}

		    // speed
			timerCheck( $cf['speed'], '-> fine login via database' );

		} else {

		    // status
			$cf['auth']['status'] = LOGIN_ERR_NO_DATA;

		    // log
			logWrite( 'dati di login insufficienti per ' . $_REQUEST['__login__']['user'], 'auth', LOG_DEBUG );

		}

	}

    // debug
	// print_r( $cf['localization']['language'] );
	// print_r( $_SESSION );
	// print_r( $cf['auth']['jwt'] );
	// print_r( $cf['session'] );
