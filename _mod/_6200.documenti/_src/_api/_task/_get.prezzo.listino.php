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

    // inizializzo l'array del risultato
	$status = array();

    // verifico se è arrivato un progetto
    if( ! empty( $_REQUEST['id_articolo'] ) ) {

        if( isset( $_REQUEST['id_listino'] ) && ! empty( $_REQUEST['id_listino'] ) ){

            $status['prezzo'] = mysqlSelectValue( 
                $cf['mysql']['connection'], 
                'SELECT prezzo FROM prezzi WHERE id_listino = ? AND id_articolo = ? ORDER BY id DESC LIMIT 1',
                array( 
                    array( 's' => $_REQUEST['id_listino'] ),
                    array( 's' => $_REQUEST['id_articolo'] ) ) );

        } else {
            $status['prezzo'] = mysqlSelectValue( 
                $cf['mysql']['connection'], 
                'SELECT prezzo FROM prezzi WHERE id_articolo = ? AND id_listino = 1 ORDER BY id DESC LIMIT 1',
                array( 
                    array( 's' => $_REQUEST['id_articolo'] ) ) );
        }

        if( empty( $status['prezzo'] ) ){

            $status['err'][] = 'prezzo articolo assente';

        } else {

            $status['info'][] = 'OK';

        }


    } else {

        // status
        $status['err'][] = 'ID documento non passato';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
