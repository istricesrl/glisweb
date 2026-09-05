<?php

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}

    // verifica dei privilegi
    checkTaskPrivilege( 'GESTIONE_CORSI' );

    // inizializzo l'array del risultato
	$status = array();

	// ...
	if( isset( $_REQUEST['idCorso'] ) ) {

		$status['delete'] = mysqlQuery(
			$cf['mysql']['connection'],
			'DELETE FROM __report_lezioni_corsi__ WHERE id_progetto = ?',
			array( array( 's' => $_REQUEST['idCorso'] ) )
		);

	} else {

		$status['delete'] = mysqlQuery(
			$cf['mysql']['connection'],
			'DELETE FROM __report_lezioni_corsi__',
		);

	}

	// output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
