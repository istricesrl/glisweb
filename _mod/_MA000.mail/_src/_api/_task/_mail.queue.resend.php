<?php

    /**
     * reimmissione in coda di una mail inviata
     *
     * Questo task riporta una mail dall'archivio `mail_sent` alla coda `mail_out`, perché venga inviata di nuovo al
     * prossimo giro del task di invio ( `_mail.queue.send.php` ). Lo chiama la scheda strumenti di una mail inviata
     * ( `mail.sent.form.tools` ) con `id=<id>`; richiede il privilegio `GESTIONE_COMUNICAZIONI`.
     *
     * La riga viene marcata con il token del task, copiata in `mail_out` con lo stesso ID e cancellata da `mail_sent`; i
     * file collegati alla mail inviata ( `file.id_mail_sent` ) vengono collegati a quella in coda, prima della
     * cancellazione, il cui vincolo ON DELETE SET NULL azzera poi `file.id_mail_sent`: è il passaggio inverso di quello
     * che fa il task di invio. Nella coda il token, l'ora della marcatura ( `timestamp_elaborazione` ), i tentativi e la
     * data prevista vengono azzerati: la copia porterebbe con sé il token di questo giro, che la escluderebbe da tutte le
     * modalità di evasione, e la data di invio effettiva, che è già passata. Fino al 2026-09-29 il token non veniva
     * azzerato e la mail rimessa in coda non ripartiva mai. Se la copia fallisce la riga resta fra le inviate, senza
     * token, e l'errore va nel log `mail`. Il task ha un gemello per gli SMS nel modulo `SM000.sms`
     * ( `_mod/_SM000.sms/_src/_api/_task/_sms.queue.resend.php` ).
     *
     * @file
     *
     */

    // inclusione del framework
    if( ! defined( 'CRON_RUNNING' ) ) {
        if( ! defined( 'INCLUDE_SUBDIR' ) ) {
            require '../../../../../_src/_config.php';
        } else {
            require INCLUDE_SUBDIR . '_config.php';
        }
    }

    // verifica dei privilegi
    checkTaskPrivilege( 'GESTIONE_COMUNICAZIONI' );

    // inizializzo l'array del risultato
	$status = array();

    // status
	$status['info'][] = 'reimmissione in coda della mail';

    // log
	logWrite( 'richiesta di reimmissione in coda della mail inviata', 'mail' );

    // chiave di lock
    if( ! isset( $status['token'] ) ) {
        $status['token'] = getToken( __FILE__ );
    }

	// mail da reimmettere in coda
	if( isset( $_REQUEST['id'] ) ) {

		// status
		$status['info'][] = 'reimmissione specifico messaggio inviato';

        // token della riga
        $status['id'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE mail_sent SET token = ? WHERE id = ? AND token IS NULL',
            array(
                array( 's' => $status['token'] ),
                array( 's' => $_REQUEST['id'] )
            )
        );

	}

	// prelevo la mail dalla coda delle inviate
	$mail = mysqlSelectRow(
		$cf['mysql']['connection'],
		'SELECT * FROM mail_sent WHERE token = ?',
		array(
			array( 's' => $status['token'] )
		)
	);

	// se c'è una mail da rimettere in coda
	if( ! empty( $mail ) ) {

		// status
		$status['info'][] = 'trovata una mail da rimettere in coda';

        // rimetto la mail in coda
        $idMailRiaccodata = mysqlQuery(
            $cf['mysql']['connection'],
            'INSERT INTO mail_out SELECT * FROM mail_sent WHERE token = ?',
            array(
                array( 's' => $status['token'] )
            )
        );

        // se l'inserimento è andato a buon fine
        if( ! empty( $idMailRiaccodata ) ) {

            // azzero token, ora della marcatura, tentativi e data prevista
            mysqlQuery(
                $cf['mysql']['connection'],
                'UPDATE mail_out SET token = NULL, timestamp_elaborazione = NULL, tentativi = 0, timestamp_invio = NULL WHERE id = ?',
                array(
                    array( 's' => $mail['id'] )
                )
            );

            // reinserisco gli allegati
            mysqlQuery(
                $cf['mysql']['connection'],
                'UPDATE file SET id_mail_out = ? WHERE id_mail_sent = ?',
                array(
                    array( 's' => $mail['id'] ),
                    array( 's' => $mail['id'] )
                )
            );

            // elimino la mail dalla tabella delle mail inviate
            mysqlQuery(
                $cf['mysql']['connection'],
                'DELETE FROM mail_sent WHERE id = ?',
                array(
                    array( 's' => $mail['id'] )
                )
            );

            // log
            logWrite( 'mail #' . $mail['id'] . ' rimessa nella mail_out', 'mail' );

        } else {

            // libero la riga
            mysqlQuery(
                $cf['mysql']['connection'],
                'UPDATE mail_sent SET token = NULL WHERE token = ?',
                array(
                    array( 's' => $status['token'] )
                )
            );

            // log
            logWrite( 'impossibile rimettere in coda la mail #' . $mail['id'], 'mail', LOG_ERR );

            // status
            $status['err'][] = 'impossibile rimettere in coda la mail';

        }

    } else {

        // chiudo il ciclo
        $iter = ( ! empty( $task['iterazioni'] ) ) ? $task['iterazioni'] : 0;

		// status
		$status['info'][] = 'nessuna mail da rimettere in coda';

	}

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
