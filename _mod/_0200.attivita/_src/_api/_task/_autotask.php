<?php

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}
   
    // inizializzo l'array del risultato
	$status = array();

    // chiave di lock
	$status['token'] = getToken( __FILE__ );

	// modalità di evasione (specifica mail, evasione forzata, evasione totale, evasione naturale)
	if( isset( $_REQUEST['id'] ) ) {

		// status
		$status['info'][] = 'evasione specifica attività';

        // token della riga
        $status['id'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE attivita SET token = ? WHERE id = ? AND token IS NULL',
            array(
                array( 's' => $status['token'] ),
                array( 's' => $_REQUEST['id'] )
            )
        );

	} else {

		// status
		$status['info'][] = 'strategia standard di evasione delle attività';
/*
		// token della riga
        $status['trovate'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE attivita LEFT JOIN metadati ON metadati.id_tipologia_attivita = attivita.id_tipologia '.
            'SET token = ? '.
            'WHERE metadati.nome = "autotask|attivo" '.
            'AND ( attivita.data_programmazione >= date_format( now(), "%Y-%m-%d" ) OR attivita.data_programmazione IS NULL ) '.
            'AND ( attivita.ora_inizio_programmazione >= date_format( now(), "%H:%i:%s" ) OR attivita.ora_inizio_programmazione IS NULL ) '.
            'AND attivita.data_attivita IS NULL AND attivita.token IS NULL '.
            'LIMIT 1',
            array(
                array( 's' => $status['token'] )
            )
        );
*/

		// token della riga
        $status['trovate'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE attivita '.
            'SET token = ? '.
            'WHERE attivita.id_tipologia IN ( '.
            'SELECT metadati.id_tipologia_attivita '.
            'FROM metadati '.
            'WHERE metadati.nome = "autotask|attivo" '.
            ' )'.
            'AND ( attivita.data_programmazione >= date_format( now(), "%Y-%m-%d" ) OR attivita.data_programmazione IS NULL ) '.
            'AND ( attivita.ora_inizio_programmazione >= date_format( now(), "%H:%i:%s" ) OR attivita.ora_inizio_programmazione IS NULL ) '.
            'AND attivita.data_attivita IS NULL AND attivita.token IS NULL '.
            'LIMIT 1',
            array(
                array( 's' => $status['token'] )
            )
        );

	}

	// prelevo un'attività dalla coda'
	$attivita = mysqlSelectRow(
		$cf['mysql']['connection'],
		'SELECT attivita.*, m1.testo AS macro FROM attivita LEFT JOIN metadati AS m1 ON ( m1.id_tipologia_attivita = attivita.id_tipologia AND m1.nome = "autotask|macro" ) WHERE token = ?',
		array(
			array( 's' => $status['token'] )
		)
	);

	// se c'è almeno un'attività da sbrigare
	if( ! empty( $attivita ) ) {

        // timestamp di inizio attività
        $tsInizio = time();

        // se è prevista una macro custom
        if( isset( $attivita['macro'] ) && ! empty( $attivita['macro'] ) ) {
            require DIR_BASE . $attivita['macro'];
        }

        // timestamp di fine attività
        $tsFine = time();

        // aggiorno la timestamp di completamento
        mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE attivita SET data_attivita = ?, ora_inizio = ?, ora_fine = ?, token = NULL WHERE token = ?',
            array(
                array( 's' => date( 'Y-m-d', $tsInizio ) ),
                array( 's' => date( 'H:i:s', $tsInizio ) ),
                array( 's' => date( 'H:i:s', time() ) ),
                array( 's' => $status['token'] )
            )
        );

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
