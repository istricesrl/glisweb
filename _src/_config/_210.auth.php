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
     * Se si utilizza reCAPTCHA, il form di login si complica leggermente in quanto è necessario
     * includere il codice che genera il token da restituire al backend per la verifica.
     * 
     * \code{.html}
     * <form method="post">
     *   <input type="hidden" name="__login__[__recaptcha_token__]">
     *   <input type="text" name="__login__[user]">
     *   <input type="password" name="__login__[pasw]">
     *   <input type="submit">
     * </form>
     * \endcode
     * 
     * TODO finire il codice di questo esempio e testarlo
     * 
     * Se si utilizza il framework per esporre dei webservice REST, e in generale accedendo alle
     * API del framework, è possibile effettuare l'autenticazione anche tramite HTTP o JSON.
     *
     * Volendo, anche se è sconsigliabile per ovvi motivi di sicurezza, si può effettuare in
     * teoria il login anche tramite parametri GET aggiunti all'URL:
     *
     * https://glisweb.example.bho?__login__[user]=bogus&__login__[pasw]=bogus
     * 
     * Si noti che questo metodo implica la trasmissione della password nell'URL, e quindi è 
     * ALTISSIMAMENTE sconsigliato in produzione per OVVIE ragioni.
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
     * meccanismi standard di login
     * ============================
     * 
     * 
     * header HTTP
     * -----------
     * 
     * 
     * 
     * bearer token
     * ------------
     * 
     * 
     * 
     * 
     * token JWT
     * ---------
     * 
     * NOTA per login via JWT, mandare { "id": "<idAccount>", "user": "<username>" }
     * vedi _usr/_examples/_jwt/_jwt.write.01.php
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
     * TODO documentare
     *
     *
     */

    // debug
    // print_r( $_SESSION );

    /**
     * configurazioni iniziali
     * =======================
     * 
     * 
     * 
     */

    // stato del login
    $cf['auth']['status'] = NULL;

    /**
     * gestione reCAPTCHA
     * ==================
     * 
     * 
     */

    // verifico la challenge reCAPTCHA
    if( isset( $_REQUEST['__login__']['__recaptcha_token__'] ) && isset( $cf['google']['profile']['recaptcha']['keys']['private'] ) ) {

        // registro il valore di bot
        $cf['session']['spam']['score'] = reCaptchaVerifyV3( $_REQUEST['__login__']['__recaptcha_token__'], $cf['google']['profile']['recaptcha']['keys']['private'] );

        // pulisco il modulo
        unset( $_REQUEST['__login__']['__recaptcha_token__'] );

        // punteggio di spam
        $cf['session']['spam']['check'] = ( $cf['session']['spam']['score'] > $cf['session']['spam']['limit'] ) ? true : false;

    } elseif( ! isset( $_REQUEST['__login__']['__recaptcha_token__'] ) && isset( $cf['google']['profile']['recaptcha']['keys']['private'] ) ) {

        // punteggio di spam
        $cf['session']['spam']['check'] = false;

    } else {

        // punteggio di spam
        $cf['session']['spam']['check'] = true;

    }

    // debug
    // var_dump( $cf['session']['spam'] );

    /**
     * login tramite header HTTP auth
     * ==============================
     * 
     * 
     * 
     */

    // intercetto eventuali richieste di autenticazione HTTP
    if( ! empty( $_SERVER['PHP_AUTH_USER'] ) && ! empty( $_SERVER['PHP_AUTH_PW'] ) ) {
        $_REQUEST['__login__']['user'] = $_SERVER['PHP_AUTH_USER'];
        $_REQUEST['__login__']['pasw'] = $_SERVER['PHP_AUTH_PW'];
    }

    // header della richiesta HTTP
    $httpHeaders = apache_request_headers();

    /**
     * login via header Authorization Bearer
     * =====================================
     * 
     * 
     */

    // debug
    // die( substr( $httpHeaders['Authorization'], 0, 7 ) );

    // intercetto l'header bearer autentication
    if( array_key_exists( 'Authorization', $httpHeaders ) ) {
        if( substr( $httpHeaders['Authorization'], 0, 6 ) == 'Bearer' ) {
            $_REQUEST['j'] = substr( $httpHeaders['Authorization'], 7 );
        }
    }

    /**
     * login via token JWT
     * ===================
     * 
     * 
     * 
     */

    // aggiungo il salt alla chiave segreta JWT
    if( isset( $cf['auth']['jwt']['secret'] ) ) {
        if( isset( $cf['auth']['jwt']['salt'] ) && ! empty( $cf['auth']['jwt']['salt'] ) ) {
            $cf['auth']['jwt']['secret'] .= $cf['auth']['jwt']['salt'];
        }
    }

    // intercetto eventuali richieste di autenticazione tramite token JWT
    if( ! empty( $_REQUEST['j'] ) ) {
        if( isset( $cf['auth']['jwt']['secret'] ) ) {
            $jwt = jwt2array( $_REQUEST['j'], $cf['auth']['jwt']['secret'] );
            if( isset( $jwt['data']['user'] ) ) {
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
    }

    /**
     * esecuzione del login
     * ====================
     * 
     * 
     * 
     */

    // intercetto eventuali tentativi di login in corso
    if( isset( $_REQUEST['__login__']['user'] ) ) {

        // log
        logger( 'tentativo di login in corso per ' . $_REQUEST['__login__']['user'], 'auth' );

        // intercetto eventuali tentativi di login in corso
        if( $cf['session']['spam']['check'] === true ) {

            // ricalcolo la password
            if( isset( $_REQUEST['__login__']['pasw'] ) ) {
                $_REQUEST['__login__']['pasw'] = md5( $_REQUEST['__login__']['pasw'] );
            } elseif( isset( $cf['auth']['jwt']['pass'] ) ) {
                $_REQUEST['__login__']['pasw'] = $cf['auth']['jwt']['pass'];
            }

            /**
             * login via file di configurazione
             * ================================
             * 
             * 
             */

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

                    // debug
                    // print_r( $_SESSION['account']['privilegi'] );

                    // status
                    $cf['auth']['status'] = LOGIN_SUCCESS;

                    // log
                    logger( 'login effettuato correttamente per ' . $_REQUEST['__login__']['user'], 'auth' );

                } else {

                    // status
                    $cf['auth']['status'] = LOGIN_ERR_WRONG_PW;

                    // log
                    logger( 'password errata per ' . $_REQUEST['__login__']['user'], 'auth', LOG_ERR );
                    logger( 'mancata corrispondenza degli hash per ' . $_REQUEST['__login__']['user'] . ': ' . $cf['auth']['accounts'][ $_REQUEST['__login__']['user'] ]['password'] . '/' . $_REQUEST['__login__']['pasw'], 'auth' );

                }

            } else {

                // status
                $cf['auth']['status'] = LOGIN_ERR_NO_USER;

                // log
                logger( $_REQUEST['__login__']['user'] . ' non presente nei file di configurazione', 'auth', LOG_INFO );

            }

            // speed
            timerCheck( $cf['speed'], '-> fine login via framework' );

            // debug
            // var_dump( $cf['auth']['status'] );
            // var_dump( LOGIN_SUCCESS );

            /**
             * login via database MySQL
             * ========================
             * 
             * 
             * 
             */

            // login su database MySQL
            if( $cf['auth']['status'] != LOGIN_SUCCESS ) {

                // se è presente una connessione MySQL
                if( ! empty( $cf['mysql']['connection'] ) ) {

                    // log
                    logger( 'fallback al login su database', 'auth' );

                    // query di login
                    $_SESSION['account'] = mysqlSelectRow(
                        $cf['mysql']['connection'],
                        'SELECT * FROM account_view WHERE username = ? AND password = ?',
                        array(
                            array( 's' => $_REQUEST['__login__']['user'] ),
                            array( 's' => $_REQUEST['__login__']['pasw'] )
                        )
                    );

                    // controllo il risultato
                    if( isset( $_SESSION['account']['se_attivo'] ) && $_SESSION['account']['se_attivo'] == true ) {

                        // verifica se si tratta del primo accesso e in tal caso valorizza il campo che andrà in $_SESSION['account']['first_access']
                        if( is_null( $_SESSION['account']['timestamp_login'] ) ) {
                            $_SESSION['account']['first_access'] = true;
                        } else {
                            $_SESSION['account']['last_access'] = $_SESSION['account']['timestamp_login'];
                        }

                        // aggiorno la timestamp_login dell'account connesso
                        $_SESSION['account']['login_update'] = mysqlQuery(
                            $cf['mysql']['connection'],
                            'UPDATE account SET timestamp_login = ? WHERE id = ? ',
                            array(
                                array( 's' => time() ),
                                array( 's' => $_SESSION['account']['id'] )
                            )
                        );

                        // nella view questi dati sono in forma di stringa e invece servono come array
                        string2array( $_SESSION['account']['gruppi'] );
                        string2array( $_SESSION['account']['id_gruppi'] );
                        string2array( $_SESSION['account']['categorie'] );
                        string2array( $_SESSION['account']['id_categorie'] );

                        // inizializzo i permessi
                        $_SESSION['account']['permissions'] = array();

                        // valorizzo i dati dei gruppi
                        // TODO fare una funzione aggiungiGruppiAccount() in _auth.utils.php
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
                            logger( 'attenzione, utente senza gruppi associati: ' . $_REQUEST['__login__']['user'], 'auth', LOG_ERR );
                        }

                        // dati anagrafici
                        // TODO fare una funzione aggiungiAnagraficaAccount() in _auth.utils.php
                        $_SESSION['account'] = array_replace_recursive(
                            $_SESSION['account'],
                            mysqlSelectRow(
                                $cf['mysql']['connection'],
                                'SELECT nome, cognome, denominazione, codice_fiscale, partita_iva, '.
                                'giorno_nascita, mese_nascita, anno_nascita, id_comune_nascita, '.
                                'se_collaboratore, se_cliente, se_fornitore, se_commerciale, se_amministrazione '.
                                'FROM anagrafica_view_static WHERE id = ?',
                                array( array( 's' => $_SESSION['account']['id_anagrafica'] ) )
                            )
                        );

                        // e-mail
                        // TODO fare una funzione aggiungiMailAccount() in _auth.utils.php
                        $_SESSION['account'] = array_replace_recursive(
                            $_SESSION['account'],
                            mysqlSelectRow(
                                $cf['mysql']['connection'],
                                'SELECT id AS id_mail, indirizzo AS mail '.
                                'FROM mail WHERE id_anagrafica = ?',
                                array( array( 's' => $_SESSION['account']['id_anagrafica'] ) )
                            )
                        );

                        // telefono fisso
                        // TODO fare una funzione aggiungiTelefoniAccount() in _auth.utils.php
                        $_SESSION['account'] = array_replace_recursive(
                            $_SESSION['account'],
                            mysqlSelectRow(
                                $cf['mysql']['connection'],
                                'SELECT id AS id_telefono, numero AS telefono '.
                                'FROM telefoni WHERE id_anagrafica = ? AND id_tipologia = 1',
                                array( array( 's' => $_SESSION['account']['id_anagrafica'] ) )
                            )
                        );

                        // cellulare
                        // TODO fare anche questo nella funzione aggiungiTelefoniAccount() in _auth.utils.php
                        $_SESSION['account'] = array_replace_recursive(
                            $_SESSION['account'],
                            mysqlSelectRow(
                                $cf['mysql']['connection'],
                                'SELECT id AS id_cellulare, numero AS cellulare '.
                                'FROM telefoni WHERE id_anagrafica = ? AND id_tipologia = 2',
                                array( array( 's' => $_SESSION['account']['id_anagrafica'] ) )
                            )
                        );

                        // indirizzo
                        // TODO fare una funzione aggiungiIndirizziAccount() in _auth.utils.php
                        $_SESSION['account'] = array_replace_recursive(
                            $_SESSION['account'],
                            mysqlSelectRow(
                                $cf['mysql']['connection'],
                                'SELECT anagrafica_indirizzi.id AS id_associazione_indirizzo, anagrafica_indirizzi.id_indirizzo, '.
                                'indirizzi.indirizzo, indirizzi.civico, indirizzi.cap, indirizzi.id_comune '.
                                'FROM anagrafica_indirizzi '.
                                'LEFT JOIN indirizzi ON indirizzi.id = anagrafica_indirizzi.id_indirizzo '.
                                'WHERE id_anagrafica = ? AND id_ruolo = 1',
                                array( array( 's' => $_SESSION['account']['id_anagrafica'] ) )
                            )
                        );

                        // attribuzione dei gruppi e dei privilegi di gruppo
                        // TODO fare una funzione aggiungiPrivilegiAccount() in _auth.utils.php
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
                            logger( 'attenzione, utente senza gruppi associati: ' . $_REQUEST['__login__']['user'], 'auth', LOG_ERR );
                        }

                        // gruppi di attribuzione automatica dell'utente
                        // TODO fare una funzione aggiungiAttribuzioneAutomaticaAccount() in _auth.utils.php
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

                        // sorgente del login
                        $_SESSION['account']['source'] = 'mysql';

                        // log
                        logger( 'login effettuato correttamente via database per ' . $_REQUEST['__login__']['user'], 'auth', LOG_DEBUG );

                    } elseif( isset( $_SESSION['account']['se_attivo'] ) && $_SESSION['account']['se_attivo'] != true ) {

                        // status
                        $cf['auth']['status'] = LOGIN_ERR_INACTIVE;

                        // log
                        logger( 'UTENTE INATTIVO, impossibile effettuare il login via database per ' . $_REQUEST['__login__']['user'] . '/' . $_REQUEST['__login__']['pasw'], 'auth', LOG_INFO );

                    } else {

                        // status
                        $cf['auth']['status'] = LOGIN_ERR_WRONG_PW;

                        // log
                        logger( 'impossibile effettuare il login via database per ' . $_REQUEST['__login__']['user'] . '/' . $_REQUEST['__login__']['pasw'], 'auth', LOG_ERR );

                    }

                } else {

                    // status
                    $cf['auth']['status'] = LOGIN_ERR_NO_CONNECTION;

                    // log
                    logger( 'login sul database per ' . $_REQUEST['__login__']['user'] . ' impossibile per mancanza di connessione', 'auth', LOG_DEBUG );

                }

                // speed
                timerCheck( $cf['speed'], '-> fine login via database' );

            }

            /**
             * configurazioni post login
             * =========================
             * 
             * 
             * 
             * 
             */

            // se il login è andato a buon fine
            if( $cf['auth']['status'] == LOGIN_SUCCESS ) {

                // generazione stringa JWT per il login corrente (da usare per il login via JWT)
                if( ! empty( $cf['auth']['jwt']['secret'] ) ) {

                    // genero la stringa JWT
                    $cf['session']['jwt']['string'] = getJwt(
                        array(
                            'id' => $_SESSION['account']['id'],
                            'user' => $_SESSION['account']['username']
                        ),
                        $cf['auth']['jwt']['secret']
                    );

                    // log
                    logger( 'stringa JWT generata per ' . $_REQUEST['__login__']['user'] . ': ' . $cf['session']['jwt']['string'], 'auth' );

                }

                // TODO attribuzione dei permessi
                // prelevare il codice da _255.auth.php

            }

        } else {

            // log
            logger( 'check anti spam al login fallito per ' . $_REQUEST['__login__']['user'], 'auth', LOG_ERR );

        }

    }

    // debug
    // print_r( $cf['localization']['language'] );
    // print_r( $_SESSION );
    // print_r( $cf['auth']['jwt'] );
    // print_r( $cf['session'] );
