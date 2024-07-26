<?php

    /**
     * 
     * 
     * 
     * 
     * 
     * campi attesi
     * ------------
     * 
     * 
     * campo                        | descrizione                               | carrello
     * -----------------------------|-------------------------------------------|---------------------------------------
	 * $_REQUEST['paymentid']       | PaymentID generato da Setefi              | viene salvato in ordine_pagamento
	 * $_REQUEST['result']          | esito del pagamento (vedi sotto)          | viene salvato in status_pagamento
	 * $_REQUEST['auth']            | codice di autorizzazione del pagamento    | viene salvato in codice_pagamento
	 * $_REQUEST['ref']             | riferimento della transazione             | 
	 * $_REQUEST['tranid']          | identificativo della transazione          | 
	 * $_REQUEST['trackid']         | ID del carrello                           | viene salvato in id
	 * $_REQUEST['udf1']            | descrizione del pagamento                 | 
	 * $_REQUEST['udf2']            | nome titolare e indirizzo mail            | 
	 * $_REQUEST['udf3']            | primi 8 numeri del pan carta              |
	 * $_REQUEST['udf4']            | campo riservato                           |
	 * $_REQUEST['udf5']            | RRN scambiato con i Circuiti              |
	 * $_REQUEST['responsecode']    | codice di risposta (vedi sotto)           | 
     * 
     * 
	 * nuova versione
	 * 
     * [authorizationcode] => 123456
     * [baseamount] => 122.00
     * [basecurrency] => 978
     * [cardcountry] => ITALY
     * [cardexpirydate] => 1230
     * [cardtype] => MONETA
     * [customfield] => 
     * [globaloid] => MD9BF09589A1FEEA407EA88F1A06B0A
     * [maskedpan] => 434994******0906
     * [merchantcustomercode] => 
     * [merchantorderid] => 300
     * [merchanttransactioncode] => 300
     * [paymentid] => 776804944410842089
     * [responsecode] => 000
     * [result] => APPROVED
     * [rrn] => 000000000000
     * [securitytoken] => 27877fa189894df4ab04398594543bc8
     * [threedsecure] => N
	 * 
	 * 
     * 
     * 
     * valore                       | descrizione
     * -----------------------------|-------------------------------------------
     * APPROVED                     | transazione autorizzata (contabilizzazione esplicita)
     * NOT APPROVED                 | transazione non autorizzata
     * CAPTURED                     | transazione autorizzata e confermata (contabilizzazione implicita)
     * CANCELED                     | transazione cancellata dal titolare carta
     * HOST TIMEOUT                 | il Sistema Autorizzativo non ha risposto entro il limite di timeout
     * 
     * 
     * 
     * valore                       | descrizione
     * -----------------------------|-------------------------------------------
     * 00                           | transazione autorizzata e confermata (contabilizzazione implicita)
     * 000                          | transazione autorizzata e confermata (contabilizzazione esplicita)
     * qualsiasi altro valore       | transazione non autorizzata
     * 
     * 
     * 
     * redirezione da parte di Monetaweb
     * ---------------------------------
     * Dopo aver comunicato con il listener, Monetaweb reindirizza l'utente all'URL indicato nell'output
     * del listener stesso, con un semplice testo chiave valore che specifica il parametro "redirect"
     * che contiene l'URL di destinazione.
     * 
     * 
     * 
     * 
     */

    // inclusione del framework
	require '../../../../_src/_config.php';

	// log
	logger( 'attivato IPN listener per Monetaweb, dati ricevuti: ' . print_r( $_REQUEST, true ), 'monetaweb' );

	// riallineamento alla nuova versione
	$_REQUEST['auth'] = ( ! empty( $_REQUEST['auth'] ) ) ? $_REQUEST['auth'] : $_REQUEST['authorizationcode'];
	$_REQUEST['tranid'] = ( ! empty( $_REQUEST['tranid'] ) ) ? $_REQUEST['tranid'] : $_REQUEST['rrn'];
	$_REQUEST['trackid'] = ( ! empty( $_REQUEST['trackid'] ) ) ? $_REQUEST['trackid'] : $_REQUEST['merchantorderid'];
	$_REQUEST['ref'] = ( ! empty( $_REQUEST['ref'] ) ) ? $_REQUEST['ref'] : $_REQUEST['securitytoken'];

	// identificativo del carrello
	if( isset( $_REQUEST['trackid'] ) ) {

		// normalizzazione ID carrello
		$idCarrello = $_REQUEST['trackid'];

		// nome del file di ricevuta
		$fileRicevuta = DIR_VAR_SPOOL_PAYMENT . 'monetaweb/' . sprintf( '%08d', $_REQUEST['trackid'] ) . '.log';

		// log
		appendToFile( date( 'Y-m-d H:i:s' ) . ' ricevuta comunicazione IPN' . PHP_EOL, $fileRicevuta );
		appendToFile( print_r( $_REQUEST, true ), $fileRicevuta );

		// controllo campi obbligatori
		$missingFields = array_diff( array( 'paymentid', 'result', 'auth', 'ref', 'tranid', 'trackid', 'responsecode' ), array_keys( $_REQUEST ) );

		// se i campi necessari sono tutti presenti...
		if( count( $missingFields ) === 0 ) {

			// comportamento secondo l'esito
			switch( $_REQUEST['responsecode'] ) {

				// pagamento completato con successo
				case '00':
                case '000':

					// registro il pagamento
					mysqlInsertRow(
						$cf['mysql']['connection'],
						array(
							'id'						=> $_REQUEST['trackid'],
							'session'					=> NULL,
							'provider_checkout'			=> basename( __FILE__ ),
							'timestamp_checkout'		=> time(),
							'timestamp_pagamento'		=> time(),
							'codice_pagamento'			=> $_REQUEST['auth'],
							'ordine_pagamento'			=> $_REQUEST['paymentid'],
							'status_pagamento'			=> $_REQUEST['result']
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
					logWrite( 'pagamento effettuato con successo per il carrello ' . $_REQUEST['codTrans'], 'monetaweb', LOG_INFO );

                break;

                default:

					// registro il fallimento del pagamento
					mysqlInsertRow(
						$cf['mysql']['connection'],
						array(
							'id'						=> $_REQUEST['trackid'],
							'codice_pagamento'			=> $_REQUEST['auth'],
							'ordine_pagamento'			=> $_REQUEST['paymentid'],
							'status_pagamento'			=> $_REQUEST['result']
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
					logWrite( 'pagamento non completato per il carrello ' . $_REQUEST['codTrans'], 'monetaweb', LOG_ERR );
					appendToFile( 'pagamento non completato' . PHP_EOL, $fileRicevuta );

                break;

            }

        } else {

			// log
			appendToFile( 'campi mancanti: ' . print_r( $missingFields, true ), $fileRicevuta );
			
		}

	} else {

	    // log
		logWrite( 'trackid mancante', 'monetaweb', LOG_ERR );

	}

    // TODO utilizzare success o error a seconda di com'è andato il pagamento?

    // pagina di redirect
    $redirect = $cf['ecommerce']['profile']['provider']['monetaweb']['success'];
    $url = $cf['contents']['pages'][ $redirect ]['url'][ LINGUA_CORRENTE ] . '?PaymentID=' . $_REQUEST['trackid'];

    // output
	// echo 'redirect=' . $url;
	echo $url;
