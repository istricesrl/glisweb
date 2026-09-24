<?php

    /**
     *
     *
     *
     *
     *
     *
     * TODO documentare
     *
     *
     */

    // debug
    ini_set( 'display_errors', 1 );
    error_reporting( E_ALL );

    // tabella gestita
    $ct['form']['table'] = 'template';

    // sotto tabella gestita
    $ct['form']['subtable'] = 'contenuti';

    // macro di default per l'entità notizie
    require DIR_SRC_INC_MACRO . '_default/_default.form.multilingua.php';

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';

    // debug
    // die( print_r( $_REQUEST, true ) );
