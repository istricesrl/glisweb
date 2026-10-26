<?php

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}

    // verifica dei privilegi
    checkTaskPrivilege( 'GESTIONE_CORSI' );

    // inizializzo l'array del risultato
	$status = array();

    // workspace
    $workspace = array();

    if( isset( $_REQUEST['idCorso'] ) && ! empty( $_REQUEST['idCorso'] ) ) {
        $workspace['id_corso'] = $_REQUEST['idCorso'];
    }

    // dal cron e' il ricalcolo notturno: anche le lezioni non cambiate da una settimana fa in avanti, in background
    // ( vedi il job )
    if( defined( 'CRON_RUNNING' ) ) {
        $workspace['notturno'] = 1;
    }

    // creo il job
    $status['inserimento'] = mysqlQuery(
        $cf['mysql']['connection'],
        'INSERT INTO job ( nome, job, iterazioni, se_foreground, workspace ) VALUES ( ?, ?, ?, ?, ? )',
        array(
            array( 's' => 'popolazione report lezioni corsi' ),
            array( 's' => '_mod/_0920.corsi/_src/_api/_job/_report.lezioni.corsi.popolazione.php' ),
            array( 's' => 2000 ),
            array( 's' => ( defined( 'CRON_RUNNING' ) ) ? NULL : 1 ),
            array( 's' => json_encode( $workspace ) )
        )
    );

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
