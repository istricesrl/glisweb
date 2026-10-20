<?php

    /**
     * file di esempio per la funzione path2custom()
     * 
     * 
     * 
     */

    // inclusione del framework
    require '../../../_src/_config.php';

    // directory corrente
    var_dump( __DIR__ );

    // versione custom della directory corrente
    var_dump( path2custom( __DIR__ ) );
