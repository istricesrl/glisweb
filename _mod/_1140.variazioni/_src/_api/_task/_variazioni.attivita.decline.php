<?php

    /**
     * riceve in ingresso l'id della variazione da rifiutare
     * setta data_rifiuto della variazione
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

    // verifico se è arrivata una variazione
    if( ! empty( $_REQUEST['id'] ) ) {

        // ID della variazione in oggetto
        $status['id'] = $_REQUEST['id'];

        // setto la data di rifiuto della variazione alla data corrente
        $rifiuta = mysqlQuery(
            $cf['mysql']['connection'],
            "UPDATE variazioni_attivita SET data_rifiuto = ? WHERE id = ?",
            array(
                array( 's' => date('Y-m-d') ),
                array( 's' => $_REQUEST['id'])
            )
        );

        $status['info'][] = 'variazione ' . $_REQUEST['id'] . ' rifiutata con data ' . date('Y-m-d');


    } else {

        // status
        $status['err'][] = 'ID variazione non passato';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
