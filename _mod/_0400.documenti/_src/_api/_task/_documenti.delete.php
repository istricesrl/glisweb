<?php

    /**
     * effettua l'eliminazione di un progetto e di tutti gli oggetti as esso collegati
     * - se riceve in ingresso un id, analizza quel progetto
     * - altrimenti analizza i progetti che hanno il flag se_cancellare = 1
     * 
     *
     *
     * 
     *
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}

    // verifica dei privilegi
    checkTaskPrivilege( 'CANCELLAZIONE_RICORSIVA' );

    // inizializzo l'array del risultato
	$status = array();

    // verifiche formali
    if( ! in_array( 'CANCELLAZIONE_RICORSIVA', $_SESSION['account']['privilegi'], true ) ) {

        // status
        $status['err'][] = 'privilegi insufficenti';

    } elseif( empty( $_REQUEST['id'] ) ) {

        // status
        $status['err'][] = 'ID mancante';

    } else {

        mysqlDeleteRowRecursive(
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'documenti',
            $_REQUEST['id']
        );

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
