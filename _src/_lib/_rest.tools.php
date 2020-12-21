<?php

    /**
     * libreria di strumenti REST
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    /**
     * esegue una chiamata REST
     *
     *
     *
     *
     * @todo documentare
     *
     */
    function restCall( $url, $method = METHOD_GET, $data = NULL, $datatype = MIME_APPLICATION_JSON, $answertype = MIME_APPLICATION_JSON, &$status = NULL, $headers = array(), $user = NULL, $pasw = NULL, &$error = NULL ) {

	// inizializzo l'oggetto CURL
	    $curl = curl_init();

	// registro la risposta
	    curl_setopt( $curl, CURLOPT_RETURNTRANSFER, true );

	// evito l'inclusione degli header nell'output
	    curl_setopt( $curl, CURLOPT_HEADER, false );

	// salto la verifica ssl
	    curl_setopt( $curl, CURLOPT_SSL_VERIFYPEER, false );

	// salto la verifica dell'host
	    curl_setopt( $curl, CURLOPT_SSL_VERIFYHOST, 2 );

	// imposto un timeout per la connessione
	    curl_setopt( $curl, CURLOPT_CONNECTTIMEOUT, 30 );

	// autenticazione
	    if( $user !== NULL && $pasw !== NULL ) {

		curl_setopt( $curl, CURLOPT_HTTPAUTH, CURLAUTH_BASIC );

		curl_setopt( $curl, CURLOPT_USERPWD, $user . ':' . $pasw );

	    }

	// verifico che ci siano dati da inviare
# NOTA perché questa riga è commentata?!
#	    if( $data !== NULL && is_array( $data ) && count( $data ) > 0 ) {
	    if( true ) {

		// codifico i dati
		    switch( $datatype ) {

			case 'headers':
			    $headers = array_merge( $headers, $data );
			break;

			case MIME_APPLICATION_JSON:
			    $data = json_encode( $data, JSON_UNESCAPED_SLASHES );
			    $headers = array_merge( $headers, array( 'Content-Type' => MIME_APPLICATION_JSON, 'Content-Length' => strlen( $data ) ) );
			    curl_setopt( $curl, CURLOPT_POSTFIELDS, $data );
			break;

			case MIME_MULTIPART_FORM_DATA:
			    $data = http_build_query( $data );
			    curl_setopt( $curl, CURLOPT_POSTFIELDS, $data );
			break;

			case NULL:
			case 'query':
				if( ! empty( $data ) ) {
					$data = http_build_query( $data );
					$url = sprintf( "%s?%s", $url, $data );
				}
			break;

		    }

		// log
		    logWrite( 'invio a ' . $url . ' (' . $method . ') dati: ' . serialize( $data ), 'rest' );

	    }

	// impostazione del tipo di dati accettato
		if( ! empty( $answertype ) ) {
			$headers = array_merge( $headers, array( 'Accept' => $answertype ) );
		}

	// impostazione degli headers
	    if( ! empty( $headers ) ) {
		foreach( $headers as $k => $d ) { $hdrs[] = $k . ': ' . $d; }
		curl_setopt( $curl, CURLOPT_HTTPHEADER, $hdrs );
	    }

	// imposto il metodo
	    curl_setopt( $curl, CURLOPT_CUSTOMREQUEST, $method );

	// imposto l'url
	    curl_setopt( $curl, CURLOPT_URL, $url );

	// debug
	    // curl_setopt( $curl, CURLOPT_VERBOSE, true);
	    // curl_setopt( $curl, CURLOPT_STDERR, fopen( DIRECTORY_BASE . DIRECTORY_LOG . 'curl.' . date('YmdHis') . '.log', 'w'));

	// esecuzione della chiamata
	    $result = curl_exec( $curl );
	    $status = curl_getinfo( $curl, CURLINFO_HTTP_CODE );
	    $error = curl_error( $curl );

	// debug
	    // var_dump( $url );
	    // var_dump( $curl );
	    // var_dump( $result );
	    // var_dump( $status );
	    // var_dump( $error );
	    // var_dump( $headers );
	    // var_dump( $data );

	// log
	    if( ! empty( $error ) || substr( $status, 0, 1 ) != 2 ) {
		logWrite( 'risposta ' . $status . ( ( ! empty( $error ) ) ? '/' . $error : NULL ) . ' ricevuta da ' . $url . ' (' . $method . '): ' . serialize( $result ), 'rest' , LOG_ERR );
	    } else {
		logWrite( 'risposta ' . $status . ' ricevuta da ' . $url . ' (' . $method . '): ' . serialize( $result ), 'rest' );
	    }

	// chiusura della richiesta
	    curl_close( $curl );

	// decodifica della risposta
	    switch( $answertype ) {

		case MIME_APPLICATION_JSON:
		    $result = json_decode( $result , true );
		break;

	    }

	// restituzione della risposta
	    return $result;

    }

    /**
     *
     *
     *
     *
     * @todo documentare
     *
     */
    function restGetValue( $k, $url, $data = NULL, $datatype = MIME_APPLICATION_JSON, $answertype = MIME_APPLICATION_JSON, &$status = NULL, $headers = array(), $user = NULL, $pasw = NULL, &$error = NULL ) {

	$r = restCall( $url, METHOD_GET, $data, $datatype, $answertype, $status, $headers, $user, $pasw, $error );

	if( isset( $r[ $k ] ) ) {
	    return $r[ $k ];
	} else {
	    return false;
	}

    }
