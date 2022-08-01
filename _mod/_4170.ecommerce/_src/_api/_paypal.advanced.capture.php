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
    // print_r( $_SESSION['carrello'] );
    // print_r( $_REQUEST );

    // inizializzazione status
    $result = array();

    // ID dell'ordine per la cattura del pagamento
    if( isset( $_REQUEST['id'] ) ) {

		// normalizzazione ID carrello
		$idCarrello = $_SESSION['carrello']['id'];

        // nome del file di ricevuta
        $fileRicevuta = DIR_VAR_SPOOL_PAYMENT . 'paypal/' . sprintf( '%08d', $_SESSION['carrello']['id'] ) . '.log';

        // chiamata
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

        // log
        appendToFile( 'esito cattura pagamento: ' . print_r( $result, true ), $fileRicevuta );

        // URL di ritorno
        if( $result['purchase_units'][0]['payments']['captures'][0]['status'] == 'COMPLETED' ) {

            // dati di pagamento
            $payment = array(
                'id'						=> $_SESSION['carrello']['id'],
                'session'					=> NULL,
                'provider_checkout'			=> basename( __FILE__ ),
                'timestamp_checkout'		=> time(),
                'timestamp_pagamento'		=> time(),
                'codice_pagamento'			=> $result['purchase_units'][0]['payments']['captures'][0]['id'],
                'importo_pagamento'			=> $result['purchase_units'][0]['payments']['captures'][0]['amount']['value'],
                'status_pagamento'			=> $result['purchase_units'][0]['payments']['captures'][0]['status']
            );

            // registro il pagamento
            mysqlInsertRow(
                $cf['mysql']['connection'],
                $payment,
                'carrelli'
            );

            // aggiorno la $_SESSION
            $_SESSION['carrello'] = array_replace_recursive(
                $_SESSION['carrello'],
                $payment
            );

            // controller post checkout
            $cnts = glob( glob2custom( DIR_MOD_ATTIVI . '_src/_inc/_controllers/_checkout.finally.success.php' ), GLOB_BRACE );

            // log
            appendToFile( 'controller post checkout trovate: ' . print_r( $cnts, true ), $fileRicevuta );

            // inclusione delle controller post checkout
            foreach( $cnts as $cnt ) {
                require $cnt;
            }

            // log
            logWrite( 'pagamento effettuato con successo per il carrello ' . $_SESSION['carrello']['id'], 'paypal', LOG_INFO );

            // URL di redirect in caso di successo
            $result['return'] = $cf['contents']['pages'][ $cf['ecommerce']['profile']['provider']['paypal-advanced']['return'] ]['url']['it-IT'];

        } else {

            // TODO in caso di fallimento settare come URL di redirect l'URL della pagina di errore
            $result['return'] = 'https://www.libero.it';

        }

    } else {

        // TODO settare come URL di redirect l'URL della pagina di errore

    }

    // TODO restituire l'URL di redirect
    buildJson( $result );
