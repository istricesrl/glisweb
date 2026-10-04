<?php

    /**
     * svuotamento della vista statica todo_view_static
     *
     * SOLO PER LE EMERGENZE: svuota la statica, che poi va ripopolata per intero con il task di popolazione
     * richiamato in ciclo. Finche' non e' ripopolata, gli elenchi e le tendine che la leggono restano vuoti.
     *
     * Chiamata: /task/1200.todo/todo.view.static.svuotamento
     *
     * @file
     *
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}

    // verifica dei privilegi
    checkTaskPrivilege( 'GESTIONE_MYSQL' );

    // inizializzo l'array del risultato
    $status = array();

    // ...
    $status['esito'] = mysqlQuery( $cf['mysql']['connection'], 'TRUNCATE todo_view_static' );

    // debug
    // print_r( $_REQUEST );

    // output
    if( ! defined( 'CRON_RUNNING' ) ) {
        buildJson( $status );
    }
