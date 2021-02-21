<?php

    /**
     * il riempitore che gira ad es. ogni minuto e crea fisicamente gli oggetti. Questo prende le pianificazioni
     * che hanno data_fine > data_ultimo_oggetto e vede se ci sono oggetti da creare, li crea, aggiorna data_ultimo_oggetto
     * e pareggia data_fine = data_ultimo_oggetto > nome del task: _pianificazioni.populate.php
     *
     *
     *
     * @todo commentare
     * @todo usare le funzioni di ACL per verificare se l'azione è autorizzata
     * @file
     *
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}

    // TODO usare le funzioni di ACL per verificare se l'azione è autorizzata

    // inizializzo l'array del risultato
	$status = array();

    // chiave di lock
	$status['token'] = getToken();

    // se è specificato un ID, forzo la richiesta
    if( isset( $_REQUEST['id'] ) ) {

        // token della riga
        $status['id'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE pianificazioni SET token = ? WHERE id = ?',
            array(
                array( 's' => $status['token'] ),
                array( 's' => $_REQUEST['id'] )
            )
        );
        
    } else {

        // token della riga
        $status['id'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE pianificazioni SET token = ? WHERE giorni_rinnovo > 0 '.
            'AND timestamp_estensione < ? '.
            'AND token IS NULL '.
            'ORDER BY timestamp_popolazione ASC LIMIT 1',
            array(
                array( 's' => strtotime( '-1 day' ) ),
                array( 's' => $status['token'] )
            )
        );

    }

    // prelevo una riga dalla coda
    $current = mysqlSelectRow(
        $cf['mysql']['connection'],
        'SELECT pianificazioni.* '.
        'FROM pianificazioni '.
        'WHERE token = ? ',
        array( array( 's' => $status['token'] ) )
    );

    // se c'è almeno una riga da inviare
    if( ! empty( $current ) ) {

        // status
        $status['info'][] = 'popolo la pianificazione ' . $current['id'];

    } else {

        // status
        $status['info'][] = 'nessuna pianificazione da popolare';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
