<?php

    /**
     * API per la creazione di un ordine in PayPal Advanced
     * 
     * questa API viene chiamata dal front-end per creare un ordine in PayPal e restituirne l'ID
     * 
     * introduzione
     * ============
     * Questa API lavora su una riga della tabella pagamenti, e i dati che fornisce a PayPal sono quelli della riga stessa. Se la riga
     * per qualsiasi ragione non esiste, l'API prova a crearla in base ai dati che le vengono forniti (vedi sotto).
     * 
     * creazione o recupero del pagamento
     * ==================================
     * Questa API richiede alcuni dati per poter funzionare correttamente, il più importante è l'ID del pagamento (ovvero della riga della tabella pagamenti);
     * se questo ID non è fornito, l'API prova a crearlo al volo a partire da id_carrelli_articoli. Inoltre è atteso un token di pagamento, che è sostanzialmente
     * una chiave univoca che permette di recuperare i dati del pagamento da memcache; fra questi dati ci sono gli URL che l'API di cattura del pagamento
     * dovrà utilizzare in caso di successo e di fallimento.
     * 
     * recupero del pagamento tramite ID
     * ---------------------------------
     * Se l'API riceve un ID, prova a recuperare la riga corrispondente dalla tabella dei pagamenti, dopo aver registrato il token di pagamento. In questo scenario
     * gli unici dati necessari sono l'ID del pagamento e il token di pagamento.
     * 
     * creazione del pagamento al volo
     * -------------------------------
     * Se l'API non riceve un ID, prova a creare il pagamento a partire da id_carrelli_articoli; in questo caso vengono recuperati i dati dalla tabella carrelli_articoli
     * in base al valore fornito di id_carrelli_articoli; è necessario anche in questo caso un token di pagamento che viene registrato contestualmente alla creazione
     * della riga di pagamento.
     * 
     * 
     */

    // inclusione del framework
	require '../../../../_src/_config.php';

    // decodifica dati in ingresso
    $dati = json_decode( file_get_contents('php://input'), true );

    // log
    logger( 'dati in ingresso: ' . print_r( $dati, true ), 'details/paypal-advanced/order-api' );

    // se il pagamento è vuoto provo a crearlo al volo
    if( ! isset( $dati['id'] ) || empty( $dati['id'] ) ) {

        // se ho una riga di carrello cui fare riferimento
        if( isset( $dati['id_carrelli_articoli'] ) && ! empty( $dati['id_carrelli_articoli'] ) ) {

            // cerco la riga di carrello
            $riga = mysqlSelectRow(
                $cf['mysql']['connection'],
                'SELECT * FROM carrelli_articoli WHERE id = ?',
                array( array( 's' => $dati['id_carrelli_articoli'] ) )
            );

            // se la riga esiste
            if( isset( $riga['id'] ) ) {

                // ID del pagamento
                $dati['id'] = mysqlInsertRow(
                    $cf['mysql']['connection'],
                    array(
                        'id_creditore' => trovaIdAziendaGestita(),
                        'id_debitore' => $_SESSION['account']['id_anagrafica'],
                        'nome' => 'pagamento creato al volo per riga di carrelli articoli #' . $riga['id'],
                        'token_pagamento' => $dati['token_pagamento'],
                        'id_carrelli_articoli' => $riga['id'],
                        'importo_lordo_totale' => $riga['prezzo_lordo_finale']
                    ),
                    'pagamenti'
                );

                // importo del pagamento
                $dati['importo_lordo_totale'] = $riga['prezzo_lordo_finale'];

            }

        }

    } elseif( isset( $dati['id'] ) && ! empty( $dati['id'] ) ) {

        // registro il token di pagamento
        mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE pagamenti SET token_pagamento = ? WHERE id = ?',
            array( array( 's' => $dati['token_pagamento'] ), array( 's' => $dati['id'] ) )
        );

        // cerco la riga di pagamento
        $dati = array_replace_recursive(
            $dati,
            mysqlSelectRow(
                $cf['mysql']['connection'],
                'SELECT * FROM pagamenti WHERE id = ?',
                array( array( 's' => $dati['id'] ) )
            )
        );

    }

    // verifico che esista un carrello
    if( isset( $dati['id'] ) ) {

        // log
        logger( 'dati del pagamento: ' . print_r( $dati, true ), 'details/paypal-advanced/order-api' );

        // nome del file di ricevuta
        $fileRicevuta = DIR_VAR_SPOOL_PAYMENT . 'details/paypal-advanced/pagamenti.' . sprintf( '%08d', $dati['id'] ) . '.log';

        // dati dell'ordine
        $order = array(
            'intent' => 'CAPTURE',
            'purchase_units' => array(
                array(
                    'amount' => array(
                        'currency_code' => 'EUR',
                        'value' => number_format( ( float ) $dati['importo_lordo_totale'], 2, '.', '' )
                    )
                )
            )
        );

        // creo l'ordine
        $result = restCall(
            $cf['paypal']['profile']['order_api'],
            METHOD_POST,
            $order,
            MIME_APPLICATION_JSON,
            MIME_APPLICATION_JSON,
            $status,
            array(),
            NULL,
            NULL,
            $error,
            paypalAdvancedGetAccessToken( $cf['paypal']['profile'] )
        );

        // log
        logger( 'esito creazione ordine: ' . print_r( $result, true ), 'details/paypal-advanced/capture-api' );

        // log
        appendToFile( 'esito creazione ordine: ' . print_r( $result, true ), $fileRicevuta );

        // dati di pagamento
        $order = array(
            'id'						=> $dati['id'],
            'ordine_pagamento'			=> $result['id'],
        );

        // registro il pagamento
        mysqlInsertRow(
            $cf['mysql']['connection'],
            $order,
            'pagamenti'
        );

        // debug
        // print_r( $result );
        // print_r( $status );
        // print_r( $error );

        buildJson(
            array( 'id' => $result['id'] )
        );
            
    }
