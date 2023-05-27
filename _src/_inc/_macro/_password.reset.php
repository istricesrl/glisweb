<?php

	// TODO gestire il recaptcha in arrivo (vedi ad es. form login)

    // ho ricevuto l'indirizzo e-mail
	if( isset( $_REQUEST['__pwreset__']['email'] ) ) {

	    // cerco la mail nel database associata a un account attivo
		$account = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT account.* FROM account INNER JOIN mail ON mail.id = account.id_mail WHERE mail.indirizzo = ?',
            array( array( 's' => $_REQUEST['__pwreset__']['email'] ) )
        );

	    // se è tutto ok, invio la mail
		if( ! empty( $account ) ) {

		    // creo il token
			$tk = md5( $account['id'] . $_REQUEST['__pwreset__']['email'] . rand( 0, rand( 10000, 99999 ) ) . microtime() );

			// se non è settata una pagina di ritorno, la imposto a default
			$pg = ( isset( $_REQUEST['pg'] ) ) ? $_REQUEST['pg'] : 'password.reset';

		    // debug
			// echo $tk;

		    // aggiorno il token sul database
			mysqlQuery(
                $cf['mysql']['connection'],
                'UPDATE account SET token = ? WHERE id = ?',
                array( array( 's' => $tk ), array( 's' => $account['id'] ) )
            );

		    // invio la mail con il link e il token
			$invio = queueMailFromTemplate(
			    $cf['mysql']['connection'],
			    $cf['mail']['tpl'][ 'DEFAULT_REIMPOSTAZIONE_PASSWORD'],
			    array( 'dt' => array( 'tk' => $tk, 'pg' => $pg ), 'ct' => $ct ),
			    strtotime( '+1 minutes' ),
			    array( $_REQUEST['__pwreset__']['email'] => $_REQUEST['__pwreset__']['email'] ),
			    $cf['localization']['language']['ietf']
			);

		    // se la mail è partita, imposto il flag per il modulo
			if( $invio ) {
			    $_REQUEST['__pwreset__']['__tk_sent__']['testo'] = array(
				    'it-IT' => 'abbiamo inviato una mail per completare la procedura alla casella indicata'
			    );
			} else {
			    $_REQUEST['__pwreset__']['__err__']['testo'] = array(
				    'it-IT' => 'abbiamo rilevato un problema nella generazione della mail di conferma'
			    );
            }

		} else {

            // messaggio
			$_REQUEST['__pwreset__']['__err__']['testo'] = array(
			    'it-IT' => 'la mail inserita non corrisponde ad alcun account valido'
			);

		}

	} elseif( ! isset( $_REQUEST['__pwreset__']['password'] ) && isset( $_REQUEST['tk'] ) ) {

	    // verifico che il token sia valido
		$account = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT account.* FROM account WHERE account.token = ?',
            array( array( 's' => $_REQUEST['tk'] ) )
        );

	    // se il token è valido
		if( ! empty( $account ) ) {

		    // imposto il flag per il modulo
			$_REQUEST['__pwreset__']['__tk_ok__'] = true;

		} else {

		    // messaggio
			$_REQUEST['__pwreset__']['__err__']['testo'] = array(
			    'it-IT' => 'il token non è valido'
			);

		}

	} elseif( isset( $_REQUEST['__pwreset__']['password'] ) && isset( $_REQUEST['tk'] ) ) {

	    // debug
		// echo 'cambio password';

	    // verifico che il token sia valido
		$account = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT account.* FROM account WHERE account.token = ?',
            array( array( 's' => $_REQUEST['tk'] ) )
        );

	    // se il token è valido
		if( ! empty( $account ) ) {

		    // aggiorno la password sul database
			mysqlQuery(
                $cf['mysql']['connection'],
                'UPDATE account SET password = ?, token = NULL WHERE id = ?',
                array( array( 's' => md5( $_REQUEST['__pwreset__']['password'] ) ), array( 's' => $account['id'] ) )
            );

		    // imposto il flag per il modulo
			$_REQUEST['__pwreset__']['__ok__']['testo'] = array(
			    'it-IT' => 'password reimpostata con successo'
			);

		} else {

		    // messaggio
			$_REQUEST['__pwreset__']['__err__']['testo'] = array(
			    'it-IT' => 'errore nel cambio password'
			);

		}

	}
