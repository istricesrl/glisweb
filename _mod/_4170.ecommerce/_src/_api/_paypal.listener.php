<?php

    // inclusione del framework
	require '../../../../_src/_config.php';

    // identificativo del carrello
	if( isset( $_REQUEST['item_number'] ) ) {

		// normalizzazione ID carrello
		$idCarrello = $_REQUEST['item_number'];

		// nome del file di ricevuta
		$fileRicevuta = DIR_VAR_SPOOL_PAYMENT . 'paypal/' . sprintf( '%08d', $_REQUEST['item_number'] ) . '.log';

		// log
		appendToFile( date( 'Y-m-d H:i:s' ) . ' ricevuta comunicazione IPN' . PHP_EOL, $fileRicevuta );
		appendToFile( print_r( $_REQUEST, true ), $fileRicevuta );

		// controllo campi obbligatori
		$missingFields = array_diff( array( 'item_number', 'payment_status', 'mc_gross' ), array_keys( $_REQUEST ) );

		// se i campi necessari sono tutti presenti...
		if( count( $missingFields ) === 0 ) {

			// comportamento secondo l'esito
			switch( $_REQUEST['payment_status'] ) {

				// pagamento completato con successo
				case 'Completed':

					// registro il pagamento
					mysqlInsertRow(
						$cf['mysql']['connection'],
						array(
							'id'						=> $_REQUEST['item_number'],
							'session'					=> NULL,
							'provider_checkout'			=> basename( __FILE__ ),
							'timestamp_checkout'		=> time(),
							'timestamp_pagamento'		=> time(),
							'codice_pagamento'			=> $_REQUEST['txn_id'],
							'ordine_pagamento'			=> $_REQUEST['payer_id'],
							'importo_pagamento'			=> $_REQUEST['mc_gross'],
							'status_pagamento'			=> $_REQUEST['payment_status']
						),
						'carrelli'
					);

					// controller post checkout
					$cnts = glob( glob2custom( DIR_MOD_ATTIVI . '_src/_inc/_controllers/_checkout.finally.success.php' ), GLOB_BRACE );

					// ordinamento delle controller
					sort( $cnts );

					// log
					appendToFile( 'controller post checkout trovate: ' . print_r( $cnts, true ), $fileRicevuta );

					// inclusione delle controller post checkout
					foreach( $cnts as $cnt ) {
						require $cnt;
					}

					// log
					logWrite( 'pagamento effettuato con successo per il carrello ' . $_REQUEST['item_number'], 'paypal', LOG_INFO );

				break;

				// pagamento non completato
				default:

					// registro il fallimento del pagamento
					mysqlInsertRow(
						$cf['mysql']['connection'],
						array(
							'id'						=> $_REQUEST['item_number'],
							'status_pagamento'			=> $_REQUEST['payment_status']
						),
						'carrelli'
					);

					// controller post checkout
					$cnts = glob( glob2custom( DIR_MOD_ATTIVI . '_src/_inc/_controllers/_checkout.finally.failure.php' ), GLOB_BRACE );

					// ordinamento delle controller
					sort( $cnts );

					// log
					appendToFile( 'controller post checkout trovate: ' . print_r( $cnts, true ), $fileRicevuta );

					// inclusione delle controller post checkout
					foreach( $cnts as $cnt ) {
						require $cnt;
					}

					// log
					logWrite( 'pagamento non completato per il carrello ' . $_REQUEST['item_number'], 'paypal', LOG_ERR );
					appendToFile( 'pagamento non completato' . PHP_EOL, $fileRicevuta );

				break;

			}

		} else {

			// log
			appendToFile( 'campi mancanti: ' . print_r( $missingFields, true ), $fileRicevuta );
			
		}

	} else {

	    // log
		logWrite( 'item_number mancante', 'paypal', LOG_ERR );

	}
