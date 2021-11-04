<?php

    /**
     *
     *
     *
     *
     * @todo commentare
     *
     * @file
     *
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../_config.php';
	}

    // inizializzo l'array del risultato
	$status = array();

    // log
	logWrite( 'inizio creazione pianificazione', 'pianificazione', LOG_ERR );

    if( isset($_REQUEST) && !empty($_REQUEST['__id__']) &&  !empty($_REQUEST['__table__']  )  ){

        $where = array();
        $params = array();

        $params[] = $_REQUEST['__table__'];

        $where[] = ' id_pianificazione = ? ';
        $params[] = $_REQUEST['__id__'];

        if( isset( $_REQUEST['__da__'] )){
            $where[] = ' timestamp_pianificazione > ? '; 
            $params[] = $_REQUEST['__da__'];
        }

        if(  isset( $_REQUEST['__a__'] ) ){
            $where[] = ' timestamp_pianificazione < ? '; 
            $params[] = $_REQUEST['__a__'];
        }

        $where = implode(' AND ', $where);

        $status['__status__'] = 'OK';
      
        $result = mysqlQuery( $cf['mysql']['connection'], 'DELETE FROM ?  WHERE '.$where, $params );

        if( $result && !empty( $_REQUEST['__delete__'] )){
            $result = $result && mysqlQuery( $cf['mysql']['connection'], 'DELETE FROM pianificazioni WHERE id = ?', array( array( 's' => $_REQUEST['__id__'] ) ) );
        }

        if( $restult ){
            $status['__status__'] = 'eliminazione pianificazione completata';
        } else {
            $status['__status__'] = 'eliminazione pianificazione NON completata: controllare i dati e la connessione';
        }

    } else {
	    $status['__status__'] = 'NO';
	}

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
