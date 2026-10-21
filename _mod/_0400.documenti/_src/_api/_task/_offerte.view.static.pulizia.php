<?php

    /**
     * pulizia della vista statica offerte_view_static
     *
     * Toglie dalla statica le righe che non esistono piu' nella tabella base: syncStaticView() le righe le
     * riscrive ma non le cancella.
     * Toglie anche le righe dei documenti che non sono piu' offerte ( tipologia cambiata ).
     *
     * Chiamata: /task/0400.documenti/offerte.view.static.pulizia
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
    $status['esito'] = cleanStaticView( $cf['mysql']['connection'], 'offerte', 'documenti', 'documenti.id_tipologia IN ( SELECT id FROM tipologie_documenti WHERE se_offerta IS NOT NULL )' );

    // debug
    // print_r( $_REQUEST );

    // output
    if( ! defined( 'CRON_RUNNING' ) ) {
        buildJson( $status );
    }
