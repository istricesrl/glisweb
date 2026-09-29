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
    checkTaskPrivilege( 'GESTIONE_CORSI' );

    // inizializzo l'array del risultato
	$status = array();

    // log
	logWrite( 'richiesta generazione todo', 'todo' );

    if( isset($_REQUEST) && !empty($_REQUEST['__data__']) && !empty($_REQUEST['__anagrafica__']) && !empty($_REQUEST['__cliente__']) && !empty($_REQUEST['__luogo__']) ){

        $status['__status__'] = 'OK';
   
        if( empty($_REQUEST['__desc__']) || $_REQUEST['__desc__'] == ''){ $_REQUEST['__desc__'] = ' ';}
   
        $restult = pianificazioneTodo( $cf['mysql']['connection'], $_REQUEST['__anagrafica__'], $_REQUEST['__cliente__'], $_REQUEST['__luogo__'], $_REQUEST['__data__'], $_REQUEST['__ora__'] ?? NULL, $_REQUEST['__ore__'] ?? NULL, $_REQUEST['__p__'] ?? 0,$_REQUEST['__desc__'],$_REQUEST['__cad__'] ?? NULL, $_REQUEST['__datafine__'] ?? NULL, $_REQUEST['__nr__'] ?? 1,$_REQUEST['__gs__'] ?? NULL,$_REQUEST['__rm__'] ?? 1,$_REQUEST['__ra__'] ?? 1);
    
        if( $restult ){
            $status['__status__'] = 'Pianificazione completata';
        } else {
            $status['__status__'] = 'Pianificazione NON completata: controllare i dati e la connessione';
        }

    } else {
	    $status['__status__'] = 'NO';
	}

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
