<?php

    /**
     * effettua l'eliminazione di un progetto e di tutti gli oggetti as esso collegati
     * - se riceve in ingresso un id, analizza quel progetto
     * - altrimenti analizza i progetti che hanno il flag se_cancellare = 1
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

    // verifico se è arrivato un progetto
    if( ! empty( $_REQUEST['id'] ) ) {

        if( isset( $_REQUEST['note_invio'] ) && !empty( $_REQUEST['note_invio']) ){
            
            $update = mysqlQuery( 
                $cf['mysql']['connection'], 
                'UPDATE documenti SET timestamp_invio = ?, note_invio = ? WHERE id = ?',
                array( 
                    array( 's' => time() ), 
                    array( 's' => $_REQUEST['note_invio'] ),
                    array( 's' => $_REQUEST['id'] ) ) );

        } else {

            $update = mysqlQuery( 
                $cf['mysql']['connection'], 
                'UPDATE documenti SET timestamp_invio = ? WHERE id = ?',
                array( 
                    array( 's' => time() ), 
                    array( 's' => $_REQUEST['id'] ) ) );
        }


    } else {

        // status
        $status['err'][] = 'ID documento non passato';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
