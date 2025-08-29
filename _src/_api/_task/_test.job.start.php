<?php

    /**
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * TODO documentare
     * 
     * 
     * 
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../_config.php';
	}

    // inizializzo l'array del risultato
	$status = array();

    // status
    $status['file'] = 'tmp/'.date('YmdHis').'.txt';

    // creo il file di esempio
    writeToFile( "pere\nmele\nbanane\nkiwi\npesche\nananas\nciliege", $status['file'] );

    // controllo che il file esista
    if( file_exists( DIR_BASE . $status['file'] ) ) {

        // creo il job
        $status['inserimento'] = mysqlQuery(
            $cf['mysql']['connection'],
            'INSERT INTO job ( nome, job, iterazioni, se_foreground, workspace ) VALUES ( ?, ?, ?, ?, ? )',
            array(
                array( 's' => 'job di test' ),
                array( 's' => '_src/_api/_job/_test.job.php' ),
                array( 's' => 1 ),
                array( 's' => 1 ),
                array( 's' => json_encode(
                    array(
                        'file' => $status['file'],
                        'function' => 'strtoupper'
                    )
                ) )
            )
        );

    } else {

        // debug
        logWrite( 'impossibile creare il file di test', 'task', LOG_CRIT );

        // status
        $status['error'][] = 'impossibile creare il file di test';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
