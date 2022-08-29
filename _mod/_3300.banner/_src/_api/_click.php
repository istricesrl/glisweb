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

    // status
	$status['info'][] = 'click su banner';

    // log
	logWrite( 'richiesta di click su banner', 'banner' );

    // recupero i dati
    if( isset( $_REQUEST['tkb'] ) && ! empty( $_REQUEST['tkb'] ) ) {
        if( isset( $_SESSION['banner'][ $_REQUEST['tkb'] ] ) ) {

            // registro il click
            $status['visualizzazione'] = mysqlInsertRow(
                $cf['mysql']['connection'],
                array(
                    'id_banner' => $_SESSION['banner'][ $_REQUEST['tkb'] ]['id'],
                    'azione' => 'click',
                    'timestamp_azione' => time()
                ),
                'banner_azioni'
            );

            // status code
            http_response_code( 301 );

            // redirect
            header( 'Location: ' . $_SESSION['banner'][ $_REQUEST['tkb'] ]['href'] ); 
    
            // fine script
            exit;

        }
    } else {
        buildJson( $status );
    }
