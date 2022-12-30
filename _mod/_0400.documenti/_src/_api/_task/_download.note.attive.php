<?php

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}

    // inizializzo l'array del risultato
	$status = array();

    // ...
    if( isset( $_REQUEST['idDocumento'] ) && isset( $_REQUEST['idAzienda'] ) ) {

        // scarico la lista
        $status['lista'] = archiviumGetListaNoteAttive( $_REQUEST['idAzienda'], 0, 'ID=ASC', 'RIGHT', 'IDArchiviumFE=' . $_REQUEST['idDocumento'] );

        // registrazione note
        foreach( $status['lista'] as $nota ) {

            // registrazione
            $status['registrazione'][ $nota['ID'] ] = archiviumRegistraNotaAttiva( $_REQUEST['idAzienda'], $nota );

        }

        // ...
        $status['static'] = mysqlQuery( $cf['mysql']['connection'], 'CALL attivita_view_static( ? )', array( array( 's' => NULL ) ) );

        // debug
        // print_r( $status );

    } else {

        // status
        $status['err'][] = 'idDocumento e idAzienda non specificati';
    
    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
