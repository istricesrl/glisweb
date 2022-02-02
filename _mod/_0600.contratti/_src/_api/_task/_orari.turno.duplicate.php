<?php

/**
     *
     * il task effettua la duplicazione degli orari contratto relativi a un certo contratto e turno in un nuovo turno
     * in tal modo, se gli orari di turni diversi differiscono di poco, si possono duplicare e poi modificare
     *
     * riceve in ingresso
     * - id: id del contratto
     * - tb: numero del turno da duplicare
     * - tn: numero del turno da creare
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
    
    if( isset( $_REQUEST['id'] ) && isset( $_REQUEST['tb'] ) && isset( $_REQUEST['tn'] ) ){
      
        // estraggo le righe di orari_contratti relativi al giorno da duplicare
        $orari = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT * FROM orari_contratti WHERE id_contratto = ? AND turno = ? AND se_lavoro = 1',
            array(
                array( 's' => $_REQUEST['id'] ),
                array( 's' => $_REQUEST['tb'] )
            )
        );

        if( !empty( $orari ) ){
            foreach( $orari as $o ){
                $status['righe_orari'][] = mysqlDuplicateRow( $cf['mysql']['connection'], 'orari_contratti', $o['id'], NULL, array( 'turno' => $_REQUEST['tn'] ) );
            }
        }
        else{
            $tatus['info'][] = 'nessun orario da duplicare';
        }
        
    }
    else{
        $status['error'] = true;
	    $status['message'] = 'non sono stati passati tutti i parametri necessari';
    }

        // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
