<?php

    /**
     * NOTA
     * - gestire URL di ritorno di PayPal tipo https://glisweb.istricesrl.it/_usr/_examples/_ecommerce/_esito.ok.php?PayerID=HHTWUL4BQHKH8
     * - gestire URL di ritorno di Nexi tipo 
     */

    // debug
    // echo '<pre>' . print_r( $_REQUEST, true ) . '</pre>';

    // se esiste un carrello in sessione
    // if( isset( $_SESSION['carrello']['id'] ) ) {

        // inizializzazione esito pagamento
        $ct['etc']['esito'] = NULL;

        // imposto la timestamp di checkout
//        $_SESSION['carrello']['timestamp_checkout'] = time();
//        $_SESSION['carrello']['provider_checkout'] = basename( __FILE__ );

        // gestione esito
        if( isset( $_REQUEST['codTrans'] ) ) {

            // Nexi
            if( isset( $_REQUEST['esito'] ) && $_REQUEST['esito'] == 'OK' ) {
                $ct['etc']['esito'] = 1;
            } else {
                $ct['etc']['esito'] = 0;
            }

            // TODO arriva una roba del tipo:
            // https://glisweb.istricesrl.it/carrello/esito-ordine.it-IT.html?xpay__lb__token=&mail=fabio.mosti%40gmail.com&data=20240806&messaggio=Message+OK&cognome=sdfg&nazionalita=ITA&regione=&mac=89face5a31fd85ab71aab626f76d4a8c8920a648&codAut=APCH4S&tipoProdotto=VISA+CLASSIC+-+CREDIT+-+N&selectedcard=&alias=ALIAS_WEB_00012722&pan=453997******0006&brand=VISA&orario=190014&divisa=EUR&scadenza_pan=203012&importo=12200&codiceEsito=0&languageId=ITA&nome=sdfg&check=&tipoTransazione=VBV_FULL&codiceConvenzione=00012722104&codTrans=328&esito=OK&aliasEffettivo=&OPTION_CF=&num_contratto=
            // bisogna fare un controllino un po' più di fino sull'esito

            // nome del file di ricevuta
//            $fileRicevuta = DIR_VAR_SPOOL_PAYMENT . 'nexi/' . sprintf( '%08d', $_SESSION['carrello']['id'] ) . '.log';

            // log
//            appendToFile( 'esito: ' . $ct['etc']['esito'], $fileRicevuta );
/*
        } elseif( ! empty( $_REQUEST['PaymentID'] ) ) {

            // Nexi nuovo

            // TODO controllare 'sto paymentid sulla tabella carrelli e chiamando l'order api
            // https://developer.nexi.it/it/api/get-orders-orderId bisogna creare una funzione tipo nexiGetOrderDetails()
            if( true ) {
                $ct['etc']['esito'] = 1;
            } else {
                $ct['etc']['esito'] = 0;
            }
*/
        } elseif( ! empty( $_REQUEST['PayerID'] ) ) {

            // recupero il carrello
            $carrello = mysqlSelectRow(
                $cf['mysql']['connection'],
                'SELECT * FROM carrelli WHERE ordine_pagamento = ?',
                array( array( 's' => $_REQUEST['PayerID'] ) )
            );

            // debug
            // echo '<pre>' . print_r( $carrello, true ) . '</pre>';

            // PayPal VECCHIO
            if( isset( $carrello['status_pagamento'] ) && $carrello['status_pagamento'] == 'Completed' ) {
                $ct['etc']['esito'] = 1;
            } else {
                $ct['etc']['esito'] = 2;
            }

            // TODO in produzione l'IPN listener di PayPal è lento, e a volte il cliente torna alla pagina
            // di esito prima che il codice di pagamento e lo status di pagamento vengano scritti, quindi
            // conviene qui verificare solo che esista il PayerID oppure la verifica farla con un piccolo
            // delay oppure con una chiamata Ajax al back end

            // TODO implementare il caso in cui il pagamento fallisce

            // nome del file di ricevuta
//            $fileRicevuta = DIR_VAR_SPOOL_PAYMENT . 'paypal/' . sprintf( '%08d', $_SESSION['carrello']['id'] ) . '.log';

            // log
//            appendToFile( 'esito: ' . $ct['etc']['esito'], $fileRicevuta );

        } elseif( isset( $_REQUEST['idOrdine'] ) ) {

            // PayPal NUOVO
            // TODO leggere dal carrello $_SESSION['carrello']['id'] per vedere se il pagamento è andato a buon fine
            // oppure no, o eventualmente se non è ancora arrivato (in questo caso dare $ct['etc']['esito'] = 2)

            // recupero il carrello
            $carrello = mysqlSelectRow(
                $cf['mysql']['connection'],
                'SELECT * FROM carrelli WHERE ordine_pagamento = ?',
                array( array( 's' => $_REQUEST['idOrdine'] ) )
            );

            // debug
            // echo '<pre>' . print_r( $carrello, true ) . '</pre>';

            // esito
            if( isset( $carrello['status_pagamento'] ) && $carrello['status_pagamento'] == 'COMPLETED' ) {
                $ct['etc']['esito'] = 1;
            } else {
                $ct['etc']['esito'] = 0;
            }

        } elseif( ! empty( $_REQUEST['paymentid'] ) ) {

            // Nexi nuovo

            // debug
            // echo 'NEXINUOVO';

            // recupero il carrello
            $carrello = mysqlSelectRow(
                $cf['mysql']['connection'],
                'SELECT * FROM carrelli WHERE ordine_pagamento = ?',
                array( array( 's' => $_REQUEST['paymentid'] ) )
            );

            // debug
            // echo '<pre>' . print_r( $carrello, true ) . '</pre>';

            // esito
            if( isset( $carrello['status_pagamento'] ) && in_array( $carrello['status_pagamento'], array( 'APPROVED', 'CAPTURED', 'EXECUTED' ) ) ) {
                $ct['etc']['esito'] = 1;
            } else {
                $ct['etc']['esito'] = 0;
            }

        } elseif( ! empty( $_REQUEST['PaymentID'] ) ) {

            // Monetaweb

            // debug
            // echo 'MONETAWEB';

            // recupero il carrello
            $carrello = mysqlSelectRow(
                $cf['mysql']['connection'],
                'SELECT * FROM carrelli WHERE id = ?',
                array( array( 's' => $_REQUEST['PaymentID'] ) )
            );

            // esito
            if( isset( $carrello['status_pagamento'] ) && in_array( $carrello['status_pagamento'], array( 'APPROVED', 'CAPTURED', 'EXECUTED' ) ) ) {
                $ct['etc']['esito'] = 1;
            } else {
                $ct['etc']['esito'] = 0;
            }

        }

/*
        // se il checkout è andato a buon fine
        if( $ct['etc']['esito'] === 1 ) {

            // registro il checkout
            mysqlInsertRow(
                $cf['mysql']['connection'],
                array(
                    'id'						=> $_SESSION['carrello']['id'],
                    'provider_checkout'			=> $_SESSION['carrello']['provider_checkout'],
                    'timestamp_checkout'		=> $_SESSION['carrello']['timestamp_checkout']
                ),
                'carrelli'
            );
    
            // log
            logWrite( 'checkout effettuato con successo per il carrello ' . $_SESSION['carrello']['id'], 'paypal', LOG_INFO );
    
        }
*/

    // }

    // debug
    // var_dump( $_SESSION['carrello']['id'] );
