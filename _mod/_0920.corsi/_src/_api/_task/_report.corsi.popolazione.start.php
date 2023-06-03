<?php

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}

    // inizializzo l'array del risultato
	$status = array();

    // creo il job
    $status['inserimento'] = mysqlQuery(
        $cf['mysql']['connection'],
        'INSERT INTO job ( nome, job, iterazioni, se_foreground, workspace ) VALUES ( ?, ?, ?, ?, ? )',
        array(
            array( 's' => 'popolazione report corsi' ),
            array( 's' => '_mod/_0920.corsi/_src/_api/_job/_report.corsi.popolazione.php' ),
            array( 's' => 15 ),
            array( 's' => 1 ),
            array( 's' => json_encode( array() ) )
        )
    );

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
