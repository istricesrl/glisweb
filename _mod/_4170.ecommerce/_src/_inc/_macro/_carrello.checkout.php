<?php

    /**
     * NOTA
     * - gestire il checkout diretto (contrassegno e bonifico eccetera)
     */

    // se esiste un carrello in sessione
    if( isset( $_SESSION['carrello']['id'] ) ) {

		// nome del file di ricevuta
		$fileRicevuta = DIR_VAR_SPOOL_PAYMENT . 'paypal/' . sprintf( '%08d', $_SESSION['carrello']['id'] ) . '.log';

        // imposto la timestamp di checkout
        $_SESSION['carrello']['timestamp_checkout'] = time();
        $_SESSION['carrello']['provider_checkout'] = basename( __FILE__ );

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

        // controller post checkout
        $cnts = glob( glob2custom( DIR_BASE . '_mod/_4170.ecommerce/_src/_inc/_controllers/_checkout.finally.success.php' ), GLOB_BRACE );

        // log
        appendToFile( 'controller post checkout trovate: ' . print_r( $cnts, true ), $fileRicevuta );

        // inclusione delle controller post checkout
        foreach( $cnts as $cnt ) {
            require $cnt;
        }

        // log
        logWrite( 'checkout effettuato con successo per il carrello ' . $_SESSION['carrello']['id'], 'paypal', LOG_INFO );

    }
