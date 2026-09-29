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

		// NOTA senza destinatari il risultato resterebbe NULL, che il task di invio legge come un successo
		    if( empty( $to ) ) {
				logWrite( 'invio senza destinatari', 'ehiweb', LOG_ERR );
				return false;
		    }

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
		// NOTA Ehiweb vuole il numero internazionale senza il +; fino al 2026-09-30 qui si toglievano gli zeri iniziali e si
		// aggiungeva 39 solo se mancava, quindi un cellulare italiano 39x restava senza prefisso e uno fisso perdeva lo 0
		    $to = string2smsNumber( $to );

		// destinatario senza cifre
		    if( $to === false ) {
				logWrite( 'destinatario senza cifre', 'ehiweb', LOG_ERR );
				return false;
		    }

		// tolgo il +
		    $to = ltrim( $to, '+' );

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
