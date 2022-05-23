<?php

    // debug
	// echo 'REGISTRAZIONE';
	// print_r( $_REQUEST );

    // se non è impostato uno username, assumo che sia uguale alla mail
	if( ! isset( $_REQUEST['__signup__']['username'] ) && isset( $_REQUEST['__signup__']['email'] ) ) {
	    $_REQUEST['__signup__']['username'] = $_REQUEST['__signup__']['email'];
	}

    // ho ricevuto i dati per la registrazione
	if( isset( $_REQUEST['__signup__']['username'] ) && ! empty( $_REQUEST['__signup__']['username'] ) ) {

	    // verifico che il nome utente non sia già in uso
		$utente = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT * FROM account_view WHERE username = ? ',
					    array( array( 's' => $_REQUEST['__signup__']['username'] ) ) );

	    // verifico che la mail non sia già in uso
		$mail = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT * FROM mail_view WHERE indirizzo = ? ',
					    array( array( 's' => $_REQUEST['__signup__']['email'] ) ) );

	    // se l'utente non esiste già...
		if( ! $utente & ! $mail ) {

		    // creo il token
			$tk = $_REQUEST['__signup__']['tk'] = md5( $_REQUEST['__signup__']['username'] . $_REQUEST['__signup__']['password'] );

		    // debug
			// echo $tk;

			// TODO fare ramo di codice alternativo per registrazione con mail + sms
			if( true ) {

				// invio la mail con il link e il token
				$_REQUEST['__signup__']['activation']['mail']['id'] = queueMailFromTemplate(
					$cf['mysql']['connection'],
	#			    $cf['mail']['tpl']['DEFAULT_REGISTRAZIONE_ACCOUNT'],
	#			    $cf['mail']['tpl']['NUOVO_ACCOUNT'],
					$cf['mail']['tpl']['DEFAULT_NUOVO_ACCOUNT'],
					array( 'dt' => array_replace_recursive( $_REQUEST['__signup__'], array( 'tk' => $tk ) ), 'ct' => $ct ),
					strtotime( '+1 minutes' ),
					array( $_REQUEST['__signup__']['nome'] . ' ' . $_REQUEST['__signup__']['cognome'] => $_REQUEST['__signup__']['email'] ),
					$cf['localization']['language']['ietf']
				);

				// se la mail è stata accodata, imposto il flag per il modulo
				if( ! empty( $_REQUEST['__signup__']['activation']['mail']['id'] ) ) {

					$_REQUEST['__signup__']['__tk_sent__']['testo'] = array(
					'it-IT' => '<p>grazie per esserti registrato! controlla la mail fra qualche minuto per confermare il tuo account</p><p>ora puoi chiudere questa finestra</p>'
					);

				} else {

					$_REQUEST['__signup__']['__err__'][0]['testo'] = array( 'it-IT' => 'abbiamo riscontrato un problema nella creazione del tuo account, prova più tardi' );

				}

			} else {

				// TODO autenticazione con mail + sms

			}

		} else {

		    // TODO errore
		    if( $utente ) { $_REQUEST['__signup__']['__err__'][0]['testo'] = array('it-IT' => 'errore nome utente già in uso');  }
		    if( $mail ) {  $_REQUEST['__signup__']['__err__'][1]['testo'] = array('it-IT' =>'mail già in uso'); }
		}

	    // scrivo i dati di registrazione su un file temporaneo
		writeToFile( serialize( $_REQUEST['__signup__'] ), 'var/log/signup/' . $tk . '.txt' );

	} elseif( isset( $_REQUEST['tkm'] ) && isset( $_REQUEST['tks'] ) ) {

		// TODO verifica con token mail + token sms

	} elseif( isset( $_REQUEST['tk'] ) ) {

	    // se il token è valido
		if( file_exists( DIR_BASE . 'var/log/signup/' . $_REQUEST['tk'] . '.txt' ) ) {

		    // recupero i dati
			$dati = unserialize( readFromFile( 'var/log/signup/' . $_REQUEST['tk'] . '.txt', FILE_READ_AS_STRING ) );

		    // TODO verificare $dati['privacy']['policy'] e $dati['privacy']['account'] e $dati['privacy']['condizioni']

		    // creo l'anagrafica
			$idAnagrafica = mysqlQuery( $cf['mysql']['connection'], 'INSERT INTO anagrafica ( nome, cognome ) VALUES ( ?, ? )', array( array( 's' => $dati['nome'] ), array( 's' => $dati['cognome'] ) ) );

			// TODO prevedere la possibilità di inserire altri campi dell'anagrafica (ad es. indirizzo, partita IVA, codice fiscale, eccetera)

		    // creo la mail
			$idMail = mysqlQuery( $cf['mysql']['connection'], 'INSERT INTO mail ( id_anagrafica, indirizzo ) VALUES ( ?, ? )', array( array( 's' => $idAnagrafica ), array( 's' => $dati['email'] ) ) );

			// TODO prevedere la possibilità di associare categorie diverse a tipologie di registrazione diverse

		    // associo alle categorie
			foreach( $cf['registrazione']['default']['categorie'] as $categoria ) {

			    // recupero l'id della categoria
				$idCategoria = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT id FROM categorie_anagrafica WHERE nome = ?', array( array( 's' => $categoria ) ) );

			    // associo l'account
				if( ! empty( $idCategoria ) ) {
				    $idAnagraficaCategoria[] = mysqlQuery( $cf['mysql']['connection'], 'INSERT INTO anagrafica_categorie ( id_anagrafica, id_categoria ) VALUES ( ?, ? )', array( array( 's' => $idAnagrafica ), array( 's' => $idCategoria ) ) );
				}

			}

		    // creo l'account
			$idAccount = mysqlQuery( $cf['mysql']['connection'], 'INSERT INTO account ( id_anagrafica, username, password, id_mail, se_attivo ) VALUES ( ?, ?, ?, ?, ? )', array( array( 's' => $idAnagrafica ), array( 's' => $dati['username'] ), array( 's' => md5( $dati['password'] ) ), array( 's' => $idMail ), array( 's' => ( ( $cf['registrazione']['default']['attivo'] === true ) ? 1 : NULL ) ) ) );

		    // associo ai gruppi
			foreach( $cf['registrazione']['default']['gruppi'] as $gruppo ) {

			    // recupero l'id del gruppo
				$idGruppo = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT id FROM gruppi WHERE nome = ?', array( array( 's' => $gruppo ) ) );

			    // associo l'account
				if( ! empty( $idGruppo ) ) {
				    $idAccountGruppo[] = mysqlQuery( $cf['mysql']['connection'], 'INSERT INTO account_gruppi ( id_account, id_gruppo ) VALUES ( ?, ? )', array( array( 's' => $idAccount ), array( 's' => $idGruppo ) ) );
				}

			}

		    // debug
			// echo $idAnagrafica.'/'.$idMail.'/'.$idAccount.'/'.implode( '|', $idAccountGruppo );

		    // se la registrazione è andata a buon fine, imposto il flag per il modulo
			if( true ) {

			    // imposto il flag per il modulo
				$_REQUEST['__signup__']['__tk_ok__']['testo'] = array(
				    'it-IT' => '<p>grazie per aver confermato il tuo account! ora puoi effettuare il login</p>'
				);

			    // associo il carrello della sessione alla persona che ha appena fatto il login
				if( isset( $dati['carrello'] ) && ! empty( $dati['carrello'] ) ) {

				    //
					if( isset( $_SESSION['account']['id_anagrafica'] ) && ! empty( $_SESSION['account']['id_anagrafica'] ) ) {

					    // salvataggio di sicurezza
						$f = 'var/log/carts/cart.' . sprintf( '%08d', $dati['carrello'] ) . '.' . date('Yh') . '.signup.log';
						appendToFile( $dati['carrello'] . ' -> ' . $_SESSION['account']['id_anagrafica'], $f );

					    // associo
						mysqlQuery( $cf['mysql']['connection'], 'UPDATE carrelli SET intestazione_id_anagrafica = ? WHERE id = ?',
						    array(
							array( 's' => $_SESSION['account']['id_anagrafica'] ),
							array( 's' => $dati['carrello'] )
						    )
						);

					}

				}

			} else {

			    // TODO errore

			}

		} else {

		    // messaggio
			$_REQUEST['__signup__']['__err__']['testo'] = array(
			    'it-IT' => 'il token non è valido'
			);

		}

	}
