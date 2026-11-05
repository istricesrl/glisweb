<?php

    /**
     * 
     * curl -v -X POST https://api-m.sandbox.paypal.com/v2/checkout/orders \
     * -H "Content-Type: application/json" \
     * -H "Authorization: Bearer Access-Token" \
     * -d '{
     *   "intent": "CAPTURE",
     *   "purchase_units": [
     *     {
     *       "amount": {
     *         "currency_code": "USD",
     *         "value": "100.00"
     *       }
     *     }
     *   ]
     * }'
     * 
     */

    // inclusione del framework
	require '../../../../_src/_config.php';

    // debug
    // print_r( $_SESSION['carrello'] );
    // print_r( $cf['ecommerce']['profile']['provider']['paypal-advanced'] );

    // verifico che esista un carrello
    if( isset( $_SESSION['carrello']['id'] ) ) {

        // nome del file di ricevuta
        $fileRicevuta = DIR_VAR_SPOOL_PAYMENT . 'paypal/' . sprintf( '%08d', $_SESSION['carrello']['id'] ) . '.log';

        /**
         * Fix 2026-09-01: identificativi nostri dentro l'ordine PayPal.
         *
         * L'ordine viaggiava con il solo importo. Chi paga con **carta** (Advanced Checkout,
         * flusso guest) non ha un conto PayPal, quindi nel dettaglio della transazione PayPal
         * non compare nessun dato del pagante e in segreteria diventa impossibile abbinare
         * l'incasso alla persona: si vede solo "Pagamenti diretti con carta", l'importo e
         * "non e' presente un indirizzo di spedizione". Col conto PayPal il problema non si
         * pone perche' i dati del titolare arrivano da PayPal.
         *
         * La soluzione sta dalla nostra parte: `custom_id` e `invoice_id` tornano nel dettaglio
         * transazione, nell'export CSV e nei webhook, e `description` e' quello che il pagante
         * legge. `reference_id` serve a ritrovare la purchase unit in fase di capture.
         *
         * `invoice_id` NON viene valorizzato di proposito: PayPal lo vuole univoco sull'account
         * e rifiuta un ordine il cui invoice_id appartiene a un pagamento gia' completato, cosa
         * che succederebbe a ogni ritentativo sullo stesso carrello. `custom_id` non ha questo
         * vincolo ed e' altrettanto visibile nell'export.
         */

        // riferimenti nostri da allegare all'ordine
        $riferimenti = array( 'carrello:' . $_SESSION['carrello']['id'] );

        if( ! empty( $_SESSION['carrello']['intestazione_id_anagrafica'] ) ) {
            $riferimenti[] = 'anagrafica:' . $_SESSION['carrello']['intestazione_id_anagrafica'];
        }

        if( ! empty( $_SESSION['carrello']['intestazione_id_account'] ) ) {
            $riferimenti[] = 'account:' . $_SESSION['carrello']['intestazione_id_account'];
        }

        // descrizione leggibile: la vede il pagante e finisce nel dettaglio transazione
        $descrizione = ( isset( $cf['site']['name'][ $cf['localization']['language']['ietf'] ] ) )
            ? $cf['site']['name'][ $cf['localization']['language']['ietf'] ]
            : $cf['site']['fqdn'];

        $descrizione .= ' - ordine ' . $_SESSION['carrello']['id'];

        // importo dell'ordine: quello che il carrello vale nel database, che è quello che i post-hook della cattura
        // registrano, e non la testata in sessione ( vedi importoOrdineCarrello() )
        $importo = importoOrdineCarrello( $cf['mysql']['connection'], $_SESSION['carrello']['id'] );

        // la testata in sessione non torna con il database: si manda il database, e si scrive perché
        if( round( (float) $_SESSION['carrello']['prezzo_lordo_finale'], 2 ) != $importo ) {
            logWrite( 'ordine PayPal del carrello ' . $_SESSION['carrello']['id'] . ': testata in sessione ' . $_SESSION['carrello']['prezzo_lordo_finale'] . ' EUR, righe nel database ' . var_export( $importo, true ) . ' EUR, mando le righe', 'paypal', LOG_WARNING );
        }

        // cintura di sicurezza: un carrello che non c'è o che non vale niente non si manda a PayPal
        if( (float) $importo <= 0 ) {
            appendToFile( 'ordine non creato: importo del carrello ' . var_export( $importo, true ), $fileRicevuta );
            buildJson( array( 'id' => NULL, 'skipped' => 'zero_amount' ) );
            return;
        }

        // dati dell'ordine
        $order = array(
            'intent' => 'CAPTURE',
            'purchase_units' => array(
                array(
                    'reference_id' => (string) $_SESSION['carrello']['id'],
                    'custom_id' => substr( implode( '|', $riferimenti ), 0, 127 ),
                    'description' => substr( $descrizione, 0, 127 ),
                    'amount' => array(
                        'currency_code' => 'EUR',
                        'value' => number_format( $importo, 2, '.', '' )
                    )
                )
            )
        );

        // creo l'ordine
        $result = restCall(
            $cf['ecommerce']['profile']['provider']['paypal-advanced']['order_api'],
            METHOD_POST,
            $order,
            MIME_APPLICATION_JSON,
            MIME_APPLICATION_JSON,
            $status,
            array(),
            NULL,
            NULL,
            $error,
            paypalAdvancedGetAccessToken( $cf['ecommerce']['profile']['provider']['paypal-advanced'] )
        );

        // log
        appendToFile( 'esito creazione ordine: ' . print_r( $result, true ), $fileRicevuta );

        // dati di pagamento: con l'ordine si registra anche la cifra mandata a PayPal, che la cattura confronta con quello
        // che il carrello vale in quel momento ( verificaImportoOrdineCarrello() ); la cattura la sostituisce con l'incassato
        $order = array(
            'id'						=> $_SESSION['carrello']['id'],
            'ordine_pagamento'			=> $result['id'],
            'importo_pagamento'			=> number_format( $importo, 2, '.', '' )
        );

        // registro il pagamento
        mysqlInsertRow(
            $cf['mysql']['connection'],
            $order,
            'carrelli'
        );

        // aggiorno la $_SESSION
        $_SESSION['carrello'] = array_replace_recursive(
            $_SESSION['carrello'],
            $order
        );

        // debug
        // print_r( $result );
        // print_r( $status );
        // print_r( $error );

        // log
        // logWrite( print_r( $result, true ), 'details/paypal-advanced/listener/order', LOG_ERR );

        buildJson(
            array( 'id' => $result['id'] )
        );
            
    }
