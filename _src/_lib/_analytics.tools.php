<?php

    /**
     *
     *
     *
     *
     * @todo documentare
	 * 
	 * 
	 * NOTA per creare l'API secret di GA4 MP andare in amministrazione -> stream di dati -> cliccare sull stream web
     *
     * @file
     *
     */

    // indirizzo per l'invio dei dati
	define( 'GA4_MEASUREMENT_URL', 'https://www.google-analytics.com/' );
	define( 'GA4_MEASUREMENT_ENDPOINT_COLLECT', 'mp/collect' );

    /**
     *
     * @todo documentare
     *
	 */
	function ga4event( $ua, $secret, $e ) {

		$url = GA4_MEASUREMENT_URL . GA4_MEASUREMENT_ENDPOINT_COLLECT . '?measurement_id='.$ua.'&api_secret='.$secret;

		$response = restCall(
			$url,
			METHOD_POST,
			$e,
			MIME_APPLICATION_JSON,
			NULL,
			$status
		);

		logWrite( GA4_MEASUREMENT_URL . GA4_MEASUREMENT_ENDPOINT_COLLECT . PHP_EOL . print_r( $e, true ) . PHP_EOL . $response, 'analytics' );
		
	}

    /**
     *
     * @todo documentare
     *
	 */
	function ga4purchase( $ua, $secret, $carrello ) {

/*
        "currency": "USD",
        "transaction_id": "T_12345",
        "value": 12.21,
        "coupon": "SUMMER_FUN",
        "shipping": 3.33,
        "tax": 1.11,
        "items": [
          {
            "item_id": "SKU_12345",
            "item_name": "Stan and Friends Tee",
            "affiliation": "Google Merchandise Store",
            "coupon": "SUMMER_FUN",
            "currency": "USD",
            "discount": 2.22,
            "index": 0,
            "item_brand": "Google",
            "item_category": "Apparel",
            "item_category2": "Adult",
            "item_category3": "Shirts",
            "item_category4": "Crew",
            "item_category5": "Short sleeve",
            "item_list_id": "related_products",
            "item_list_name": "Related Products",
            "item_variant": "green",
            "location_id": "ChIJIQBpAG2ahYAR_6128GcTUEo",
            "price": 9.99,
            "quantity": 1
          }
        ]
      }	
*/
	  	// TODO nel carrello non è specificata la valuta in formato vattelapesca tre caratteri

		foreach( $carrello['articoli'] as $item ) {
			$items[] = array(
				'item_id' => $item['id_articolo'],
				'item_name' => $item['descrizione'],
				'coupon' => NULL,
				'currency' => 'EUR',
				'discount' => $item['sconto_valore'],
				'price' => $item['prezzo_lordo_unitario'],
				'quantity' => $item['quantita']
			);
		}

		$e = array(
			'client_id' => session_id(),
			'events' => array(
				array(
					'name' => 'purchase',
					'params' => array(
						'currency' => 'EUR',
						'transaction_id' => $carrello['id'],
						'value' => $carrello['prezzo_lordo_finale'],
						'coupon' => $carrello['codice_coupon'],
						'shipping' => 0.0,
						'tax' => 0.0,
						'items' => $items
					)
				)
			)
		);

		ga4event( $ua, $secret, $e );

	}

    /**
     *
     * @todo documentare
     *
    function analyticsPageHit( $p, $ua, $cid ) {

		// effettuo la chiamata
			$r = restCall(
			ANALYTICS_URL . ANALYTICS_ENDPOINT_COLLECT,
			METHOD_POST,
			array(
				'v' => '1',
				't' => 'pageview',
				'dp' => $p,
				'tid' => $ua,
				'cid' => $cid
			),
			MIME_MULTIPART_FORM_DATA,
			false
			);

		// debug
			// echo http_build_query( $hit );
			// var_dump( $r );

    }
     */

    /**
     *
     * @todo documentare
     *
	 * 
    function analyticsProductHit( $p, $pr, $ua, $cid ) {

		// contatore per le liste di impressioni
			$li = 1;

		// array base per l'hit
			$hit = array(
			'v' => '1',
			't' => 'pageview',
			'dp' => $p,
			'tid' => $ua,
			'cid' => $cid
			);

		// aggiungo le impression list e i prodotti
			foreach( $pr as $ln => $lp ) {

			// contatore per i prodotti di questa lista
				$pi = 1;

			// compongo il nome dell'impression list
				$lin = 'il' . $li;

			// aggiungo la lista all'hit
				$hit[ $lin . 'nm' ] = $ln;

			// compongo l'elenco dei prodotti
				foreach( $lp as $pk => $pr ) {

				// compongo il nome del prodotto
					$pin = $lin . 'pi' . $pi;

				// aggiungo i dati di questo prodotto
					$hit[ $pin . 'id' ] = $pk;
					$hit[ $pin . 'nm' ] = $pr['nome'];
					$hit[ $pin . 'ca' ] = $pr['categoria'];

				// incremento il contatore
					$pi++;

				}

			// incremento il contatore
				$li++;

	    }

		// effettuo la chiamata
			$r = restCall(
			ANALYTICS_URL . ANALYTICS_ENDPOINT_COLLECT,
			METHOD_POST,
			$hit,
			MIME_MULTIPART_FORM_DATA,
			false
			);

		// debug
			// echo http_build_query( $hit );
			// var_dump( $r );

    }
     */

    /**
     *
     * @todo documentare
     *
	 * 
    function analyticsEventHit( $ua, $ec, $ea, $el, $cid = 1 ) {

	// array base per l'hit
	    $hit = array(
		'v' => '1',					// versione
		't' => 'event',					// tipo di hit
		'tid' => $ua,					// tracking ID
		'cid' => $cid,					// ID client anonimo
		'ec' => $ec,					// categoria evento
		'ea' => $ea,					// azione evento
		'el' => $el					// label evento
	    );

	// effettuo la chiamata
	    $r = restCall(
		ANALYTICS_URL . ANALYTICS_ENDPOINT_COLLECT,
		METHOD_POST,
		$hit,
		MIME_MULTIPART_FORM_DATA,
		false
	    );

	// log
	    logWrite( ANALYTICS_URL . ANALYTICS_ENDPOINT_COLLECT . http_build_query( $hit ), 'ecommerce', LOG_DEBUG );

    }
	*/

    /**
     *
     * @todo documentare
     *
	 * 
    function analyticsPurchase( $p, $pr, $ua, $cid, $tid, $tr, $tt, $ts, $aip = 1 ) {

		// contatore per le liste di impressioni
			$li = 1;

		// array base per l'hit
			$hit = array(
			'v' => '1',					// versione
			't' => 'pageview',				// tipo di hit
			'dp' => $p,						// pagina
			'tid' => $ua,					// tracking ID
			'cid' => $cid,					// ID client anonimo
			'ti' => $tid,					// ID carrello
			'tr' => $tr,					// importo totale lordo del carrello
			'tt' => $tt,					// tasse
			'ts' => $ts,					// spese di spedizione
			'pa' => 'purchase',				// azione
			'aip' => $aip					// anonimizzazione IP
			);

		// contatore per i prodotti di questa lista
			$pi = 1;

		// aggiungo le impression list e i prodotti
			foreach( $pr as $pk => $pr ) {

			// compongo il nome del prodotto
				$pin = 'pr' . $pi;

			// aggiungo i dati di questo prodotto
				$hit[ $pin . 'id' ] = $pk;			// ID articolo
				$hit[ $pin . 'nm' ] = $pr['nome'];		// nome articolo
				$hit[ $pin . 'ca' ] = $pr['categoria'];	// categoria articolo
				$hit[ $pin . 'pr' ] = $pr['prezzo'];	// prezzo lordo unitario articolo
				$hit[ $pin . 'qt' ] = $pr['quantita'];	// quantità articolo

			// incremento il contatore
				$pi++;

			}

		// effettuo la chiamata
			$r = restCall(
			ANALYTICS_URL . ANALYTICS_ENDPOINT_COLLECT,
			METHOD_POST,
			$hit,
			MIME_MULTIPART_FORM_DATA,
			false
			);

		// log
			logWrite( ANALYTICS_URL . ANALYTICS_ENDPOINT_COLLECT . http_build_query( $hit ), 'ecommerce', LOG_DEBUG );

		// debug
			// echo http_build_query( $hit );
			// var_dump( $r );

    }
	*/
