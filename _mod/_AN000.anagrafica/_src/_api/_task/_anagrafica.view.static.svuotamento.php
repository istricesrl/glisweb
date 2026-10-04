<?php

    /**
     * svuotamento della vista statica anagrafica_view_static
     *
     * SOLO PER LE EMERGENZE: svuota la statica, che poi va ripopolata per intero con il task di popolazione
     * richiamato in ciclo. Finche' non e' ripopolata, gli elenchi e le tendine che la leggono restano vuoti.
     *
     * Chiamata: /task/AN000.anagrafica/anagrafica.view.static.svuotamento
     *
     * @file
     *
     */

    // inclusione del framework
    if( ! defined( 'CRON_RUNNING' ) ) {
        if( ! defined( 'INCLUDE_SUBDIR' ) ) {
            require '../../../../../_src/_config.php';
        } else {
            require INCLUDE_SUBDIR . '_config.php';
        }
    }

    // verifica dei privilegi
    checkTaskPrivilege( 'GESTIONE_MYSQL' );

    // inizializzo l'array del risultato
    $status = array();

    // ...
    $status['esito'] = emptyAnagraficaViewStatic();

    // debug
    // print_r( $_REQUEST );

    // output
    if( ! defined( 'CRON_RUNNING' ) ) {
        buildJson( $status );
    }
