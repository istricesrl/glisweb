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

    // verifica dei privilegi
    checkTaskPrivilege( 'GESTIONE_SISTEMA' );

    // inizializzo l'array del risultato
	$status = array();

    // log
	logWrite( 'inizio creazione pianificazione', 'pianificazione', LOG_ERR );

    if( isset($_REQUEST) && !empty($_REQUEST['__data__'])  ){

        $status['__status__'] = 'OK';
      
        // NOTA fino al 2026-09-25 qui si passava la connessione come primo argomento, residuo di una firma
        // precedente della funzione, e la chiamata finiva in un die() prima dell'output
        $result = creazionePianificazione( $_REQUEST['__data__'], $_REQUEST['__p__'] ?? 0, $_REQUEST['__cad__'] ?? NULL, $_REQUEST['__datafine__'] ?? NULL, $_REQUEST['__nr__'] ?? 1, $_REQUEST['__gs__'] ?? NULL, $_REQUEST['__rm__'] ?? 1, $_REQUEST['__ra__'] ?? 1 );
        $status['date'] = $result;
        if( $result ){
            $status['__status__'] = 'creazione pianificazione completata';
        } else {
            $status['__status__'] = 'creazione pianificazione NON completata: controllare i dati e la connessione';
        }

    } else {
	    $status['__status__'] = 'NO';
	}

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
