<?php

    /**
     * riceve in ingresso l'id di un progetto, calcola l'elenco dei possibili sostituti
     * e li scrive nella tabella di report __report_progetti_sostituti__ 
     * 
     *
     *
     * @todo commentare
     * @todo usare le funzioni di ACL per verificare se l'azione è autorizzata
     * @file
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
        $status['id'] = $_REQUEST['id'];

        // chiamo la funzione elencoSostitutiProgetto
        $status['info'][] = elencoSostitutiProgetto( $_REQUEST['id'] );

    } else {

        // status
        $status['err'][] = 'ID progetto non passato';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
