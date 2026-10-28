<?php

    /**
     * script di configurazione guidata del framework
     *
     * Vuole il privilegio GESTIONE_SISTEMA: anche da stub, un task raggiungibile da anonimo e' un
     * task che domani fara' qualcosa senza guardia ( S-010 del censimento dei test, 28/10/2026 ).
     *
     * TODO implementare
     *
     */

    // inclusione del framework
    if( ! defined( 'CRON_RUNNING' ) ) {
        if( ! defined( 'INCLUDE_SUBDIR' ) ) {
            require '../../_config.php';
        } else {
            require INCLUDE_SUBDIR . '_config.php';
        }
    }

    // verifica dei privilegi
    checkTaskPrivilege( 'GESTIONE_SISTEMA' );
