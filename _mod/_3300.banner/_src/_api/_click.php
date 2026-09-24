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

        // status
        $status['info'][] = 'ricevuto token ' . $_REQUEST['tkb'];

        // recupero i dati del banner
        $banner = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT banner.*, immagini.path AS src, contenuti.url_custom AS href FROM banner LEFT JOIN immagini ON immagini.id_banner = banner.id LEFT JOIN contenuti ON contenuti.id_banner = banner.id LEFT JOIN banner_azioni ON banner_azioni.id_banner = banner.id WHERE banner_azioni.token = ? LIMIT 1',
            array(
                array( 's' => $_REQUEST['tkb'] )
            )
        );
    
        if( ! empty( $banner ) ) {

            // debug
            // print_r( $_SESSION['banner']['token'][ $_REQUEST['tkb'] ] );

            // registro il click
            $status['visualizzazione'] = mysqlInsertRow(
                $cf['mysql']['connection'],
                array(
                    'id_banner' => $banner['id'],
                    'azione' => 'click',
                    'timestamp_azione' => microtime( true ),
                    'token' => $_REQUEST['tkb']
                ),
                'banner_azioni'
            );

            // status code
            http_response_code( 301 );

            // redirect
            header( 'Location: ' . $banner['href'] ); 

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
