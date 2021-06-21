<?php

/**
     *
     * il task effettua l'eliminazione degli orari contratto (di lavoro, non di disponibilità) relativi a un certo contratto e turno
     *
     * riceve in ingresso
     * - id: id del contratto
     * - t: numero del turno da eliminare
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
    
    if( isset( $_REQUEST['id'] ) && isset( $_REQUEST['t'] ) ){

        $status['id_contratto'] = $_REQUEST['id'];
        $status['id_turno'] = $_REQUEST['t'];
      
        $del = mysqlQuery(
            $cf['mysql']['connection'],
            'DELETE FROM orari_contratti WHERE id_contratto = ? AND turno = ? AND se_lavoro = 1',
            array(
                array( 's' => $_REQUEST['id'] ),
                array( 's' => $_REQUEST['t'] )
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
