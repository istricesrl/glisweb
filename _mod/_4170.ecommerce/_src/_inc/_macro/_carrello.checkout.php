<?php

    /**
     * NOTA
     * - gestire il checkout diretto (contrassegno e bonifico eccetera)
     */

    // se esiste un carrello in sessione
    if( isset( $_SESSION['carrello']['id'] ) ) {

		// normalizzazione ID carrello
		$idCarrello = $_SESSION['carrello']['id'];

        // nome del file di ricevuta
		$fileRicevuta = DIR_VAR_SPOOL_PAYMENT . 'diretti/' . sprintf( '%08d', $_SESSION['carrello']['id'] ) . '.log';

        // imposto la timestamp di checkout
        $_SESSION['carrello']['timestamp_checkout'] = time();
        $_SESSION['carrello']['provider_checkout'] = basename( __FILE__ );

        // registro il checkout
        $ct['etc']['esito'] = mysqlInsertRow(
            $cf['mysql']['connection'],
            array(
                'id'						=> $_SESSION['carrello']['id'],
                'session'					=> NULL,
                'provider_checkout'			=> $_SESSION['carrello']['provider_checkout'],
                'timestamp_checkout'		=> $_SESSION['carrello']['timestamp_checkout']
            ),
            'carrelli'
        );

        // controller post checkout
        $cnts = glob( glob2custom( DIR_MOD_ATTIVI . '_src/_inc/_controllers/_checkout.finally.success.php' ), GLOB_BRACE );

        // debug
        // die( print_r( $cnts ) );

        // log
        appendToFile( 'checkout diretto: ' . $_SESSION['carrello']['provider_checkout'] . '/' . $_SESSION['carrello']['timestamp_checkout'] . PHP_EOL, $fileRicevuta );
        appendToFile( 'controller post checkout trovate: ' . print_r( $cnts, true ), $fileRicevuta );

        // inclusione delle controller post checkout
        foreach( $cnts as $cnt ) {
            require $cnt;
        }

        // log
        logWrite( 'checkout effettuato con successo per il carrello ' . $_SESSION['carrello']['id'], 'ecommerce', LOG_INFO );

    }
