<?php

    /**
     * 
     * https://developer.paypal.com/docs/api/orders/v2/#orders_capture
     * 
     * curl -v -X POST https://api-m.sandbox.paypal.com/v2/checkout/orders/5O190127TN364715T/capture \
     * -H "Content-Type: application/json" \
     * -H "Authorization: Bearer Access-Token" \
     * -H "PayPal-Request-Id: 7b92603e-77ed-4896-8e78-5dea2050476a"
     * 
     */

    // inclusione del framework
	require '../../../../_src/_config.php';

    // debug
    print_r( $_SESSION['carrello'] );
    print_r( $_REQUEST );

    // ID dell'ordine per la cattura del pagamento
    if( isset( $_REQUEST['id'] ) ) {

        $result = restCall(
            'https://api-m.sandbox.paypal.com/v2/checkout/orders/'.$_REQUEST['id'].'/capture',  // TODO leggere dalla configurazione
            METHOD_POST,
            NULL,
            MIME_APPLICATION_JSON,
            MIME_APPLICATION_JSON,
            $status,
            array(
                'PayPal-Request-Id' => $_SESSION['carrello']['id']
            ),
            NULL,
            NULL,
            $error,
            paypalAdvancedGetAccessToken( $cf['ecommerce']['profile']['provider']['paypal-advanced'] )
        );

        // debug
        // print_r( $cf['ecommerce']['profile']['provider']['paypal-advanced'] );
        // print_r( $result );
        // print_r( $status );
        // print_r( $error );

        // TODO verificare che il pagamento sia andato a buon fine qui
        // $result[purchase_units][0][payments][captures][0][status] == COMPLETED

        // TODO loggare l'intera risposta nel file txt del carrello

        // TODO implementare le chiamate alle controller di successo

        // TODO settare come URL di redirect l'URL della pagina di successo

        // TODO in caso di fallimento settare come URL di redirect l'URL della pagina di errore

    } else {

        // TODO settare come URL di redirect l'URL della pagina di errore

    }

    // TODO restituire l'URL di redirect
