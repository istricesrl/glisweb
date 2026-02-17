<?php

    /**
     *
     *
     *
     *
     * TODO commentare
     *
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

    // inizializzo la variabile per l'invio
	// $mail = NULL;

	// modalità di evasione (specifica mail, evasione forzata, evasione totale, evasione naturale)
	if( isset( $_REQUEST['id'] ) ) {

		// status
		$status['info'][] = 'evasione specifico messaggio in coda';

        // token della riga
        $status['id'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE mail_sent SET token = ? WHERE id = ?',
            array(
                array( 's' => $status['token'] ),
                array( 's' => $_REQUEST['id'] )
            )
        );

	}

	// prelevo una mail dalla coda
	$mail = mysqlSelectRow(
		$cf['mysql']['connection'],
		'SELECT * FROM mail_sent WHERE token = ?',
		array(
			array( 's' => $status['token'] )
		)
	);

	// se c'è almeno una mail da inviare
	if( ! empty( $mail ) ) {

		// status
		$status['info'][] = 'trovata una mail da rimettere in coda';

        // rimetto la mail in coda
        $idMailRiaccodata = mysqlQuery(
            $cf['mysql']['connection'],
            'INSERT INTO mail_out SELECT * FROM mail_sent WHERE id = ?',
            array(
                array( 's' => $mail['id'] )
            )
        );

        // se l'inserimento è andato a buon fine
        if( ! empty( $idMailRiaccodata ) ) {

            // reinserisco gli allegati
            mysqlQuery(
                $cf['mysql']['connection'],
                'UPDATE file SET id_mail_out = ? WHERE id_mail_sent = ?',
                array(
                    array( 's' => $idMailRiaccodata ),
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

        }

    } else {

        // chiudo il ciclo
        $iter = ( ! empty( $task['iterazioni'] ) ) ? $task['iterazioni'] : 0;

		// status
		$status['info'][] = 'nessuna mail da evadere';

	}

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
