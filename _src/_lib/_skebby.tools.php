<?php

/**
 * libreria per l'invio di SMS tramite Skebby
 *
 *
 * https://developers.skebby.it/
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
function skebbySend($testo, $to, $user = NULL, $pasw = NULL, $from = NULL, $type = 'TI', $url = 'https://api.skebby.it/API/v1.0/REST/')
{

	// risultato
	$result = false;

	// autenticazione
	$auth = restCall(
		// $url . 'login?username=' . $user . '&password=' . $pasw,
		$url . 'login',
		METHOD_GET,
		NULL,
		'application/json',
		'text/plain',
		$status,
		array(),
		$user,
		$pasw
	);

	// ricavo i parametri per l'autenticazione
	$auths = explode(';', $auth);

	// debug
	// print_r($from);

	// se il mittente è in formato [ nome => numero ] prendo solo il numero
	if (is_array($from)) {
		$sender = reset($from);
		if( empty( $sender ) ) {
			$keys = array_keys( $from );
			$sender = reset($keys);
		}
	} else {
		$sender = $from;
	}

	// debug
	// var_dump( $status );
	// var_dump( $auth );
	// echo $url . PHP_EOL;
	// print_r( $auths );
	// var_dump( $user );
	// var_dump( $pasw );

	// se ho l'autenticazione
	if ($status == 200) {

		// log
		logWrite('autenticazione su Skebby effettuata con successo: ' . $auth, 'skebby');

		// NOTA un destinatario singolo passato come stringa diventa un array di un elemento: senza, il foreach qui sotto
		// e array_values() fermavano il task di invio con la riga ancora marcata dal token
		if (! is_array($to)) {
			$to = array($to);
		}

		// porto i destinatari in formato internazionale
		// NOTA fino al 2026-09-30 qui si toglieva il + e si rimetteva +39 davanti a tutto quello che non cominciava con +39,
		// e +39 333 1234567 diventava +39393331234567; la regola ora sta in string2smsNumber() ( _src/_lib/_sms.tools.php )
		foreach ($to as $key => $value) {
			$to[$key] = string2smsNumber($value);
			if ($to[$key] === false) {
				logWrite('destinatario senza cifre scartato: ' . print_r($value, true), 'skebby', LOG_ERR);
				unset($to[$key]);
			}
		}

		// NOTA senza destinatari validi non c'è niente da inviare, e l'invio è fallito
		if (empty($to)) {
			logWrite('invio senza destinatari validi', 'skebby', LOG_ERR);
			return false;
		}

		$recipient = array_values($to);

		// dati
		$dati = array(
			'returnCredits' => true,
			'recipient' => $recipient,
			'message' => $testo,
			'message_type' => $type,
			'sender' => $sender
		);

		// print_r($dati);

		// headers
		$headers = array(
			'user_key' => $auths[0],
			'Session_key' => $auths[1]
		);

		// log
		logWrite('invio SMS a: ' . implode(',', $to) . ' da: ' . $sender . PHP_EOL . print_r($dati, true), 'skebby');

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
		logWrite('esito invio: ' . print_r($result, true), 'skebby');

		// debug
		// var_dump( json_decode( $status, true ) );
		// var_dump($status);
		// var_dump($result);

		// risultato
		if (isset( $result['result']) && $result['result'] == 'OK') {
			return true;
		} else {
			logWrite('fallito invio: ' . print_r($result, true), 'skebby', LOG_CRIT);
			return false;
		}
	} else {

		// log
		logWrite('errore di autenticazione su Skebby: ' . $auth, 'skebby', LOG_CRIT);

		// risultato
		return false;
	}

	// risultato
	return $result;
}
