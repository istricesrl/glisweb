<?php

    // inclusione del framework
	require '../../../../_src/_config.php';

    // identificativo del carrello
	if( isset( $_REQUEST['codTrans'] ) ) {

		// normalizzazione ID carrello
		$idCarrello = $_REQUEST['codTrans'];

		// nome del file di ricevuta
		$fileRicevuta = DIR_VAR_SPOOL_PAYMENT . 'paypal/' . sprintf( '%08d', $_REQUEST['codTrans'] ) . '.log';

		// log
		appendToFile( date( 'Y-m-d H:i:s' ) . ' ricevuta comunicazione IPN' . PHP_EOL, $fileRicevuta );
		appendToFile( print_r( $_REQUEST, true ), $fileRicevuta );

		// controllo campi obbligatori
		$missingFields = array_diff( array( 'codTrans', 'alias', 'mac', 'importo', 'divisa', 'esito', 'codAut', 'messaggio' ), array_keys( $_REQUEST ) );

		// se i campi necessari sono tutti presenti...
		if( count( $missingFields ) === 0 ) {

			// comportamento secondo l'esito
			switch( $_REQUEST['esito'] ) {

				// pagamento completato con successo
				case 'OK':

					// registro il pagamento
					mysqlInsertRow(
						$cf['mysql']['connection'],
						array(
							'id'						=> $_REQUEST['codTrans'],
							'session'					=> NULL,
							'provider_checkout'			=> basename( __FILE__ ),
							'timestamp_checkout'		=> time(),
							'timestamp_pagamento'		=> time(),
							'codice_pagamento'			=> $_REQUEST['codAut'],
							'importo_pagamento'			=> ( $_REQUEST['importo'] / 100 ),
							'status_pagamento'			=> $_REQUEST['esito']
						),
						'carrelli'
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
					logWrite( 'pagamento effettuato con successo per il carrello ' . $_REQUEST['codTrans'], 'paypal', LOG_INFO );

				break;

				// pagamento non completato
				default:

					// registro il fallimento del pagamento
					mysqlInsertRow(
						$cf['mysql']['connection'],
						array(
							'id'						=> $_REQUEST['codTrans'],
							'status_pagamento'			=> $_REQUEST['esito']
						),
						'carrelli'
					);

					// log
					logWrite( 'pagamento non completato per il carrello ' . $_REQUEST['codTrans'], 'paypal', LOG_ERR );
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
