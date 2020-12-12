<?php

    /**
     * libreria per l'invio di SMS tramite Skebby
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
    function skebbySend( $testo, $to, $user = NULL, $pasw = NULL, $from = NULL, $type = 'TI', $url = 'https://api.skebby.it/API/v1.0/REST/' ) {

	// risultato
	    $result = false;

	// autenticazione
	    $auth = restCall(
		$url . 'login?username=' . $user . '&password=' . $pasw,
		METHOD_GET,
		NULL,
		'application/json',
		'text/plain',
		$status
	    );

	// ricavo i parametri per l'autenticazione
	    $auths = explode( ';', $auth );

	// debug
	    // var_dump( $status );
	    // echo $url . PHP_EOL;
	    // print_r( $auths );

	// se ho l'autenticazione
	    if( $status == 200 ) {

		// log
		    logWrite( 'autenticazione su Skebby effettuata con successo: ' . $auth, 'skebby' );

		// dati
		    $dati = array(
			'returnCredits' => true,
			'recipient' => $to,
			'message' => $testo,
			'message_type' => $type,
			'sender' => $from
		    );

		// headers
		    $headers = array(
			'user_key' => $auths[0],
			'Session_key' => $auths[1]
		    );

		// invio
		    $result = restCall(
			$url . 'sms',
			METHOD_POST,
			$dati,
			'application/json',
			'application/json',
			$status,
			$headers
		    );

		// log
		    logWrite( 'esito invio: ' . print_r( $result, true ), 'skebby' );

		// debug
		    // var_dump( json_decode( $status, true ) );

		// risultato
		    if( $result['result'] == 'OK' ) {
			return true;
		    } else {
			logWrite( 'fallito invio: ' . print_r( $result, true ), 'skebby', LOG_CRIT );
			return false;
		    }

	    } else {

		// log
		    logWrite( 'errore di autenticazione su Skebby: ' . $auth, 'skebby', LOG_CRIT );

		// risultato
		    return false;

	    }

	// risultato
	    return $result;

    }
