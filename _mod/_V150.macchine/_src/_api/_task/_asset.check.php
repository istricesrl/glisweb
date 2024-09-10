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
	    require '../../../../../_src/_config.php';
	}

    // inizializzo l'array del risultato
	$status = array();

    // input
    $status['input'] = file_get_contents('php://input');

    // dati
    $status['dati'] = json_decode( $status['input'], true );

    // status
	$status['info'][] = 'ricezione dati asset';

    // log
    logger( 'ricevuti dati da asset:' . print_r( $status['dati'], true ), 'asset' );

    // aggiorno i dati dell'asset
    if( ! empty( $status['dati']['hostname'] ) ) {

        // ...
        if( ! empty( $status['dati']['IP'] ) ) {

            // ...
            mysqlQuery(
                $cf['mysql']['connection'],
                'UPDATE asset SET ip_address = ?, timestamp_aggiornamento = ? WHERE hostname = ?',
                array(
                    array( 's' => $status['dati']['IP'] ),
                    array( 's' => time() ),
                    array( 's' => $status['dati']['hostname'] )
                )
            );

        }

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
