<?php

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}

    // inizializzo l'array del risultato
	$status = array();

    // nome file di default
    if( ! isset( $_REQUEST['file'] ) ) { $_REQUEST['file'] = 'documenti.articoli.csv'; }

    // creo il job
    $status['inserimento'] = mysqlQuery(
        $cf['mysql']['connection'],
        'INSERT INTO job ( nome, job, iterazioni, se_foreground, workspace ) VALUES ( ?, ?, ?, ?, ? )',
        array(
            array( 's' => 'importazione automatica documenti' ),
            array( 's' => '_mod/_0400.documenti/_src/_api/_job/_documenti.articoli.importazione.php' ),
            array( 's' => 30 ),
            array( 's' => NULL ),
            array( 's' => json_encode(
                array(
                    'file' => 'var/contenuti/upload/'.basename( $_REQUEST['file'] )
                )
            ) )
        )
    );

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
