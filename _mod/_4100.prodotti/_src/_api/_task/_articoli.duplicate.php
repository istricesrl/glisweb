<?php

    /**
     * task richiamato per effettuare la duplicazione di una pagina
     * riceve in ingresso i parametri seguenti:
     * - id: id della pagina da duplicare
     * - child: se settato, vengono duplicate anche le pagine figlie
     *
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

    // verifico se è arrivata una pagina
    if( ! empty( $_REQUEST['id'] ) && ! empty( $_REQUEST['id'] ) ) {

        // ID della pagina
        $status['id'] = $_REQUEST['id'];

        duplicaArticolo( $_REQUEST['id'], $_REQUEST['new'], $_REQUEST['prod'] );
      
    } else {

        // status
        $status['err'][] = 'id della categoria non passato';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
