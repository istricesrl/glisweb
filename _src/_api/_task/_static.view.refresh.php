<?php

    /**
     *
     *
     *
     *
     * @todo commentare
     *
     * @file
     *
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../_config.php';
	}

    // inizializzo l'array del risultato
	$status = array();

    // chiave di lock
    if( ! isset( $status['token'] ) ) {
        $status['token'] = getToken( __FILE__ );
    }

    // blocco una riga
    $status['lock'] = mysqlSelectRow(
        $cf['mysql']['connection'],
        'UPDATE refresh_view_statiche SET token = ? WHERE token IS NULL ORDER BY timestamp_prenotazione ASC LIMIT 1',
        array(
            array( 's' => $status['token'] )
        )
    );

    // seleziono le view statiche da aggiornare
    $status['row'] = mysqlSelectRow(
        $cf['mysql']['connection'],
        'SELECT * FROM refresh_view_statiche WHERE token = ?',
        array(
            array( 's' => $status['token'] )
        )
    );

    // se c'è una riga da chiamare
    if( ! empty( $status['row'] ) ) {

        // aggiorno la vista
        $status['refresh'] = mysqlQuery(
            $cf['mysql']['connection'],
            'CALL ' . $status['row']['entita'] . '_view_static(NULL)'
        );

        // elimino la richiesta
        $status['remove'] = mysqlQuery(
            $cf['mysql']['connection'],
            'DELETE FROM refresh_view_statiche WHERE token = ?',
            array(
                array( 's' => $status['token'] )
            )
        );
    
    } else {

        // output
        $status['row'] = 'nessuna riga da elaborare';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
