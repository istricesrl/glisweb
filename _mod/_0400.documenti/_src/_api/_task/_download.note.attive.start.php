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
            array( 's' => 'importazione automatica note fatture elettroniche attive del ' . date( 'Y/m/d H:i' ) ),
            array( 's' => '_mod/_0400.documenti/_src/_api/_job/_download.note.attive.php' ),
            array( 's' => 1 ),
            array( 's' => json_encode(
                    array(
                        'aziende' => mysqlSelectColumn( 'codice_archivium', $cf['mysql']['connection'], 'SELECT DISTINCT codice_archivium FROM anagrafica WHERE codice_archivium IS NOT NULL' ),
                        'data' => ( ( isset( $_REQUEST['dateFrom'] ) ) ? $_REQUEST['dateFrom'] : date( 'Y-m-d', strtotime( '-1 day' ) ) )
                    )
                )
            )
        )
    );

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
