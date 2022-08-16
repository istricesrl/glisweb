<?php

/**
     *
     * @todo documentare
     *
     */

    // STEP 1 - se esiste un pacchetto dati per __carrello__

    // verifico se è presente una richiesta per il modulo ecommerce
    if( isset( $_REQUEST['__carrello__'] ) && is_array( $_REQUEST['__carrello__'] ) ) {

        // log
        logWrite( 'attivata la controller del carrello', 'cart' );

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

            // inserimento del carrello a database e recupero dell'ID
            $_SESSION['carrello']['id'] = mysqlInsertRow(
                $cf['mysql']['connection'],
                $_SESSION['carrello'],
                'carrelli'
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
        $_SESSION['carrello']['prezzo_netto_totale']        = 0;
        $_SESSION['carrello']['prezzo_lordo_totale']        = 0;
        $_SESSION['carrello']['prezzo_netto_finale']        = 0;
        $_SESSION['carrello']['prezzo_lordo_finale']        = 0;
        $_SESSION['carrello']['sconto_percentuale']         = 0;

        // STEP 4 - gestione acquisto singolo articolo
        if( isset( $_REQUEST['__carrello__']['__articolo__']['id_articolo'] ) ) {

            // quantità acquistata
            $_REQUEST['__carrello__']['__articolo__']['quantita'] = ( isset( $_REQUEST['__carrello__']['__articolo__']['quantita'] ) )
                ? $_REQUEST['__carrello__']['__articolo__']['quantita']
                : 1;

            // log
            logWrite( 'acquisto singolo articolo ' . $_REQUEST['__carrello__']['__articolo__']['id_articolo'] . ' x ' . $_REQUEST['__carrello__']['__articolo__']['quantita'], 'cart' );

            // aggiunta articolo al carrello
            $_REQUEST['__carrello__'] = array_replace_recursive(
                $_REQUEST['__carrello__'],
                array(
                    '__articoli__' => array(
                        $_REQUEST['__carrello__']['__articolo__']['id_articolo'] => array(
                            'quantita' => $_REQUEST['__carrello__']['__articolo__']['quantita'],
                            'id_articolo' => $_REQUEST['__carrello__']['__articolo__']['id_articolo'],
                            'destinatario_id_anagrafica' => ( isset( $_REQUEST['__carrello__']['__articolo__']['destinatario_id_anagrafica'] ) ) ? $_REQUEST['__carrello__']['__articolo__']['destinatario_id_anagrafica'] : NULL,
                            'id_iva' => ( isset( $_REQUEST['__carrello__']['__articolo__']['id_iva'] ) ) ? $_REQUEST['__carrello__']['__articolo__']['id_iva'] : 1
                        )
                    )
                )
            );

        }

        // debug
        // echo '<pre>' . print_r( $_REQUEST['__carrello__']['__articoli__'], true ) . '</pre>';

        // integro gli articoli
        if( isset( $_REQUEST['__carrello__']['__articoli__'] ) && is_array( $_REQUEST['__carrello__']['__articoli__'] ) ) {
            foreach( $_REQUEST['__carrello__']['__articoli__'] as $key => &$item ) {
                foreach( $cf['ecommerce']['fields']['articoli'] as $field => $model ) {
                    if( ! isset( $item[ $field ] ) || empty( $item[ $field ] ) ) {
                        $item[ $field ] = $model['default'];
                    }
                }
                // echo '<pre>' . print_r( $item, true ) . '</pre>';
                if( isset( $_SESSION['carrello']['articoli'][ $item['id_articolo'] ] ) ) {
                    $_SESSION['carrello']['articoli'][ $item['id_articolo'] ] = array_replace_recursive(
                        $_SESSION['carrello']['articoli'][ $item['id_articolo'] ],
                        $item
                    );
                } else {
                    $_SESSION['carrello']['articoli'][ $item['id_articolo'] ] = $item;
                }
                // echo '<pre>' . print_r( $_SESSION['carrello']['articoli'][ $item['id_articolo'] ], true ) . '</pre>';
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
                    mysqlQuery(
                        $cf['mysql']['connection'],
                        'DELETE FROM carrelli_articoli WHERE id_articolo = ? AND id_carrello = ?',
                        array(
                            array( 's' => $dati['id_articolo'] ),
                            array( 's' => $_SESSION['carrello']['id'] )
                        )
                    );

                    // log
                    logWrite( 'eliminato articolo ' . $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['id_articolo'] . ' dal carrello ' . $_SESSION['carrello']['id'], 'cart' );

                    // aggiorno la riga dell'articolo
                    unset( $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ] );

                } else { 

                    // aggiorno la riga dell'articolo
                    $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['id_carrello']                = $_SESSION['carrello']['id'];
                    $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['id_articolo']                = $dati['id_articolo'];
                    $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['id_iva']                     = $dati['id_iva'];
                    $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['quantita']                   = $dati['quantita'];
                    $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['destinatario_id_anagrafica'] = $dati['destinatario_id_anagrafica'];

                    // trovo la descrizione dell'articolo
                    $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['descrizione'] = mysqlSelectCachedValue(
                        $cf['memcache']['connection'],
                        $cf['mysql']['connection'],
                        'SELECT nome FROM articoli_view WHERE id = ?',
                        array(
                            array( 's' => $dati['id_articolo'] )
                        )
                    );

                    // trovo il prezzo base dell'articolo
                    $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['prezzo_netto_unitario'] = calcolaPrezzoNettoArticolo(
                        $cf['memcache']['connection'],
                        $cf['mysql']['connection'],
                        $dati['id_articolo'],
                        $_SESSION['carrello']['id_listino']
                    );

                    // trovo il prezzo lordo dell'articolo
                    $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['prezzo_lordo_unitario'] = calcolaPrezzoLordoArticolo(
                        $cf['memcache']['connection'],
                        $cf['mysql']['connection'],
                        $dati['id_articolo'],
                        $_SESSION['carrello']['id_listino'],
                        $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['id_iva']
                    );

                    // trovo i prezzi totali
                    $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['prezzo_netto_totale'] = $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['prezzo_netto_unitario'] * $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['quantita'];
                    $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['prezzo_lordo_totale'] = $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['prezzo_lordo_unitario'] * $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['quantita'];

                    // TODO trovo i prezzi finali
                    $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['prezzo_netto_finale'] = $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['prezzo_netto_totale'];
                    $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['prezzo_lordo_finale'] = $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['prezzo_lordo_totale'];

                    // aggiorno la riga
                    mysqlInsertRow(
                        $cf['mysql']['connection'],
                        array(
                            'id_carrello'                   => $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['id_carrello'],
                            'id_articolo'                   => $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['id_articolo'],
                            'destinatario_id_anagrafica'    => $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['destinatario_id_anagrafica'],
                            'id_iva'                        => $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['id_iva'],
                            'quantita'                      => $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['quantita'],
                            'prezzo_netto_unitario'         => $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['prezzo_netto_unitario'],
                            'prezzo_lordo_unitario'         => $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['prezzo_lordo_unitario'],
                            'prezzo_netto_totale'           => $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['prezzo_netto_totale'],
                            'prezzo_lordo_totale'           => $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['prezzo_lordo_totale'],
                            'prezzo_netto_finale'           => $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['prezzo_netto_finale'],
                            'prezzo_lordo_finale'           => $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['prezzo_lordo_finale']
                        ),
                        'carrelli_articoli'
                    );

                    // incremento i totali carrello
                    $_SESSION['carrello']['prezzo_netto_totale'] += $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['prezzo_netto_totale'];
                    $_SESSION['carrello']['prezzo_lordo_totale'] += $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['prezzo_lordo_totale'];
                    $_SESSION['carrello']['prezzo_netto_finale'] += $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['prezzo_netto_finale'];
                    $_SESSION['carrello']['prezzo_lordo_finale'] += $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['prezzo_lordo_finale'];

                    // debug
                    // echo $_SESSION['carrello']['prezzo_lordo_finale'] . PHP_EOL;

                    // log
                    logWrite( 'aggiornato articolo ' . $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['id_articolo'] . ' nel carrello ' . $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['id_carrello'], 'cart' );

                }

            }

        }

        // STEP 6 - calcolo coupon

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
                    'se_login' => NULL,
                    'timestamp_inserimento' => NULL
                )
            ),
            'carrelli'
        );

        // log
        logWrite( 'aggiornato il carrello ' . $_SESSION['carrello']['id'], 'cart' );

        // STEP 9 - salvataggio copia di sicurezza del carrello
        $f = DIR_VAR_SPOOL_CART . sprintf( '%08d', $_SESSION['carrello']['id'] ) . '.log';
        writeToFile( print_r( $_SESSION['carrello'], true ), $f );

        // debug
        // echo $f;

    }

    // debug
    // print_r( $_REQUEST['__carrello__'] );
