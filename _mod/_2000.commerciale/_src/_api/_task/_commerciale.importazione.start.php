<?php

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}

    // inizializzo l'array del risultato
	$status = array();

    // nome file di default
    if( ! isset( $_REQUEST['file'] ) ) { $_REQUEST['file'] = 'commerciale.csv'; }

    // creo il job
    $status['inserimento'] = mysqlQuery(
        $cf['mysql']['connection'],
        'INSERT INTO job ( nome, job, iterazioni, se_foreground, workspace ) VALUES ( ?, ?, ?, ?, ? )',
        array(
            array( 's' => 'importazione automatica azioni commerciali' ),
            array( 's' => '_mod/_2000.commerciale/_src/_api/_job/_commerciale.importazione.php' ),
            array( 's' => 15 ),
            array( 's' => 1 ),
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
