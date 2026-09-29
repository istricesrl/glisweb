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

		// elimino da $to tutti i caratteri non numerici
		foreach ($to as $key => $value) {
			$to[$key] = preg_replace('/[^0-9]/', '', $value);
		}

		// aggiungo +39 all'inizio di ogni elemento in $to se manca
		foreach ($to as $key => $value) {
			if (substr($value, 0, 4) == '0039') {
				$to[$key] = '+' . substr($value, 2);
			}
			// NOTA il controllo va fatto sul valore appena convertito: fatto su $value, un numero scritto 0039... diventava
			// +390039...
			if (substr($to[$key], 0, 3) != '+39') {
				$to[$key] = '+39' . $to[$key];
			}
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
