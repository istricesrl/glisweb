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
	define( 'GA4_MEASUREMENT_ENDPOINT_DEBUG_COLLECT', 'debug/mp/collect' );

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

		// print_r( $response );
		// var_dump( $status );

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

	  *** CODICE FUNZIONANTE SU IMPORT FOR ME ***

    if (!isset($_COOKIE['_cid']) || empty($_COOKIE['_cid'])) {
        $cid = vsprintf('%s%s-%s-%s-%s-%s%s%s', str_split(bin2hex(random_bytes(16)), 4));
        setcookie('_cid', $cid);
    } else {
        $cid = $_COOKIE['_cid'];
    }

	foreach( $carrello['articoli'] as $item ) {
	    $items[] = array(
		'item_id' => $item['id_articolo'],
		'item_name' => $item['id_articolo'],
#		'coupon' => NULL,
		'currency' => 'EUR',
		'discount' => 0.0,
		'price' => $item['prezzo_lordo_totale'] / $item['quantita'],
		'quantity' => $item['quantita']
	    );
	}

	$data = array(
	    'client_id' => $cid,
	    'events' => array(
		array(
		    'name' => 'purchase',
		    'params' => array(
			'currency' => 'EUR',
			'transaction_id' => $carrello['id'],
			'value' => $carrello['prezzo_lordo_complessivo'],
#			'coupon' => $carrello['coupon'],
			'shipping' => 0.0,
			'tax' => 0.0,
			'items' => $items
		    )
		)
	    )
	);

$secret = '';
$ua = '';

	$url = 'https://www.google-analytics.com/mp/collect?api_secret='.$secret.'&measurement_id='.$ua;
	$url = 'https://www.google-analytics.com/debug/mp/collect?tid=fake&v=1&api_secret='.$secret.'&measurement_id='.$ua;
	$url = 'https://www.google-analytics.com/mp/collect?api_secret='.$secret.'&measurement_id='.$ua.'&tid='.$ua.'&v=1';
	$url = 'https://www.google-analytics.com/debug/mp/collect?tid=fake&v=1';
	$url = 'https://www.google-analytics.com/debug/mp/collect?tid=fake&v=1&measurement_id='.$ua;
	$url = 'https://www.google-analytics.com/debug/mp/collect?tid=fake&v=1&api_secret='.$secret.'&measurement_id='.$ua;
	$url = 'https://www.google-analytics.com/mp/collect?tid='.$ua.'&v=1&api_secret='.$secret.'&measurement_id='.$ua;

	$url = 'https://www.google-analytics.com/mp/collect?measurement_id='.$ua.'&api_secret='.$secret;
	// $url = 'https://www.google-analytics.com/debug/mp/collect?api_secret=fake&measurement_id=fake';

	$ch = curl_init();
	curl_setopt($ch, CURLOPT_USERAGENT, $_SERVER['HTTP_USER_AGENT']);
	curl_setopt($ch, CURLOPT_URL, $url);
	curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json']);
	curl_setopt($ch, CURLOPT_POST, true);
	curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode( $data, true ) );
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	$response = curl_exec($ch);
	$errors = curl_error($ch);
	$status = curl_getinfo($ch, CURLINFO_HTTP_CODE);
	curl_close($ch);

header( 'content-type: text/plain' );
// var_dump( $url );
print_r( $carrello );
print_r( $data );
echo $response;
var_dump($errors);
var_dump($status);

*/
	  	// TODO nel carrello non è specificata la valuta in formato vattelapesca tre caratteri

		foreach( $carrello['articoli'] as $item ) {
			$items[] = array(
				'item_id' => $item['id_articolo'],
				'item_name' => $item['descrizione'],
// NOTA inserire il coupon solo se c'è, altrimenti va in errore
//				'coupon' => NULL,
				'currency' => 'EUR',
// NOTA inserire lo sconto solo se c'è, altrimenti va in errore
//				'discount' => $item['sconto_valore'],
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
// NOTA inserire il coupon solo se c'è, altrimenti va in errore
//						'coupon' => $carrello['codice_coupon'],
						'shipping' => 0.0,
						'tax' => 0.0,
						'items' => $items
					)
				)
			)
		);

		// print_r( $e );

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
