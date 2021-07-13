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

        // inserisco una richiesta di ripopolamento per attivita_view_static e todo_view_static
        mysqlQuery(
            $cf['mysql']['connection'],
            'INSERT INTO refresh_view_statiche (entita, note, timestamp_prenotazione) VALUES( ?, ?, ? )',
            array(
                array( 's' => 'attivita' ),
                array( 's' => '_mod/_1200.todo/_src/_api/_task/_todo.delete.php'),
                array( 's' => time() )
            )
        );

        mysqlQuery(
            $cf['mysql']['connection'],
            'INSERT INTO refresh_view_statiche (entita, note, timestamp_prenotazione) VALUES( ?, ?, ? )',
            array(
                array( 's' => 'todo' ),
                array( 's' => '_mod/_1200.todo/_src/_api/_task/_todo.delete.php'),
                array( 's' => time() )
            )
        );


    } else {

        // status
        $status['err'][] = 'ID todo non passato';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
