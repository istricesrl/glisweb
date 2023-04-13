<?php

    if( isset( $_REQUEST['__profile__']['email'] ) ) {

        // creo il token
        $tk = $_REQUEST['__profile__']['tk'] = md5( $_REQUEST['__profile__']['email'] . $_REQUEST['__profile__']['nome'] );

        // debug
        // echo $tk;

        // invio la mail con il link e il token
        $_REQUEST['__profile__']['update']['mail']['id'] = queueMailFromTemplate(
            $cf['mysql']['connection'],
#			    $cf['mail']['tpl']['DEFAULT_REGISTRAZIONE_ACCOUNT'],
#			    $cf['mail']['tpl']['NUOVO_ACCOUNT'],
            $cf['mail']['tpl']['DEFAULT_AGGIORNAMENTO_DATI'],
            array( 'dt' => array_replace_recursive( $_REQUEST['__profile__'], array( 'tk' => $tk ) ), 'ct' => $ct ),
            strtotime( '+1 minutes' ),
            array( $_REQUEST['__profile__']['nome'] . ' ' . $_REQUEST['__profile__']['cognome'] => $_REQUEST['__profile__']['email'] ),
            $cf['localization']['language']['ietf']
        );

        // se la mail è stata accodata, imposto il flag per il modulo
        if( ! empty( $_REQUEST['__profile__']['update']['mail']['id'] ) ) {

            $_REQUEST['__profile__']['__tk_sent__']['testo'] = array(
                'it-IT' => '<p>per la tua sicurezza, ti abbiamo mandato una richiesta di conferma delle modifiche!</p><p>controlla la mail fra qualche minuto, ora puoi chiudere questa finestra</p>'
            );

        } else {

            $_REQUEST['__profile__']['__err__'][0]['testo'] = array( 'it-IT' => 'abbiamo riscontrato un problema nella modifica del tuo account, prova più tardi' );

        }

        // aggiungo l'id anagrafico
        $_REQUEST['__profile__']['id_anagrafica'] = $_SESSION['account']['id_anagrafica'];

	    // scrivo i dati di registrazione su un file temporaneo
		writeToFile( serialize( $_REQUEST['__profile__'] ), 'var/log/updates/' . $tk . '.txt' );

    } elseif( isset( $_REQUEST['tk'] ) ) {

	    // se il token è valido
		if( file_exists( DIR_BASE . 'var/log/updates/' . $_REQUEST['tk'] . '.txt' ) ) {

		    // recupero i dati
			$dati = unserialize( readFromFile( 'var/log/updates/' . $_REQUEST['tk'] . '.txt', FILE_READ_AS_STRING ) );

            mysqlQuery(
                $cf['mysql']['connection'],
                'UPDATE anagrafica SET nome = ?, cognome = ? WHERE id = ?',
                array(
                    array( 's' => $dati['nome'] ),
                    array( 's' => $dati['cognome'] ),
                    array( 's' => $dati['id_anagrafica'] )
                )
            );

            $idm = mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT id FROM mail WHERE id_anagrafica = ? ORDER BY id LIMIT 1',
                array(
                    array( 's' => $dati['id_anagrafica'] )
                )
            );

            mysqlQuery(
                $cf['mysql']['connection'],
                'UPDATE mail SET indirizzo = ? WHERE id = ?',
                array(
                    array( 's' => $dati['email'] ),
                    array( 's' => $idm )
                )
            );

		    // se la modifica è andata a buon fine, imposto il flag per il modulo
			if( true ) {

                // imposto il flag per il modulo
                $_REQUEST['__profile__']['__tk_ok__']['testo'] = array(
                    'it-IT' => '<p>grazie per aver aggiornato il tuo account!</p>'
                );

            }

        } else {

            $_REQUEST['__profile__']['__err__'][0]['testo'] = array( 'it-IT' => 'abbiamo riscontrato un problema nella conferma alla modifica del tuo account, prova più tardi' );

        }

    }

    if( isset( $_SESSION['account']['id_anagrafica'] ) ) {

        $_REQUEST['__profile__']['nome'] = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT nome FROM anagrafica WHERE id = ?',
            array( array( 's' => $_SESSION['account']['id_anagrafica'] ) )
        );

        $_REQUEST['__profile__']['cognome'] = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT cognome FROM anagrafica WHERE id = ?',
            array( array( 's' => $_SESSION['account']['id_anagrafica'] ) )
        );

        $_REQUEST['__profile__']['email'] = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT indirizzo FROM mail WHERE id_anagrafica = ? ORDER BY id LIMIT 1',
            array( array( 's' => $_SESSION['account']['id_anagrafica'] ) )
        );

    }