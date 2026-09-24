<?php

    /**
     * libreria per l'invio dei dati a Google Analytics
     *
     * Questa libreria contiene le funzioni per inviare eventi a Google Analytics 4 lato server, tramite il Measurement Protocol.
     *
     * introduzione
     * ============
     * Il Measurement Protocol di GA4 permette di registrare eventi senza passare dal JavaScript di Analytics nel browser; il
     * framework lo usa per le conversioni che avvengono lato server, per ora solo l'acquisto al termine del checkout del modulo
     * ecommerce ( _mod/_4170.ecommerce/_src/_inc/_controllers/_checkout.finally.success.php ). Per inviare gli eventi servono
     * l'ID di misurazione dello stream ( G-... ), che il framework legge da $cf['google']['profile']['analytics']['ua'], e
     * l'API secret del Measurement Protocol, che legge da $cf['google']['profile']['analytics']['mp']['secret'].
     *
     * NOTA per creare l'API secret di GA4 MP andare in amministrazione -> stream di dati -> cliccare sull stream web
     *
     * In fondo al file restano, commentate, le funzioni che inviavano i dati a Universal Analytics ( analyticsPageHit(),
     * analyticsProductHit(), analyticsEventHit() e analyticsPurchase() ); Universal Analytics è stato dismesso da Google e le
     * costanti ANALYTICS_URL e ANALYTICS_ENDPOINT_COLLECT che quelle funzioni usavano non sono più definite.
     *
     * costanti
     * ========
     * Le costanti definite e utilizzate dalla libreria sono elencate nella seguente tabella.
     *
     * costante                                 | spiegazione
     * -----------------------------------------|--------------------------------------------------------------
     * GA4_MEASUREMENT_URL                      | l'indirizzo base del Measurement Protocol
     * GA4_MEASUREMENT_ENDPOINT_COLLECT         | l'endpoint per l'invio degli eventi
     * GA4_MEASUREMENT_ENDPOINT_DEBUG_COLLECT   | l'endpoint di validazione degli eventi ( al momento non utilizzato )
     *
     * funzioni
     * ========
     * Le funzioni di questa libreria sono divise in gruppi in base al lavoro che svolgono; nei paragrafi successivi le analizzeremo nel dettaglio.
     *
     * funzioni per GA4
     * ----------------
     * Le funzioni in questo gruppo servono per inviare eventi a Google Analytics 4.
     *
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * ga4event()                       | invia uno o più eventi a GA4 tramite il Measurement Protocol
     * ga4purchase()                    | invia a GA4 l'evento di acquisto di un carrello
     *
     * dipendenze
     * ==========
     * Questa libreria ha alcune dipendenze che devono essere soddisfatte per funzionare correttamente. In particolare
     * sono richieste le seguenti funzioni:
     *
     * funzione                         | libreria di appartenenza
     * ---------------------------------|---------------------------------------------------------------
     * restCall()                       | _src/_lib/_rest.tools.php
     * logWrite()                       | _src/_lib/_log.utils.php
     *
     * changelog
     * =========
     * Questa sezione riporta la storia delle modifiche più significative apportate alla libreria.
     *
     * data             | autore               | descrizione
     * -----------------|----------------------|---------------------------------------------------------------
     * 2026-09-24       | Fabio Mosti          | documentazione
     *
     * licenza
     * =======
     * Questa libreria fa parte del progetto GlisWeb (https://github.com/istricesrl/glisweb) ed è distribuita
     * sotto licenza Open Source. Fare riferimento alla pagina GitHub del progetto per i dettagli.
     *
     * @file
     *
     */

    // indirizzo per l'invio dei dati
	define( 'GA4_MEASUREMENT_URL', 'https://www.google-analytics.com/' );
	define( 'GA4_MEASUREMENT_ENDPOINT_COLLECT', 'mp/collect' );
	define( 'GA4_MEASUREMENT_ENDPOINT_DEBUG_COLLECT', 'debug/mp/collect' );

    /**
     * FUNZIONI PER GA4
     */

    /**
     * invia uno o più eventi a GA4 tramite il Measurement Protocol
     *
     * Questa funzione invia in POST, codificato in JSON, il payload $e all'endpoint mp/collect del Measurement Protocol, per lo
     * stream indicato da $ua e con l'API secret $secret, e scrive nel log analytics l'endpoint, il payload e la risposta. Il
     * payload è quello previsto da Google, con le chiavi client_id ed events ( vedi ga4purchase() per un esempio ).
     *
     * NOTA l'endpoint di produzione risponde con successo anche agli eventi malformati, che vengono semplicemente scartati: per
     * sapere se un evento è valido lo si manda all'endpoint GA4_MEASUREMENT_ENDPOINT_DEBUG_COLLECT, che restituisce gli errori
     * di validazione. La funzione non restituisce né controlla l'esito della chiamata.
     *
     * @param       string      $ua         l'ID di misurazione dello stream GA4 ( G-... )
     * @param       string      $secret     l'API secret del Measurement Protocol
     * @param       array       $e          il payload da inviare, con le chiavi client_id ed events
     *
     * @return      void
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
     * invia a GA4 l'evento di acquisto di un carrello
     *
     * Questa funzione compone l'evento purchase di GA4 a partire da un carrello concluso e lo invia con ga4event(). La
     * transazione ha come ID l'ID del carrello e come valore il prezzo lordo finale, la valuta è sempre EUR e spedizione e tasse
     * valgono zero; ogni articolo diventa un item con ID, descrizione, prezzo lordo unitario e quantità. Coupon e sconti non
     * vengono inviati, perché valorizzati a NULL mandano in errore la chiamata ( si vedano le NOTA nel corpo ). Il client_id è
     * l'ID della sessione PHP, quindi l'acquisto non viene collegato alla sessione di Analytics del browser.
     *
     * Il commento all'inizio del corpo contiene il formato di esempio di Google e una versione precedente della funzione, che
     * chiamava l'endpoint con cURL, lasciata come riferimento.
     *
     * TODO se il carrello non ha articoli $items non viene mai inizializzata: PHP segnala una variabile non definita e l'evento
     * parte con items a NULL.
     *
     * @param       string      $ua         l'ID di misurazione dello stream GA4 ( G-... )
     * @param       string      $secret     l'API secret del Measurement Protocol
     * @param       array       $carrello   il carrello, con le chiavi id, prezzo_lordo_finale e articoli ( id_articolo, descrizione, prezzo_lordo_unitario, quantita )
     *
     * @return      void
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
				'quantity' => sprintf( '%0.0f', $item['quantita'] )
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
						'value' => sprintf( '%0.2f', $carrello['prezzo_lordo_finale'] ),
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
     * invia a Universal Analytics una visualizzazione di pagina ( disattivata )
     *
     * Questa funzione, commentata, inviava al Measurement Protocol di Universal Analytics un hit pageview per la pagina $p,
     * con il tracking ID $ua e l'ID client anonimo $cid.
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
     * invia a Universal Analytics una visualizzazione di pagina con le liste di prodotti ( disattivata )
     *
     * Questa funzione, commentata, inviava al Measurement Protocol di Universal Analytics un hit pageview per la pagina $p
     * arricchito con le impression list dell'ecommerce avanzato: $pr è un array nel formato 'nome lista' => array( 'id prodotto'
     * => array( 'nome' => ..., 'categoria' => ... ) ).
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
     * invia a Universal Analytics un evento ( disattivata )
     *
     * Questa funzione, commentata, inviava al Measurement Protocol di Universal Analytics un hit di tipo event con categoria
     * $ec, azione $ea e label $el, e lo scriveva nel log ecommerce.
     *
     * TODO _mod/_0300.contatti/_src/_config/_750.controller.php chiama ancora analyticsEventHit() quando il form ha la chiave
     * analytics e il profilo Google ha l'ID di Analytics: siccome la funzione non è definita, in quel caso l'invio del form
     * termina con un errore fatale.
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
     * invia a Universal Analytics una transazione dell'ecommerce ( disattivata )
     *
     * Questa funzione, commentata, inviava al Measurement Protocol di Universal Analytics un hit pageview con l'azione purchase
     * dell'ecommerce avanzato: ID carrello, totale, tasse, spese di spedizione e l'elenco dei prodotti, con l'anonimizzazione
     * dell'IP attiva per default. Il suo posto è stato preso da ga4purchase().
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
