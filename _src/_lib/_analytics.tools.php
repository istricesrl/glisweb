<?php

    /**
     *
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // indirizzo per l'invio dei dati
	define( 'ANALYTICS_URL'			, 'www.google-analytics.com/' );
	define( 'ANALYTICS_ENDPOINT_COLLECT'	, 'collect' );

    /**
     *
     * @todo documentare
     *
     */
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

    /**
     *
     * @todo documentare
     *
     */
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

    /**
     *
     * @todo documentare
     *
     */
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

    /**
     *
     * @todo documentare
     *
     */
    function analyticsCheckout( $p, $pr, $ua, $cid, $tid, $tr, $tt, $ts, $aip = 1 ) {

	// contatore per le liste di impressioni
	    $li = 1;

	// array base per l'hit
	    $hit = array(
		'v' => '1',					// versione
		't' => 'pageview',				// tipo di hit
		'dp' => $p,					// pagina
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

