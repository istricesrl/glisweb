<?php

/**
     *
     * il task effettua la duplicazione degli orari contratto relativi a un certo contratto, turno e giorno
     * in tal modo, se gli orari giornalieri si ripetono, ad esempio, ogni giorno, non è necessario inserirli tutti a mano
     *
     * riceve in ingresso
     * - id: id del contratto
     * - t: numero del turno
     * - gb: numero del giorno da duplicare ( 1=lunedi -> 7=domenica)
     * - gn: numero del giorno da creare ( 1=lunedi -> 7=domenica)
     * 
     * NOTA: attualmente il task duplica solo gli orari di lavoro (non le disponibilità)
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
    
    if( isset( $_REQUEST['id'] ) && isset( $_REQUEST['t'] ) 
        && isset( $_REQUEST['gb'] ) && isset( $_REQUEST['gn'] ) ){
      
        // estraggo le righe di orari_contratti relativi al giorno da duplicare
        $orari = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT * FROM orari_contratti WHERE id_contratto = ? AND turno = ? AND id_giorno = ? AND se_lavoro = 1',
            array(
                array( 's' => $_REQUEST['id'] ),
                array( 's' => $_REQUEST['t'] ),
                array( 's' => $_REQUEST['gb'] )
            )
        );

        if( !empty( $orari ) ){
            foreach( $orari as $o ){
                $status['righe_orari'][] = mysqlDuplicateRow( $cf['mysql']['connection'], 'orari_contratti', $o['id'], NULL, array( 'id_giorno' => $_REQUEST['gn'] ) );
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
