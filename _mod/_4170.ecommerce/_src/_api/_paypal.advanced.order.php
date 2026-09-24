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
                        'value' => number_format( ( float) $_SESSION['carrello']['prezzo_lordo_finale'], 2, '.', '' )
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

        // dati di pagamento
        $order = array(
            'id'						=> $_SESSION['carrello']['id'],
            'ordine_pagamento'			=> $result['id'],
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
