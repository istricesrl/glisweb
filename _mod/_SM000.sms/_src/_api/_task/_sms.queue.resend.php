<?php

    /**
     * reimmissione in coda di un SMS inviato
     *
     * Questo task riporta un SMS dall'archivio `sms_sent` alla coda `sms_out`, perché venga inviato di nuovo al prossimo
     * giro del task di invio. È il gemello di `_mod/_MA000.mail/_src/_api/_task/_mail.queue.resend.php` e lo chiama la
     * scheda strumenti di un SMS inviato ( `sms.sent.form.tools` ) con `id=<id>`; richiede il privilegio
     * `GESTIONE_COMUNICAZIONI`.
     *
     * La riga viene marcata con il token del task, copiata in `sms_out` con lo stesso ID e cancellata da `sms_sent`. Nella
     * coda il token, l'ora della marcatura ( `timestamp_elaborazione` ), i tentativi e la data prevista vengono azzerati:
     * la copia porterebbe con sé il token di questo giro, che la escluderebbe da tutte le modalità di evasione, e la data
     * di invio effettiva, che è già passata e la manderebbe comunque subito. Se la copia fallisce la riga resta fra gli inviati, senza token, e l'errore va nel log `sms`.
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
	$status['info'][] = 'reimmissione in coda dell\'SMS';

    // log
	logWrite( 'richiesta di reimmissione in coda dell\'SMS inviato', 'sms' );

    // chiave di lock
    if( ! isset( $status['token'] ) ) {
        $status['token'] = getToken( __FILE__ );
    }

	// SMS da reimmettere in coda
	if( isset( $_REQUEST['id'] ) ) {

		// status
		$status['info'][] = 'reimmissione specifico messaggio inviato';

        // token della riga
        $status['id'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE sms_sent SET token = ? WHERE id = ? AND token IS NULL',
            array(
                array( 's' => $status['token'] ),
                array( 's' => $_REQUEST['id'] )
            )
        );

	}

	// prelevo l'SMS dalla coda degli inviati
	$sms = mysqlSelectRow(
		$cf['mysql']['connection'],
		'SELECT * FROM sms_sent WHERE token = ?',
		array(
			array( 's' => $status['token'] )
		)
	);

	// se c'è un SMS da rimettere in coda
	if( ! empty( $sms ) ) {

		// status
		$status['info'][] = 'trovato un SMS da rimettere in coda';

        // rimetto l'SMS in coda
        $idSmsRiaccodato = mysqlQuery(
            $cf['mysql']['connection'],
            'INSERT INTO sms_out SELECT * FROM sms_sent WHERE token = ?',
            array(
                array( 's' => $status['token'] )
            )
        );

        // se l'inserimento è andato a buon fine
        if( ! empty( $idSmsRiaccodato ) ) {

            // azzero token, ora della marcatura, tentativi e data prevista
            mysqlQuery(
                $cf['mysql']['connection'],
                'UPDATE sms_out SET token = NULL, timestamp_elaborazione = NULL, tentativi = 0, timestamp_invio = NULL WHERE id = ?',
                array(
                    array( 's' => $sms['id'] )
                )
            );

            // elimino l'SMS dalla tabella degli SMS inviati
            mysqlQuery(
                $cf['mysql']['connection'],
                'DELETE FROM sms_sent WHERE id = ?',
                array(
                    array( 's' => $sms['id'] )
                )
            );

            // log
            logWrite( 'SMS #' . $sms['id'] . ' rimesso nella sms_out', 'sms' );

        } else {

            // libero la riga
            mysqlQuery(
                $cf['mysql']['connection'],
                'UPDATE sms_sent SET token = NULL WHERE token = ?',
                array(
                    array( 's' => $status['token'] )
                )
            );

            // log
            logWrite( 'impossibile rimettere in coda l\'SMS #' . $sms['id'], 'sms', LOG_ERR );

            // status
            $status['err'][] = 'impossibile rimettere in coda l\'SMS';

        }

    } else {

        // chiudo il ciclo
        $iter = ( ! empty( $task['iterazioni'] ) ) ? $task['iterazioni'] : 0;

		// status
		$status['info'][] = 'nessun SMS da rimettere in coda';

	}

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
