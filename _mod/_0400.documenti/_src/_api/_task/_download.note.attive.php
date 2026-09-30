<?php

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}

    // verifica dei privilegi
    checkTaskPrivilege( 'GESTIONE_DOCUMENTI' );

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

        // aggiornamento di attivita_view_static ( la procedura attivita_view_static() non esiste piu' da marzo 2026 )
        cleanStaticView( $cf['mysql']['connection'], 'attivita' );
        $status['static'] = refreshStaticView( $cf['mysql']['connection'], 'attivita' );

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
