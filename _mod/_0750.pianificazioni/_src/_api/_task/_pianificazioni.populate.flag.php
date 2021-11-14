<?php

    /**
     * questo task imposta una pianificazione come da ripulire ed eventualmente ripopolare
     * riceve in ingresso:
     * - id: l'id della pianificazione
     * - data_inizio_pulizia: data di inizio della pulizia
     * - ripopola: opzionale, se la pianificazione deve essere ripopolata
     *
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

    // verifico se è arrivata una pianificazione
    if( ! empty( $_REQUEST['id'] ) && !empty( $_REQUEST['data_inizio_pulizia'] ) ) {

        // ID della pianificazione
        $status['id'] = $_REQUEST['id'];

        // data inizio pulizia
        $status['data_inizio_pulizia'] = $_REQUEST['data_inizio_pulizia'];

        $u = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE pianificazioni SET data_inizio_pulizia = ? WHERE id = ?',
            array(
                array( 's' => $_REQUEST['data_inizio_pulizia'] ),
                array( 's' => $_REQUEST['id'] )
            )
        );

        $status['info'][] = 'aggiornata ' . $u . ' riga di pianificazioni per settaggio data_inizio_pulizia';

        // se è arrivato il parametro ferma, setto la pianificazione da fermare
        if( !empty( $_REQUEST['ferma'] ) ){
            $status['ferma'] = 1;
            $u = mysqlQuery(
                $cf['mysql']['connection'],
                'UPDATE pianificazioni SET se_fermare = 1 WHERE id = ?',
                array(
                    array( 's' => $_REQUEST['id'] )
                )
            );
    
            $status['info'][] = 'aggiornata ' . $u . ' riga di pianificazioni per settaggio se_fermare';
        }
        // se è arrivato il parametro ripopola, setto la pianificazione da ripopolare
        elseif( !empty( $_REQUEST['ripopola'] ) ){
            $status['ripopola'] = 1;
            $u = mysqlQuery(
                $cf['mysql']['connection'],
                'UPDATE pianificazioni SET se_ripopolare = 1 WHERE id = ?',
                array(
                    array( 's' => $_REQUEST['id'] )
                )
            );
    
            $status['info'][] = 'aggiornata ' . $u . ' riga di pianificazioni per settaggio se_ripopolare';
        }
        
       
    } else {

        // status
        $status['err'][] = 'id pianificazione o data_inizio_pulizia non passati';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
