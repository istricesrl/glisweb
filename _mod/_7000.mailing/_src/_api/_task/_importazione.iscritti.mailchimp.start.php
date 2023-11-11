<?php

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}

    // inizializzo l'array del risultato
	$status = array();

    // nome file di default
    if( ! isset( $_REQUEST['file'] ) ) { $_REQUEST['file'] = 'iscritti.csv'; }
    if( ! isset( $_REQUEST['lista'] ) ) { $_REQUEST['lista'] = 'DEFAULT'; }

    // creo il job
    $status['inserimento'] = mysqlQuery(
        $cf['mysql']['connection'],
        'INSERT INTO job ( nome, job, iterazioni, se_foreground, workspace ) VALUES ( ?, ?, ?, ?, ? )',
        array(
            array( 's' => 'importazione automatica iscritti alla newsletter' ),
            array( 's' => '_mod/_7000.mailing/_src/_api/_job/_importazione.iscritti.mailchimp.php' ),
            array( 's' => 1 ),
            array( 's' => 1 ),
            array( 's' => json_encode(
                array(
                    'file' => 'var/contenuti/upload/'.basename( $_REQUEST['file'] ),
                    'lista' => $_REQUEST['lista']
                )
            ) )
        )
    );

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
