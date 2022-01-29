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

        mysqlDeleteRowRecursive(
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'progetti',
            $status['id_progetto']
        );

        // inserisco una richiesta di ripopolamento per attivita_view_static e todo_view_static
        mysqlQuery(
            $cf['mysql']['connection'],
            'INSERT INTO refresh_view_statiche (entita, note, timestamp_prenotazione) VALUES( ?, ?, ? )',
            array(
                array( 's' => 'attivita' ),
                array( 's' => '_mod/_1000.produzione/_src/_api/_task/_progetti.delete.php'),
                array( 's' => time() )
            )
        );

        mysqlQuery(
            $cf['mysql']['connection'],
            'INSERT INTO refresh_view_statiche (entita, note, timestamp_prenotazione) VALUES( ?, ?, ? )',
            array(
                array( 's' => 'todo' ),
                array( 's' => '_mod/_1000.produzione/_src/_api/_task/_progetti.delete.php'),
                array( 's' => time() )
            )
        );


    } else {

        // status
        $status['err'][] = 'ID progetto non passato';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
