<?php

    /**
     * libreria per l'invio di mail tramite PhpMailer
     *
     * Questa libreria contiene alcune funzioni utili per l'invio di mail tramite phpmailer.
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
     * invia una mail
     *
     * @param	array	$from		array che contiene il mittente in formato 'nome' => 'indirizzo'
     * @param	array	$to			array che contiene i destinatari in formato 'nome' => 'indirizzo'
     * @param	string	$oggetto	
     * @param	string	$corpo		
     * @param	array	$attach		
     * @param	array	$server		
     *
     * @returns	int			
     *
     *
     *
     * @todo finire di documentare
     *
     */
    function sendMail( $host, $from, $to, $oggetto, $corpo, $cc = array(), $bcc = array(), $attach = array(), $headers = array(), $user = NULL, $pasw = NULL, $port = 25 ) {

	// log
	    logWrite(
			'sending: '	. $oggetto			. ' ' .
			'to: '		. print_r( $to , true )		. ' ' .
			'cc: '		. print_r( $cc , true )		. ' ' .
			'bcc: '		. print_r( $bcc , true )	. ' ' .
			'attach: '	. print_r( $attach , true )	. ' ',
			'mail',
			LOG_DEBUG
	    );

	// esito dell'operazione
	    $status				= true;

	// creazione dell'oggetto mail
	    $mail				= new PHPMailer\PHPMailer\PHPMailer();

	// configurazione dell'oggetto mail
	    $mail->IsSMTP();
	    $mail->Host					= $host;
	    $mail->Port					= $port;
	    $mail->SMTPDebug			= PHPMailer\PHPMailer\SMTP::DEBUG_SERVER;
	    $mail->Debugoutput			= function( $str, $level ) { logWrite( '('.$level.') '.$str, 'phpmailer' ); };

	// log
	    logWrite(
			'server: '	. $host		. ' ' .
			'port: '	. $port		. ' ' .
			'user: '	. $user		. ' ' .
			'pass: '	. $pasw		,
			'mail',
			LOG_DEBUG
	    );

	// autenticazione
	    if( ! empty( $user ) ) {
			$mail->SMTPAuth			= true;
			$mail->Username			= $user;
			$mail->Password			= $pasw;
	    } else {
			$mail->SMTPAuth			= false;
	    }

	// TLS
		if( $port == '587' ) {
			$mail->SMTPSecure		= 'tls';
		}
		if( $port == '465' ) {
			$mail->SMTPSecure		= 'ssl';
		}

	// configurazione dell'oggetto mail
	    $mail->IsHTML			= true;
	    $mail->CharSet			= 'UTF-8';

	// mittente
	    $mail->SetFrom( current( $from ), current( array_keys( $from ) ) );
	    $mail->AddReplyTo( current( $from ), current( array_keys( $from ) ) );

	// oggetto
	    $mail->Subject			= $oggetto;

	// creo il testo in plain text
	    $text = new \Html2Text\Html2Text( $corpo );

	// corpo alternativo
	    $mail->AltBody			= wordwrap( $text->getText() );

	// corpo del messaggio
	    $mail->MsgHTML( $corpo );

	// destinatari
	    foreach( $to as $destName => $destAddress ) {
			$mail->AddAddress( trim( $destAddress ), trim( $destName ) );
	    }

	// destinatari CC
	    foreach( $cc as $destName => $destAddress ) {
			$mail->AddCC( trim( $destAddress ), trim( $destName ) );
	    }

	// destinatari BCC
	    foreach( $bcc as $destName => $destAddress ) {
			$mail->AddBCC( trim( $destAddress ), trim( $destName ) );
	    }

	// allegati
		if( is_array( $attach ) ) {
			foreach( $attach as $kAtch => $vAtch ) {
				fullPath( $vAtch );
				if( file_exists( $vAtch ) && is_readable( $vAtch ) ) {
					$mail->AddAttachment( $vAtch , basename( $vAtch ) );
				} else {
					logWrite( 'impossibile allegare ' . $vAtch . ' (file non trovato o non leggibile)', 'mail', LOG_CRIT );
				}
			}
		}

	// invio
	    $status = $mail->Send();

	// log
	    if( $status == false ) {
			logWrite( 'errore phpmailer, status: ' . $status . ' ' . $mail->ErrorInfo . ' sending: '.$oggetto.' via: ' . $host . ':' . $port . ' to: '.serialize( $to ), 'mail', LOG_CRIT );
	    } else {
			logWrite( 'messaggio inviato con successo, phpmailer status: ' . $status . ' sending: '.$oggetto.' to: '.serialize( $to ), 'mail', LOG_NOTICE );
	    }

	// restituzione risultato
	    return $status;

    }

    /**
     * accoda una mail utilizzando un template
     *
     *
     *
     * @todo finire di documentare
     *
     */
    function queueMailFromTemplate( $c, $t, $d, $timestamp_invio, $to, $l = 'it-IT', $to_cc = array(), $to_bcc = array(), $attach = array(), $headers = array(), $server = NULL ) {

// NOTA $d deve contenere 'ct' => $ct e 'dt' => <i dati che volete incorporare nella mail>

	// debug
	    logWrite( 'richiesto accodamento di una mail con template', 'mail' );

	// valuto il template manager
	    switch( $t['type'] ) {

		case 'twig':
//print_r( $t );
//print_r( $d['ct'] );

// TODO verificare che la struttura di $t sia corretta e contenga tutti i campi necessari (ad es. from) per evitare che Twig vada in banana dopo

/*
$loader = new \Twig\Loader\ArrayLoader([
    'index.html' => 'Hello {{ name }}!',
]);
$twig = new \Twig\Environment($loader);

echo $twig->render('index.html', ['name' => 'Fabien']);
*/
		    // avvio di Twig
			$twig = new \Twig\Environment( new Twig\Loader\ArrayLoader( $t[ $l ] ) );
			$from = new \Twig\Environment( new Twig\Loader\ArrayLoader( array( 'nome' => array_key_first( $t[ $l ]['from'] ), 'mail' => reset( $t[ $l ]['from'] ) ) ) );
#			$to = new Twig_Environment( new Twig_Loader_Array( array( 'nome' => array_key_first( $t[ $l ]['to'] ), 'mail' => reset( $t[ $l ]['to'] ) ) ) );

		    // variabili da passare a queueMail()
			$mittente	= array( $from->render( 'nome', $d ) => $from->render( 'mail', $d ) );
			$oggetto	= $twig->render( 'oggetto', $d );
			$corpo		= $twig->render( 'testo', $d );
			$allegati	= ( ( isset( $t[ $l ]['attach'] ) ) ? $t[ $l ]['attach'] : array() );
			$allegati	= array_merge( $allegati, ( ( isset( $attach[ $l ] ) ) ? $attach[ $l ] : array() ) );
#print_r($corpo );
		    // se è definito nel template imposto il destinatario
			if( array_key_exists( 'to', $t[ $l ] ) && is_array( $t[ $l ]['to'] ) && ! empty( $t[ $l ]['to'][ array_key_first( $t[ $l ]['to'] ) ] ) ) {
#print_r( $t[$l] );
			    //$to = array_replace_recursive( $to, $t[ $l ]['to'] );
#print_r( $to );
			    $destinatari[ array_key_first( $t[ $l ]['to'] ) ] = $t[ $l ]['to'][ array_key_first( $t[ $l ]['to'] ) ];
			}

		    // elaboro i placeholder nei destinatari
			if( isset( $to ) ) {
			    foreach( $to as $k => $v ) {
					$tm = array( 'nome' => $k, 'mail' => $v );
					$tw = new \Twig\Environment( new \Twig\Loader\ArrayLoader( $tm ) );
					$destinatari[ $tw->render( 'nome', $d ) ] = $tw->render( 'mail', $d );
			    }
			}

		    // TODO implementare la stessa cosa per i destinatari CC e BCC
			$destinatari_cc = $to_cc;
			$destinatari_bcc = $to_bcc;

		    // TODO anche i nomi degli allegati dovrebbero passare da Twig in modo da poter inserire dati
		    // variabili (ad es. una ricevuta generata ad hoc che abbia l'ID della transazione nel nome)
			// TODO

		break;

		default:

		    // debug
			logWrite( 'tipo di template non supportato: ' . $t['type'], 'mail', LOG_ERR );

		break;

	    }

	// accodo la mail
	    $id = queueMail(
			$c,
			$timestamp_invio,
			$mittente,
			$destinatari,
			$oggetto,
			$corpo,
			$destinatari_cc,
			$destinatari_bcc,
			$allegati,
			$headers,
			$server
	    );

	// debug
	    logWrite( 'mail accodata via template con id #' . $id, 'mail' );

	// ritorno
	    return $id;

    }

    /**
     * accoda una mail
     *
     *
     *
     * @todo finire di documentare
     *
     */
    function queueMail( $c, $timestamp_invio, $mittente, $destinatari, $oggetto, $corpo, $destinatari_cc = array(), $destinatari_bcc = array(), $allegati = array(), $headers = array(), $server = NULL ) {

		// inserimento della mail in coda
		    $id = mysqlQuery(
				$c,
				"INSERT INTO mail_out (
					timestamp_composizione
					,
					timestamp_invio
					,
					server
					,
					mittente
					,
					destinatari
					,
					destinatari_cc
					,
					destinatari_bcc
					,
					oggetto
					,
					corpo
					,
					allegati
					,
					headers
				) VALUES (
					?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?
				)",
				array(
					array( 's' => time() )
					,
					array( 's' => $timestamp_invio )
					,
					array( 's' => $server )
					,
					array( 's' => serialize( $mittente ) )
					,
					array( 's' => serialize( $destinatari ) )
					,
					array( 's' => serialize( $destinatari_cc ) )
					,
					array( 's' => serialize( $destinatari_bcc ) )
					,
					array( 's' => $oggetto )
					,
					array( 's' => $corpo )
					,
					array( 's' => serialize( $allegati ) )
					,
					array( 's' => serialize( $headers ) )
				)
		    );

		// unlock delle tabelle
		    mysqlQuery( $c, 'UNLOCK TABLES' );

		// valore di ritorno
		    return $id;

    }

    /**
     *
     * @todo documentare
     *
     */
	function mailString2array( $t ) {

		$ar0 = array();

		$t = str_replace( ',', ';', $t );
		$ar1 = explode( ';', $t );

		foreach( $ar1 as $ds ) {

			if( filter_var( $ds , FILTER_VALIDATE_EMAIL) ) {

				$ar0[ $ds ] = $ds;
				
			} else {

				$dsa = array();

				$r = preg_match( '/([\S\s]+)\s([<]{0,1}[\S\@\.]+[>]{0,1})/', $ds, $dsa );
	
				if( ! empty( $r ) ) {
					$ar0[ trim( $dsa[1] ) ] = trim( $dsa[2], '<>' );
				}
	
			}

		}

		return $ar0;

	}

    /**
     *
     * @todo documentare
     *
     */	
	function array2mailString( $a ) {

		$ar = array();

		foreach( $a as $k => $m ) {

			$ar[] = $k . ' <' . $m . '>';

		}

		return implode( ', ', $ar );

	}
