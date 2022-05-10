<?php

    /**
     * effettua l'eliminazione di una todo e di tutti gli oggetti as essa collegati
     * - riceve in ingresso l'id della todo
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

    // verifico se è arrivata una todo
    if( ! empty( $_REQUEST['id'] ) ) {

    // log
	logWrite( 'richiesta generazione todo', 'todo', LOG_ERR );

    if( isset($_REQUEST) && !empty($_REQUEST['__data__']) && !empty($_REQUEST['__anagrafica__']) && !empty($_REQUEST['__cliente__']) && !empty($_REQUEST['__luogo__']) ){

        $status['__status__'] = 'OK';
   
        if( empty($_REQUEST['__desc__']) || $_REQUEST['__desc__'] == ''){ $_REQUEST['__desc__'] = ' ';}
   
        $restult = pianificazioneTodo( $cf['mysql']['connection'], $_REQUEST['__anagrafica__'], $_REQUEST['__cliente__'], $_REQUEST['__luogo__'], $_REQUEST['__data__'], $_REQUEST['__ora__'], $_REQUEST['__ore__'], $_REQUEST['__p__'],$_REQUEST['__desc__'],$_REQUEST['__cad__'], $_REQUEST['__datafine__'], $_REQUEST['__nr__'],$_REQUEST['__gs__'],$_REQUEST['__rm__'],$_REQUEST['__ra__']);
    
        if( $restult ){
            $status['__status__'] = 'Pianificazione completata';
        } else {
            $status['__status__'] = 'Pianificazione NON completata: controllare i dati e la connessione';
        }

    } else {
	    $status['__status__'] = 'NO';
	}



    } else {

        // status
        $status['err'][] = 'ID todo non passato';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
