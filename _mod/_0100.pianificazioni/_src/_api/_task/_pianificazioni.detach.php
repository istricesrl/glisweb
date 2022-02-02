<?php

    /**
     * setta a NULL l'id_pianificazione dell'oggetto indicato tramite ID e entità
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

    // verifico se è arrivata una data
    if( ! empty( $_REQUEST['id'] ) ) {

        // ID della pianificazione in oggetto
        $status['id'] = $_REQUEST['id'];

        // verifico se la pianificazione esiste
        if( ! empty( $_REQUEST['entita'] ) ) {

            // entità su cui fare il match
            $status['entita'] = $_REQUEST['entita'];

            // query
            $q = 'UPDATE ' . $status['entita'] . ' SET id_pianificazione = NULL WHERE id = ?';

            // esecuzione della query
            $status['esito'] = mysqlQuery( $cf['mysql']['connection'], $q, array( array( 's' => $status['id'] ) ) );

        } else {

            // status
            $status['err'][] = 'entita non passata';

        }

    } else {

        // status
        $status['err'][] = 'ID pianificazione non passato';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
