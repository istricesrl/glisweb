<?php

    /**
     * l'allungatore che gira ad es. una volta a settimana e deve allungare la pianificazione. Questo prende tutte le pianificazioni tali
     * per cui (giorni_rinnovo > 0 AND data_fine < oggi + giorni_rinnovo) che quindi sono da allungare e aggiorna
     * data_fine = oggi + giorni_rinnovo > nome del task: _pianificazioni.extend.php
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

    // chiave di lock
    if( ! isset( $status['token'] ) ) {
        $status['token'] = getToken( __FILE__ );
    }

    // se è specificato un ID, forzo la richiesta
    if( isset( $_REQUEST['id'] ) ) {

        // token della riga
        $status['id'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE pianificazioni SET token = ? WHERE id = ?',
            array(
                array( 's' => $status['token'] ),
                array( 's' => $_REQUEST['id'] )
            )
        );
        
    } else {

        // token della riga
        $status['id'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE pianificazioni SET token = ? WHERE giorni_rinnovo > 0 '.
            'AND ( timestamp_estensione < ? OR timestamp_estensione IS NULL ) '.
            'AND token IS NULL '.
            'ORDER BY timestamp_estensione ASC LIMIT 1',
            array(
                array( 's' => $status['token'] ),
                array( 's' => strtotime( '-1 day' ) )
            )
        );

    }

    // prelevo una riga dalla coda
    $current = mysqlSelectRow(
        $cf['mysql']['connection'],
        'SELECT pianificazioni.* '.
        'FROM pianificazioni '.
        'WHERE token = ? ',
        array( array( 's' => $status['token'] ) )
    );

    // se c'è almeno una riga da inviare
    if( ! empty( $current ) ) {

        // questa parte sostituisce quella dopo per il calcolo della nuova data di fine: se mi arriva in request uso quella
        if( !empty( $_REQUEST['data_fine'] ) ){
            $status['fine'] = $_REQUEST['data_fine'];
        }
        else{
            // calcolo la nuova data di fine
            $status['fine'] = date( 'Y-m-d', strtotime( '+' . $current['giorni_rinnovo'] . ' days' ) );
        }

        // calcolo la nuova data di fine
#        $status['fine'] = date( 'Y-m-d', strtotime( '+' . $current['giorni_rinnovo'] . ' days' ) );
        

        // se la nuova data di fine è successiva all'attuale data di fine
        if( $status['fine'] > $current['data_fine'] ) {

            // query
            $q = 'UPDATE pianificazioni SET data_fine = ?, timestamp_estensione = ?, token = NULL WHERE token = ?';

            // esecuzione della query
            $status['prolungamento'] = mysqlQuery( $cf['mysql']['connection'], $q, array(
                array( 's' => $status['fine'] ),
                array( 's' => time() ),
                array( 's' => $status['token'] ) )
            );

            // se mi arriva un parametro hard chiamo la populate che crea gli eventi per la pianificazione appena estesa
           if( ! empty( $_REQUEST['hard'] ) ) {
                $status['hard'] = $_REQUEST['hard'];
                $status['populate'] = restcall(
                    $cf['site']['url'] . '_mod/_0750.pianificazioni/_src/_api/_task/_pianificazioni.populate.php?id=' . $current['id']
                );
            }

        } else {

            // query
            $q = 'UPDATE pianificazioni SET timestamp_estensione = ?, token = NULL WHERE token = ?';

            // esecuzione della query
            $status['sblocco'] = mysqlQuery( $cf['mysql']['connection'], $q, array(
                array( 's' => time() ),
                array( 's' => $status['token'] ) )
            );

        }

    } else {

        // status
        $status['info'][] = 'nessuna pianificazione da estendere';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
