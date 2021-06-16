<?php

    /**
     *
     * task che analizza le attività senza id_anagrafica e calcola i possibili sostituti
     *      *
     *
     * @todo commentare
     *
     * @file
     *
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}

    // inizializzo l'array del risultato
	$status = array();

    // chiave di lock
	$status['token'] = getToken( __FILE__ );

    // se è specificato un ID, forzo la richiesta
    if( isset( $_REQUEST['id'] ) ) {

        // token della riga
        $status['update'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE attivita SET token = ? WHERE id = ?',
            array(
                array( 's' => $status['token'] ),
                array( 's' => $_REQUEST['id'] )
            )
        );
        
    } else {

        // token della riga (cerco le attività senza anagrafica associate a progetti)
        $status['update'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE attivita SET token = ? WHERE id_anagrafica IS NULL AND id_progetto IS NOT NULL '.
            'AND token IS NULL '.
            'ORDER BY timestamp_calcolo_sostituti ASC LIMIT 1',
            array(
                array( 's' => $status['token'] )
            )
        );

    }

    if( !empty( $status['update'] ) ){

        $cId = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT id FROM attivita WHERE token = ?',
            array(
                array( 's' => $status['token'] )
            )
        );

        $status['id'] =  $cId;

        sostitutiAttivita( $cId );

        // rilascio il token
        $status['sblocco'] = mysqlQuery( 
            $cf['mysql']['connection'],
            'UPDATE attivita SET timestamp_aggiornamento = ?, timestamp_calcolo_sostituti = ?, token = NULL WHERE token = ?', 
            array(
                array( 's' => time() ),
				array( 's' => time() ),
                array( 's' => $status['token'] )
            )
        );

    }
    else {

        // status
        $status['info'][] = 'nessuna attivita da calcolare';


    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
