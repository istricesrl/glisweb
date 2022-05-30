<?php

    /**
     * task che viene richiamato manualmente, riceve in ingresso mese e anno e crea un job che compila la tabella cartellini
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

    // verifico se sono arrivati mese e anno
    if( ! empty( $_REQUEST['a']['id'] ) && ! empty( $_REQUEST['a']['action'] ) ) {

        // mese e anno
        $status['attivita'] = $_REQUEST['a']['id'];
        if(  $_REQUEST['a']['action'] == 'start' ){
            $status['action'] = 'inizio timbratura';
        } else {
            $status['action'] = 'fine timbratura';
        }
   
        $set = '';
        $params = array();

        if(  $_REQUEST['a']['action'] == 'start' ){

            if( isset( $_REQUEST['a']['ora_inizio'] ) && isset( $_REQUEST['a']['data_attivita'] ) ){

                $set .= 'ora_inizio = ?, data_attivita = ? ';
                $params[] = array( 's' => $_REQUEST['a']['ora_inizio'] );
                $params[] = array( 's' => $_REQUEST['a']['data_attivita'] );

            } else {
                $status['err'][] = 'data e ora timbratura non passati';
            }

            if( isset( $_REQUEST['a']['latitudine_ora_inizio'] ) && isset( $_REQUEST['a']['longitudine_ora_inizio'] ) ){

                $set .= ', latitudine_ora_inizio = ?, longitudine_ora_inizio = ? ';
                $params[] = array( 's' => $_REQUEST['a']['latitudine_ora_inizio'] );
                $params[] = array( 's' => $_REQUEST['a']['longitudine_ora_inizio'] );
                $status['geo'][] = 'geolocalizzazione trovata';

            } else {
                $status['geo'][] = 'geolocalizzazione assente';
            }

        } else {

            if( isset( $_REQUEST['a']['ora_fine'] ) ){

                $set .= 'ora_fine = ? ';
                $params[] = array( 's' => $_REQUEST['a']['ora_fine'] );

            } else {
                $status['err'][] = 'ora fine timbratura non passata';
            }

            if( isset( $_REQUEST['a']['latitudine_ora_fine'] ) && isset( $_REQUEST['a']['longitudine_ora_fine'] ) ){

                $set .= ',latitudine_ora_fine = ?, longitudine_ora_fine = ? ';
                $params[] = array( 's' => $_REQUEST['a']['latitudine_ora_fine'] );
                $params[] = array( 's' => $_REQUEST['a']['longitudine_ora_fine'] );
                $status['geo'][] = 'geolocalizzazione trovata';

            } else {
                $status['geo'][] = 'geolocalizzazione assente';
            }

        }
       
        $params[] = array( 's' => $_REQUEST['a']['id'] );

        // verifico se è già presente un job di creazione cartellino per il mese e l'anno correnti
        $q = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE attivita SET '.$set.' WHERE id = ?', $params
        );

        if( $q ){

            $status['status'] = 'OK';

        } else{
            // status
            $status['status'] = 'KO';
        }

    } else {

        // status
        $status['err'][] = 'id o azione non passati';

    }
    
    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
