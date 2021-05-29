<?php

    /**
     * riceve in ingresso l'id di un progetto e setta il flag se_cancellare = 1
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

        $u = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE progetti SET se_cancellare = 1 WHERE id = ?',
            array( array( 's' => $status['id_progetto'] ) )
        );

        $status['info'][] = 'settati ' . $u . ' progetti da eliminare';

    } else {

        // status
        $status['err'][] = 'ID progetto non passato';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
