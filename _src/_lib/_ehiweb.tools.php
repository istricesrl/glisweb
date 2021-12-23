<?php

    /**
     * libreria per l'invio di SMS tramite Ehiweb
     *
     *
     *
     *
     *
     * @todo finire di documentare
     *
     * @file
     *
     */

    /**
     *
     *
     *
     * @todo finire di documentare
     *
     */
    function ehiwebSend( $testo, $to, $user = NULL, $pasw = NULL, $from = NULL, $id_api = NULL, $url = 'https://secure.apisms.it/http/send_sms' ) {

	// risultato
	    $result = NULL;

	// destinatari multipli
	    if( is_array( $to ) ) {

		// invio multiplo
		    foreach( $to as $ds ) {
			$rs = ehiwebSend( $testo, $ds, $user, $pasw, $from, $id_api, $url );
			if( $result !== false ) { $result = $rs; }
		    }

	    } else {

		// se il mittente è un array
		    if( is_array( $from ) ) {
			$keys = array_keys( $from );
			$sender = array_shift( $keys );
			$from = array_shift( $from );
		    }

		// pulizia destinatario
		    $to = str_replace( '+', NULL, $to );
		    $to = str_replace( '.', NULL, $to );
		    $to = str_replace( '/', NULL, $to );
		    $to = str_replace( ' ', NULL, $to );
		    $to = ltrim( $to, '0' );

		// BRUTTISSIMO rendere più flessibile
		    if( substr( $to, 0, 2 ) != '39' ) { $to = '39' . $to; }

		// pulisco il body
#		    $testo = filter_var( $testo, FILTER_SANITIZE_FULL_SPECIAL_CHARS );
		    $testo = iconv('UTF-8', 'ASCII//TRANSLIT//IGNORE', $testo);

		// log
		    logWrite( 'invio a ' . $to . ' da ' . $from . ': ' . $testo, 'ehiweb' );

		// invio
		    $result = restCall(
			$url,
			METHOD_POST,
			array(
			    'authlogin' => $user,
			    'authpasswd' => $pasw,
			    'body' => base64_encode( $testo ),
			    'destination' => $to,
			    'id_api' => $id_api,
			    'sender' => base64_encode( $from )
			),
			'multipart/form-data',
			'text/plain',
			$status
		    );

		// debug
		    // var_dump( $status );
		    // var_dump( $result );

		// risultato
		    if( substr( $result, 0, 1 ) == '+' ) {
				logWrite( 'SMS inviato: ' . $result, 'ehiweb', LOG_NOTICE );
				return true;
		    } else {
				logWrite( 'fallito invio a ' . $to . ': ' . $result, 'ehiweb', LOG_CRIT );
				return false;
		    }

	    }

	// risultato
	    return $result;

    }
