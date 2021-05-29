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

        $status['info'][] = 'bypasso i trigger';

        // bypasso i trigger
        $troff = mysqlQuery(
            $cf['mysql']['connection'],
            'SET @TRIGGER_LAZY = 1'
        );

        mysqlDeleteRowRecursive(
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'progetti',
            $status['id_progetto']
        );

        $status['info'][] = 'riattivo i trigger e ripopolo le statiche';

        // riattivo i trigger e ripopolo le statiche di todo e attivita
        $tron = mysqlQuery(
            $cf['mysql']['connection'],
            'SET @TRIGGER_LAZY = NULL'
        );

        $t = mysqlQuery(
            $cf['mysql']['connection'],
            'CALL todo_view_static(NULL)'
        );
                               
        $a = mysqlQuery(
            $cf['mysql']['connection'],
            'CALL attivita_view_static(NULL)'
        );

    } else {

        // status
        $status['err'][] = 'ID progetto non passato';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
