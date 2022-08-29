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
	    require '../../../../_src/_config.php';
	}

    // inizializzo l'array del risultato
	$status = array();

    // status
	$status['info'][] = 'click su banner';

    // log
	logWrite( 'richiesta di click su banner', 'banner' );

   // print_r($_SESSION['banner']);

    // recupero i dati
    if( isset( $_REQUEST['tkb'] ) && ! empty( $_REQUEST['tkb'] ) ) {
        if( isset( $_SESSION['banner']['token'][ $_REQUEST['tkb'] ] ) ) {

            // debug
            print_r( $_SESSION['banner']['token'][ $_REQUEST['tkb'] ] );

            // registro il click
            $status['visualizzazione'] = mysqlInsertRow(
                $cf['mysql']['connection'],
                array(
                    'id_banner' => $_SESSION['banner']['token'][ $_REQUEST['tkb'] ]['id'],
                    'azione' => 'click',
                    'timestamp_azione' => microtime( true )
                ),
                'banner_azioni'
            );

            // status code
            http_response_code( 301 );

            // redirect
            header( 'Location: ' . $_SESSION['banner']['token'][ $_REQUEST['tkb'] ]['href'] ); 

            // status
            buildJson( $status );
            
            // fine script
            exit;

        } else {
            $status['err'][] = 'informazioni non trovate per il token';
        }
    } else {
        $status['err'][] = 'token non presente';
    }

    // status
    buildJson( $status );
