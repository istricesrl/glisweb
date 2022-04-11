<?php

    /**
     * NOTA
     * - gestire URL di ritorno di PayPal tipo https://glisweb.istricesrl.it/_usr/_examples/_ecommerce/_esito.ok.php?PayerID=HHTWUL4BQHKH8
     * - gestire URL di ritorno di Nexi tipo 
     */

	 // se esiste un carrello in sessione
     if( isset( $_SESSION['carrello']['id'] ) ) {

        // inizializzazione esito pagamento
        $ct['etc']['esito'] = NULL;

        // imposto la timestamp di checkout
        $_SESSION['carrello']['timestamp_checkout'] = time();
        $_SESSION['carrello']['provider_checkout'] = basename( __FILE__ );

        // gestione esito
        if( isset( $_REQUEST['codTrans'] ) ) {

            // Nexi
            if( isset( $_REQUEST['esito'] ) && $_REQUEST['esito'] == 'OK' ) {
                $ct['etc']['esito'] = 1;
            } else {
                $ct['etc']['esito'] = 0;
            }

            // nome del file di ricevuta
            $fileRicevuta = DIR_VAR_SPOOL_PAYMENT . 'nexi/' . sprintf( '%08d', $_SESSION['carrello']['id'] ) . '.log';

            // log
            appendToFile( 'esito: ' . $ct['etc']['esito'], $fileRicevuta );

        } elseif( isset( $_REQUEST['item_number'] ) ) {

            // PayPal VECCHIO
            if( isset( $_REQUEST['payment_status'] ) && $_REQUEST['payment_status'] == 'Completed' ) {
                $ct['etc']['esito'] = 1;
            } else {
                $ct['etc']['esito'] = 0;
            }

            // nome del file di ricevuta
            $fileRicevuta = DIR_VAR_SPOOL_PAYMENT . 'paypal/' . sprintf( '%08d', $_SESSION['carrello']['id'] ) . '.log';

            // log
            appendToFile( 'esito: ' . $ct['etc']['esito'], $fileRicevuta );

        } elseif( isset( $_REQUEST['PayerID'] ) ) {

            // PayPal NUOVO
            // TODO leggere dal carrello $_SESSION['carrello']['id'] per vedere se il pagamento è andato a buon fine
            // oppure no, o eventualmente se non è ancora arrivato (in questo caso dare $ct['etc']['esito'] = 2)
            
        }

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

    }

    // debug
    // var_dump( $_SESSION['carrello']['id'] );
