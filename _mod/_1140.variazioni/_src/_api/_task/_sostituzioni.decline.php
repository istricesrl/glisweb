<?php

    /**
     * riceve in ingresso l'id della sostituzione da rifiutare
     * setta la data di rifiuto della sostituzione
     * 
     *
     *
     * @todo commentare
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

    // verifico se è arrivata una sostituzione
    if( ! empty( $_REQUEST['id'] ) ) {

        // ID della variazione in oggetto
        $status['id'] = $_REQUEST['id'];

        
        // setto la data di rifiuto della sostituzione alla data corrente
        $rifiuta = mysqlQuery(
            $cf['mysql']['connection'],
            "UPDATE sostituzioni_attivita SET data_rifiuto = ? WHERE id = ?",
            array(
                array( 's' => date('Y-m-d') ),
                array( 's' => $_REQUEST['id'])
            )
        );

        $status['info'][] = 'sostituzione ' . $_REQUEST['id'] . ' rifiutata con data ' . date('Y-m-d');     

    } else {

        // status
        $status['err'][] = 'ID sostituzione non passato';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
