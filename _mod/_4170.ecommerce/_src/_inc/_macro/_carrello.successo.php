<?php

    /**
     * NOTA
     * - gestire URL di ritorno di Nexi
     */

	 // se esiste un carrello in sessione
    if( isset( $_SESSION['carrello']['id'] ) ) {

		// nome del file di ricevuta
		$fileRicevuta = DIR_VAR_SPOOL_PAYMENT . 'nexi/' . sprintf( '%08d', $_SESSION['carrello']['id'] ) . '.log';

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

        // log
        logWrite( 'checkout effettuato con successo per il carrello ' . $_SESSION['carrello']['id'], 'paypal', LOG_INFO );

    }
