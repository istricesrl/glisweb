<?php

/**
     *
     * @todo documentare
     *
     */

    // STEP 1 - se esiste un pacchetto dati per __carrello__

    // verifico se è presente una richiesta per il modulo ecommerce
    if( isset( $_REQUEST['__carrello__'] ) && is_array( $_REQUEST['__carrello__'] ) ) {

        // verifico la challenge reCAPTCHA
        if( isset( $_REQUEST['__carrello__']['__recaptcha_token__'] ) && isset( $cf['google']['profile']['recaptcha']['keys']['private'] ) ) {

            // registro il valore di bot
            $spamScore = reCaptchaVerifyV3( $_REQUEST['__carrello__']['__recaptcha_token__'], $cf['google']['profile']['recaptcha']['keys']['private'] );

            // pulisco il modulo
            unset( $_REQUEST['__carrello__']['__recaptcha_token__'] );

            // punteggio di spam
            $spamCheck = ( $spamScore > 0.3 ) ? true : false;

        } elseif( ! isset( $_REQUEST['__carrello__']['__recaptcha_token__'] ) && isset( $cf['google']['profile']['recaptcha']['keys']['private'] ) ) {

            // registro il valore di bot
            $spamScore = 0;

            // punteggio di spam
            $spamCheck = false;

        } else {

            // registro il valore di bot
            $spamScore = 1;

            // punteggio di spam
            $spamCheck = true;

        }

        // log
        logWrite( 'attivata la controller del carrello', 'cart' );

        // TODO qui fare il controllo anti spam
        if( $spamCheck === true ) {

            // STEP 2 - se non esiste $_SESSION['carrello'] lo creo
            if( ! isset( $_SESSION['carrello']['id'] ) || empty( $_SESSION['carrello']['id'] ) ) {

                // inizializzazione dei valori base del carrello
                foreach( $cf['ecommerce']['fields']['carrello'] as $field => $model ) {
                    $_SESSION['carrello'][ $field ] =
                        ( isset( $_REQUEST['__carrello__'][ $field ] ) ) ? 
                        $_REQUEST['__carrello__'][ $field ] : 
                        $model['default'];
                }

                // inizializzazione dei valori speciali del carrello
                $_SESSION['carrello']['session']                    = $_SESSION['id'];      // ogni carrello è collegato alla sessione che l'ha generato
                $_SESSION['carrello']['timestamp_inserimento']      = time();               // timestemp del momento di creazione del carrello

                // aggiungo al carrello l'esito del controllo anti spam
                $_SESSION['carrello']['spam_score'] = $spamScore;
                $_SESSION['carrello']['spam_check'] = $spamCheck;

                // inserimento del carrello a database e recupero dell'ID
                $_SESSION['carrello']['id'] = mysqlInsertRow(
                    $cf['mysql']['connection'],
                    $_SESSION['carrello'],
                    'carrelli'
                );

                // valuta del carrello
                $_SESSION['carrello']['valuta_utf8'] = mysqlSelectCachedValue(
                    $cf['memcache']['connection'],
                    $cf['mysql']['connection'],
                    'SELECT utf8 FROM valute INNER JOIN listini ON valute.id = listini.id_valuta WHERE listini.id = ?',
                    array( array( 's' => $_SESSION['carrello']['id_listino'] ) )
                );

                // TODO
                // if( isset( $_SESSION['utm'] ) && ! empty( $_SESSION['utm'][ $field ] ) ) { ... }

                // array degli articoli
                $_SESSION['carrello']['articoli'] = array();

                // log
                logWrite( 'creato il carrello ' . $_SESSION['carrello']['id'], 'cart' );

                // debug
                // echo 'creato il carrello ' . $_SESSION['carrello']['id'] . PHP_EOL;

            } else {

                // STEP 3 - aggiorno i dati del carrello
                foreach( $cf['ecommerce']['fields']['carrello'] as $field => $model ) {
                    if( isset( $_REQUEST['__carrello__'][ $field ] ) ) {
                        $_SESSION['carrello'][ $field ] = $_REQUEST['__carrello__'][ $field ];
                    }
                }

            }

            // inizializzazione totali carrello
            $_SESSION['carrello']['prezzo_netto_totale']        = 0.0;
            $_SESSION['carrello']['prezzo_lordo_totale']        = 0.0;
            $_SESSION['carrello']['prezzo_netto_finale']        = 0.0;
            $_SESSION['carrello']['prezzo_lordo_finale']        = 0.0;
            $_SESSION['carrello']['sconto_percentuale']         = 0.0;
            $_SESSION['carrello']['sconto_valore']              = 0.0;

            // inizializzazione calcolatore articoli aggiunti
            $deltaArticoli = array();

            // debug
            // print_r( $_SESSION['carrello']['articoli'] );

            // STEP 4 - gestione acquisto singolo articolo
            if( isset( $_REQUEST['__carrello__']['__articolo__']['id_articolo'] ) ) {

                // quantità acquistata
                $_REQUEST['__carrello__']['__articolo__']['quantita'] = ( isset( $_REQUEST['__carrello__']['__articolo__']['quantita'] ) )
                    ? $_REQUEST['__carrello__']['__articolo__']['quantita']
                    : (
                        ( isset( $_SESSION['carrello']['articoli'][ $_REQUEST['__carrello__']['__articolo__']['id_articolo'].( ( isset( $_REQUEST['__carrello__']['__articolo__']['destinatario_id_anagrafica'] ) ) ? $_REQUEST['__carrello__']['__articolo__']['destinatario_id_anagrafica'] : NULL ) ]['quantita'] ) )
                        ? ( $_SESSION['carrello']['articoli'][ $_REQUEST['__carrello__']['__articolo__']['id_articolo'].( ( isset( $_REQUEST['__carrello__']['__articolo__']['destinatario_id_anagrafica'] ) ) ? $_REQUEST['__carrello__']['__articolo__']['destinatario_id_anagrafica'] : NULL ) ]['quantita'] + 1 )
                        : 1
                    );

                // dettaglio articolo aggiunto
                $deltaArticoli[ $_REQUEST['__carrello__']['__articolo__']['id_articolo'] ] = array(
                    'id_articolo' => $_REQUEST['__carrello__']['__articolo__']['id_articolo'],
                    'quantita' => ( isset( $_REQUEST['__carrello__']['__articolo__']['quantita'] ) )
                    ? $_REQUEST['__carrello__']['__articolo__']['quantita']
                    : 1
                );

                // debug
                // die( 'qta ' . $_REQUEST['__carrello__']['__articolo__']['quantita'] );

                // log
                logWrite( 'acquisto singolo articolo ' . $_REQUEST['__carrello__']['__articolo__']['id_articolo'] . ' x ' . $_REQUEST['__carrello__']['__articolo__']['quantita'], 'cart' );

                /*
                if( isset( $cf['facebook']['profile']['pixel']['id'] ) && isset( $cf['facebook']['profile']['pixel']['token'] ) ) {

                    // dati
                    $data = array(
                        'access_token' => $cf['facebook']['profile']['pixel']['token'],
                        'data' => json_encode(
                            array(
                                array(
                                    'event_name' => 'AddToCart',
                                    'event_time' => time(),
                                    'action_source' => 'website',
                                    'user_data' => array(
                                        'external_id' => array(
                                            hash( 'sha256', $_REQUEST['__carrello__']['id'] )
                                        )
                                    ),
                                    'custom_data' => array(
                                        'currency' => 'EUR',
                                        'value' => '142.52'
                                    )
                                )
                            )
                        )
                    );

                    // chiamata
                    restCall(
                        'https://graph.facebook.com/v15.0/'.$cf['facebook']['profile']['pixel']['id'].'/events',
                        METHOD_POST,
                        $data,
                        MIME_X_WWW_FORM_URLENCODED,
                        MIME_APPLICATION_JSON,
                        $status,
                        array(),
                        NULL,
                        NULL,
                        $error
                    );

                    // debug
                    // echo '<pre>';
                    // print_r( $_REQUEST['__carrello__'] );
                    // print_r( $_REQUEST['__carrello__']['__articolo__'] );
                    // print_r( $data );
                    // print_r( $status );
                    // print_r( $error );
                    // echo '</pre>';

                }
                */

                // aggiunta articolo al carrello
                $_REQUEST['__carrello__'] = array_replace_recursive(
                    $_REQUEST['__carrello__'],
                    array(
                        '__articoli__' => array(
                            $_REQUEST['__carrello__']['__articolo__']['id_articolo'] => array(
                                'quantita' => $_REQUEST['__carrello__']['__articolo__']['quantita'],
                                'id_articolo' => $_REQUEST['__carrello__']['__articolo__']['id_articolo'],
                                'id_rinnovo' => ( isset( $_REQUEST['__carrello__']['__articolo__']['id_rinnovo'] ) ) ? $_REQUEST['__carrello__']['__articolo__']['id_rinnovo'] : NULL,
                                'destinatario_id_anagrafica' => ( isset( $_REQUEST['__carrello__']['__articolo__']['destinatario_id_anagrafica'] ) ) ? $_REQUEST['__carrello__']['__articolo__']['destinatario_id_anagrafica'] : NULL,
                                'id_iva' => ( isset( $_REQUEST['__carrello__']['__articolo__']['id_iva'] ) ) ? $_REQUEST['__carrello__']['__articolo__']['id_iva'] : 1,
                                // 'sconto_percentuale' => 0,
                                // 'sconto_valore' => 0
                            )
                        )
                    )
                );

            }

            // FINE ACQUISTO SINGOLO ARTICOLO

            // debug
            // echo '<pre>' . print_r( $_REQUEST['__carrello__']['__articoli__'], true ) . '</pre>';

            // integro gli articoli
            if( isset( $_REQUEST['__carrello__']['__articoli__'] ) && is_array( $_REQUEST['__carrello__']['__articoli__'] ) ) {
                foreach( $_REQUEST['__carrello__']['__articoli__'] as $key => &$item ) {
                    $deltaArticoli[ $item['id_articolo'].( ( isset( $item['destinatario_id_anagrafica'] ) ) ? $item['destinatario_id_anagrafica'] : NULL ) ] = array(
                        'id_articolo' => $item['id_articolo'],
                        'quantita' => ( isset( $_SESSION['carrello']['articoli'][ $item['id_articolo'].( ( isset( $item['destinatario_id_anagrafica'] ) ) ? $item['destinatario_id_anagrafica'] : NULL ) ][ $field ] ) )
                        ? $_SESSION['carrello']['articoli'][ $item['id_articolo'].( ( isset( $item['destinatario_id_anagrafica'] ) ) ? $item['destinatario_id_anagrafica'] : NULL ) ][ $field ] - $item['quantita']
                        : $item['quantita']
                    );
                    foreach( $cf['ecommerce']['fields']['articoli'] as $field => $model ) {
                        if( ! isset( $item[ $field ] ) && ! isset( $_SESSION['carrello']['articoli'][ $item['id_articolo'].( ( isset( $item['destinatario_id_anagrafica'] ) ) ? $item['destinatario_id_anagrafica'] : NULL ) ][ $field ] ) ) {
                            $item[ $field ] = $model['default'];
                        }
                    }
                    // TODO IMPORTANTE nel ciclo qui sopra, oppure a parte qui sotto, accettare il valore di sconto solo se l'utente ha i privilegi appropriati (altrimenti la gente si mette gli sconti da sola)
                    // echo '<pre>' . print_r( $item, true ) . '</pre>';
                    if( isset( $_SESSION['carrello']['articoli'][ $item['id_articolo'].( ( isset( $item['destinatario_id_anagrafica'] ) ) ? $item['destinatario_id_anagrafica'] : NULL ) ] ) ) {
                        $_SESSION['carrello']['articoli'][ $item['id_articolo'].( ( isset( $item['destinatario_id_anagrafica'] ) ) ? $item['destinatario_id_anagrafica'] : NULL ) ] = array_replace_recursive(
                            $_SESSION['carrello']['articoli'][ $item['id_articolo'].( ( isset( $item['destinatario_id_anagrafica'] ) ) ? $item['destinatario_id_anagrafica'] : NULL ) ],
                            $item
                        );
                    } else {
                        $_SESSION['carrello']['articoli'][ $item['id_articolo'].( ( isset( $item['destinatario_id_anagrafica'] ) ) ? $item['destinatario_id_anagrafica'] : NULL ) ] = $item;
                    }
                    // echo '<pre>' . print_r( $_SESSION['carrello']['articoli'][ $item['id_articolo'].( ( isset( $item['destinatario_id_anagrafica'] ) ) ? $item['destinatario_id_anagrafica'] : NULL ) ], true ) . '</pre>';
                }
            }

            // debug
            // echo '<pre>' . print_r( $_REQUEST['__carrello__']['__articoli__'], true ) . '</pre>';

            // registro i consensi
            if( isset( $_REQUEST['__consensi__']['__carrello__'] ) ) {

                // per ogni consenso...
                foreach( $_REQUEST['__consensi__']['__carrello__'] as $ck => $cv ) {

                    // timestamp del consenso
                    $timestamp = time();

                    // contenuto del consenso
                    $contenuto = 'il ' . date( 'd/m/Y', $timestamp ) . ' alle ' . date( 'H:i:s', $timestamp ) . ( ( empty( $cv['value'] ) ) ? ' non' : NULL ) . ' è stato prestato il consenso per ' . $ck . ' tramite il modulo __carrello__ per il carrello #' . $_SESSION['carrello']['id'];

                    // se è presente un ID account
                    if( isset( $_SESSION['carrello']['intestazione_id_account'] ) ) {
                        $contenuto .= ' account #' . $_SESSION['carrello']['intestazione_id_account'];
                    }

                    // se è presente un ID anagrafica
                    if( isset( $_SESSION['carrello']['intestazione_id_anagrafica'] ) ) {
                        $contenuto .= ' account #' . $_SESSION['carrello']['intestazione_id_anagrafica'];
                    }

                    // log
                    logWrite( $contenuto, 'privacy', LOG_CRIT );

                    // salvo le informazioni nella tabella carrelli_consensi
                    $prvId = mysqlInsertRow(
                        $cf['mysql']['connection'],
                        array(
                            'id' => NULL,
                            'id_carrello' => $_SESSION['carrello']['id'],
                            'id_account' => ( isset( $_SESSION['carrello']['intestazione_id_account'] ) ) ? $_SESSION['carrello']['intestazione_id_account'] : NULL,
                            'id_anagrafica' => ( isset( $_SESSION['carrello']['intestazione_id_anagrafica'] ) ) ? $_SESSION['carrello']['intestazione_id_anagrafica'] : NULL,
                            'id_consenso' => $ck,
                            'se_prestato' => $cv['value'],
                            'note' => $contenuto,
                            'timestamp_consenso' => $timestamp
                        ),
                        'carrelli_consensi'
                    );

                }

            }

            // STEP 5 - acquisto articoli multipli
            if( isset( $_SESSION['carrello']['articoli'] ) && is_array( $_SESSION['carrello']['articoli'] ) ) {

                // ciclo sugli articoli
                foreach( $_SESSION['carrello']['articoli'] as $dati ) {

                    // eliminazione articolo dal carrello
                    if( empty( $dati['quantita'] ) ) {

                        // elimino l'articolo
                        // TODO questa cancellazione elimina tutte le righe con l'articolo per qualunque destinatario_id_anagrafica, bisogna sistemarla ma questo richiede modifiche all'interfaccia
                        mysqlQuery(
                            $cf['mysql']['connection'],
                            'DELETE FROM carrelli_articoli WHERE id_articolo = ? AND id_carrello = ?',
                            array(
                                array( 's' => $dati['id_articolo'] ),
                                array( 's' => $_SESSION['carrello']['id'] )
                            )
                        );

                        // log
                        logWrite( 'eliminato articolo ' . $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['id_articolo'] . ' dal carrello ' . $_SESSION['carrello']['id'], 'cart' );

                        // aggiorno la riga dell'articolo
                        unset( $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ] );

                    } else { 

                        // debug
                        // print_r( $dati );

                        // aggiorno la riga dell'articolo
                        $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['id_carrello']                = $_SESSION['carrello']['id'];
                        $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['id_articolo']                = $dati['id_articolo'];
                        $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['id_iva']                     = $dati['id_iva'];
                        $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['quantita']                   = $dati['quantita'];
                        $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['destinatario_id_anagrafica'] = $dati['destinatario_id_anagrafica'];
                        $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['id_rinnovo']                 = $dati['id_rinnovo'];
                        $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['sconto_percentuale']         = $dati['sconto_percentuale'];
                        $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['sconto_valore']              = $dati['sconto_valore'];

                        // trovo la descrizione dell'articolo
                        $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['descrizione'] = implode( ' / ',
                            array(
                                mysqlSelectCachedValue(
                                    $cf['memcache']['connection'],
                                    $cf['mysql']['connection'],
                                    'SELECT __label__ FROM anagrafica_view WHERE id = ?',
                                    array(
                                        array( 's' => $dati['destinatario_id_anagrafica'] )
                                    )
                                ),
                                mysqlSelectCachedValue(
                                    $cf['memcache']['connection'],
                                    $cf['mysql']['connection'],
                                    'SELECT nome FROM articoli_view WHERE id = ?',
                                    array(
                                        array( 's' => $dati['id_articolo'] )
                                    )
                                )
                            )
                        );

                        // trovo il prezzo base dell'articolo
                        $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['prezzo_netto_unitario'] = calcolaPrezzoNettoArticolo(
                            $cf['memcache']['connection'],
                            $cf['mysql']['connection'],
                            $dati['id_articolo'],
                            $_SESSION['carrello']['id_listino']
                        );

                        // trovo il prezzo lordo dell'articolo
                        $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['prezzo_lordo_unitario'] = calcolaPrezzoLordoArticolo(
                            $cf['memcache']['connection'],
                            $cf['mysql']['connection'],
                            $dati['id_articolo'],
                            $_SESSION['carrello']['id_listino'],
                            $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['id_iva']
                        );

                        // trovo i prezzi totali
                        $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['prezzo_netto_totale'] = $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['prezzo_netto_unitario'] * $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['quantita'];
                        $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['prezzo_lordo_totale'] = $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['prezzo_lordo_unitario'] * $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['quantita'];

                        // TODO calcolo e applico lo sconto per riga
                        if( ! empty( $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['sconto_percentuale'] ) && is_numeric( $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['sconto_percentuale'] ) ) {
                            $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['sconto_valore'] = $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['prezzo_lordo_totale'] / 100 * $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['sconto_percentuale'];
                        } else {
                            $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['sconto_valore'] = 0;
                        }

                        // TODO trovo i prezzi finali
                        // TODO calcolare correttamente lo sconto sul netto
                        $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['prezzo_netto_finale'] = $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['prezzo_netto_totale'] - $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['sconto_valore'];
                        $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['prezzo_lordo_finale'] = $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['prezzo_lordo_totale'] - $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['sconto_valore'];

                        // aggiorno la riga
                        mysqlInsertRow(
                            $cf['mysql']['connection'],
                            array(
                                'id_carrello'                   => $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['id_carrello'],
                                'id_articolo'                   => $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['id_articolo'],
                                'destinatario_id_anagrafica'    => $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['destinatario_id_anagrafica'],
                                'id_rinnovo'                    => $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['id_rinnovo'],
                                'id_iva'                        => $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['id_iva'],
                                'quantita'                      => str_replace( ',', '.', $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['quantita'] ),
                                'prezzo_netto_unitario'         => str_replace( ',', '.', $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['prezzo_netto_unitario'] ),
                                'prezzo_lordo_unitario'         => str_replace( ',', '.', $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['prezzo_lordo_unitario'] ),
                                'prezzo_netto_totale'           => str_replace( ',', '.', $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['prezzo_netto_totale'] ),
                                'prezzo_lordo_totale'           => str_replace( ',', '.', $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['prezzo_lordo_totale'] ),
                                'sconto_percentuale'            => str_replace( ',', '.', $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['sconto_percentuale'] ),
                                'sconto_valore'                 => str_replace( ',', '.', $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['sconto_valore'] ),
                                'prezzo_netto_finale'           => str_replace( ',', '.', $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['prezzo_netto_finale'] ),
                                'prezzo_lordo_finale'           => str_replace( ',', '.', $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['prezzo_lordo_finale'] )
                            ),
                            'carrelli_articoli',
                            true,
                            false,
                            array(
                                'id_carrello',
                                'id_articolo',
                                'destinatario_id_anagrafica'
                            )
                        );

                        // incremento i totali carrello
                        $_SESSION['carrello']['prezzo_netto_totale'] += $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['prezzo_netto_totale'];
                        $_SESSION['carrello']['prezzo_lordo_totale'] += $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['prezzo_lordo_totale'];
                        $_SESSION['carrello']['prezzo_netto_finale'] += $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['prezzo_netto_finale'];
                        $_SESSION['carrello']['prezzo_lordo_finale'] += $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['prezzo_lordo_finale'];

                        // debug
                        // echo $_SESSION['carrello']['prezzo_lordo_finale'] . PHP_EOL;
                        // die( print_r( $_SESSION['carrello'] ) );

                        // log
                        logWrite( 'aggiornato articolo ' . $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['id_articolo'] . ' nel carrello ' . $_SESSION['carrello']['articoli'][ $dati['id_articolo'].$dati['destinatario_id_anagrafica'] ]['id_carrello'], 'cart' );

                    }

                }

            }

            // STEP 6 - calcolo coupon

            // se è stato inviato un codice coupon...
            if( $_SESSION['carrello']['codice_coupon'] ) {

                // TODO verifico se il coupon può essere utilizzato con questo carrello

                // TODO trovo l'ID del coupon

                // debug
                $_SESSION['carrello']['id_coupon'] = 1;

            } else {

                // rimuovo il coupon inutilizzabile
                $_SESSION['carrello']['id_coupon'] = NULL;

            }

            // TODO se il coupon può essere utilizzato ne calcolo il valore altrimenti lo elimino
            if( ! empty( $_SESSION['carrello']['id_coupon'] ) ) {

                // TODO calcolo il valore percentuale del coupon se applicabile

                // debug
                $_SESSION['carrello']['sconto_percentuale_coupon'] = 10;

                // TODO calcolo il valore assoluto del coupon (direttamente o in conseguenza dello sconto percentuale)

                // debug
                $_SESSION['carrello']['sconto_valore_coupon'] = 100;

            } else {

                // rimuovo il coupon inutilizzabile
                $_SESSION['carrello']['codice_coupon'] =
                $_SESSION['carrello']['sconto_valore_coupon'] =
                $_SESSION['carrello']['sconto_percentuale_coupon'] = NULL;

            }

            // STEP 7 - calcoli finali

            // aggiorno l'anagrafica e l'account collegati al carrello
            aggiornaProprietarioCarrello( $_SESSION['carrello'] );

            // aggiornamento del flag se_login
            aggiornaFlagCarrelloSeLogin( $_SESSION['carrello'] );

            // timestamp di aggiornamento del carrello
            $_SESSION['carrello']['timestamp_aggiornamento'] = time();

            // STEP 8 - salvataggio carrello nel database
            $_SESSION['carrello']['id'] = mysqlInsertRow(
                $cf['mysql']['connection'],
                array_diff_key(
                    $_SESSION['carrello'], array(
                        'articoli' => array(),
                        'metadati' => array(),
                        'valuta_utf8' => NULL,
                        'se_login' => NULL,
                        'timestamp_inserimento' => NULL
                    )
                ),
                'carrelli'
            );

            // evento Facebook
            fbEventAddToCart( $cf['memcache']['connection'], $cf['mysql']['connection'], $cf['facebook']['profile'], $_SESSION['carrello'], $deltaArticoli );

            // log
            logWrite( 'aggiornato il carrello ' . $_SESSION['carrello']['id'], 'cart' );

            // STEP 9 - salvataggio copia di sicurezza del carrello
            $f = DIR_VAR_SPOOL_CART . sprintf( '%08d', $_SESSION['carrello']['id'] ) . '.log';
            writeToFile( print_r( $_SESSION['carrello'], true ), $f );

            // debug
            // echo $f;

        }   // fine controllo antispam

    }

    // debug
    // print_r( $_REQUEST['__carrello__'] );
