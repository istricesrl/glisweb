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

    // TODO usare le funzioni di ACL per verificare se l'azione è autorizzata

    // inizializzo l'array del risultato
	$status = array();

    // verifico se è arrivato un progetto
    if( ! empty( $_REQUEST['id'] ) ) {

        // ID del progetto in oggetto
        $status['id_progetto'] = $_REQUEST['id'];
    }
    else{
        $status['id_progetto'] = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT id FROM progetti WHERE se_cancellare = 1 ORDER BY timestamp_aggiornamento LIMIT 1'
        );
    }

    if( !empty( $status['id_progetto'] ) ){

        mysqlDeleteRowRecursive(
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'progetti',
            $status['id_progetto']
        );

        // aggiorno attivita_view_static e todo_view_static ( refresh_view_statiche e' stata dismessa il 2026-09-30 )
        cleanStaticView( $cf['mysql']['connection'], 'attivita' );
        refreshStaticView( $cf['mysql']['connection'], 'attivita' );

        cleanStaticView( $cf['mysql']['connection'], 'todo' );
        refreshStaticView( $cf['mysql']['connection'], 'todo' );


    } else {

        // status
        $status['err'][] = 'ID progetto non passato';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
