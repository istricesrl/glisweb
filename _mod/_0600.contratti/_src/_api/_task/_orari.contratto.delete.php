<?php

/**
     *
     * il task effettua l'eliminazione degli orari (di lavoro, non di disponibilità) relativi a un certo contratto
     *
     * riceve in ingresso
     * - id: id del contratto
     * 
     *
     * @todo documentare
     *
     * @file
     *
     */


     if( ! defined( 'CRON_RUNNING' ) ) {
        require '../../../../../_src/_config.php';
    }

    // inizializzo l'array del risultato
    $status = array();
    
    if( isset( $_REQUEST['id'] ) ){

        $status['id_contratto'] = $_REQUEST['id'];
      
        $del = mysqlQuery(
            $cf['mysql']['connection'],
            'DELETE FROM orari_contratti WHERE id_contratto = ? AND se_lavoro = 1',
            array(
                array( 's' => $_REQUEST['id'] )
            )
        );

        $tatus['info'][] = 'eliminate ' . $del . ' righe dalla tabella orari_contratti';
        
    }
    else{
        $status['error'] = true;
	    $status['message'] = 'non sono stati passati tutti i parametri necessari';
    }

        // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
