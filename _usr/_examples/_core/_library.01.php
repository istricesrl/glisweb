<?php

    /**
     * file di esempio per la funzione glob2custom()
     * 
     * 
     * 
     */

    // inclusione del framework
    require '../../../_src/_config.php';

    // output
    var_dump( DIR_SRC_LIB . '_*.*.php' );
    var_dump( DIR_MOD_ATTIVI_SRC_LIB . '_*.*.php' );

    // output
    var_dump( $cf['library'] );

    // output
    var_dump( get_included_files() );
