<?php

    /**
     * effettua l'eliminazione di un contratto e di tutti gli oggetti as esso collegati
     * riceve in ingresso l'id del contratto
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

    // verifico se è arrivato un contratto
    if( ! empty( $_REQUEST['id'] ) ) {

        // ID del contratto in oggetto
        $status['id_contratto'] = $_REQUEST['id'];

        mysqlDeleteRowRecursive(
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'contratti',
            $status['id_contratto']
        );


    } else {

        // status
        $status['err'][] = 'ID contratto non passato';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
