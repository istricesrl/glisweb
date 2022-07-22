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

    // dati dell'ordine
    $order = array(
        'intent' => 'CAPTURE',
        'purchase_units' => array(
            array(
                'amount' => array(
                    'currency_code' => 'EUR',
                    'value' => $_SESSION['carrello']['prezzo_lordo_finale']
                )
            )
        )
    );

    // creo l'ordine
    $result = restCall(
        'https://api-m.sandbox.paypal.com/v2/checkout/orders',  // TODO leggere dalla configurazione
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

    // TODO loggare tutto

    // debug
    // print_r( $result );
    // print_r( $status );
    // print_r( $error );

    buildJson(
        array( 'id' => $result['id'] )
    );
