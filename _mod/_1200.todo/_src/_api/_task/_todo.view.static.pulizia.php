<?php

    /**
     * pulizia della vista statica todo_view_static
     *
     * Toglie dalla statica le righe che non esistono piu' nella tabella base: syncStaticView() le righe le
     * riscrive ma non le cancella.
     *
     * Chiamata: /task/1200.todo/todo.view.static.pulizia
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
    $status['esito'] = cleanStaticView( $cf['mysql']['connection'], 'todo' );

    // debug
    // print_r( $_REQUEST );

    // output
    if( ! defined( 'CRON_RUNNING' ) ) {
        buildJson( $status );
    }
