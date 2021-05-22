<?php

    /**
     * riceve in ingresso l'id di un progetto e lo elimina
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

    // TODO usare le funzioni di ACL per verificare se l'azione è autorizzata

    // inizializzo l'array del risultato
	$status = array();

    // verifico se è arrivato un progetto
    if( ! empty( $_REQUEST['id'] ) ) {

        // ID del progetto in oggetto
        $status['id_progetto'] = $_REQUEST['id'];

        mysqlDeleteRowRecursive(
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'progetti',
            $_REQUEST['id']
        );

        // rimuovo le todo figlie del progetto
    /*    mysqlQuery(
            $cf['mysql']['connection'],
            'DELETE FROM todo WHERE id_progetto = ?',
            array(
                array( 's' => $_REQUEST['id'])
            )
        );

        // rimuovo le attività figlie del progetto
        mysqlQuery(
            $cf['mysql']['connection'],
            'DELETE FROM attivita WHERE id_progetto = ?',
            array(
                array( 's' => $_REQUEST['id'])
            )
        );

        // elimino il progetto
        mysqlQuery(
            $cf['mysql']['connection'],
            'DELETE FROM progetti WHERE id = ?',
            array(
                array( 's' => $_REQUEST['id'])
            )
        );
    */   

    } else {

        // status
        $status['err'][] = 'ID progetto non passato';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
