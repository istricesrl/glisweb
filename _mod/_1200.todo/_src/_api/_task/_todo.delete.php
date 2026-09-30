<?php

    /**
     * effettua l'eliminazione di una todo e di tutti gli oggetti as essa collegati
     * - riceve in ingresso l'id della todo
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

    // TODO usare le funzioni di ACL per verificare se l'azione è autorizzata

    // inizializzo l'array del risultato
	$status = array();

    // verifico se è arrivata una todo
    if( ! empty( $_REQUEST['id'] ) ) {

        // ID della todo in oggetto
        $status['id_todo'] = $_REQUEST['id'];

        $status['delete'] = mysqlDeleteRowRecursive(
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'todo',
            $status['id_todo']
        );

        // aggiorno attivita_view_static e todo_view_static ( refresh_view_statiche e' stata dismessa il 2026-09-30 )
        cleanStaticView( $cf['mysql']['connection'], 'attivita' );
        refreshStaticView( $cf['mysql']['connection'], 'attivita' );

        cleanStaticView( $cf['mysql']['connection'], 'todo' );
        refreshStaticView( $cf['mysql']['connection'], 'todo' );


    } else {

        // status
        $status['err'][] = 'ID todo non passato';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
