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
        'INSERT INTO job ( nome, job, iterazioni, workspace ) VALUES ( ?, ?, ?, ? )',
        array(
            array( 's' => 'importazione automatica fatture elettroniche passive del ' . date( 'Y/m/d H:i' ) ),
            array( 's' => '_mod/_6200.documenti/_src/_api/_job/_download.fe.passive.php' ),
            array( 's' => 1 ),
            array( 's' => json_encode(
                array(
                    'aziende' => mysqlSelectColumn( 'codice_archivium', $cf['mysql']['connection'], 'SELECT DISTINCT codice_archivium FROM anagrafica WHERE codice_archivium IS NOT NULL' ),
#                    'data' => date( 'Y-m-d', strtotime( '-1 day' ) )
                    'data' => '2022-01-05'
                )
            ) )
        )
    );

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
