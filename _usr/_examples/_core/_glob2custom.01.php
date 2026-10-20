<?php

    /**
     * file di esempio per la funzione glob2custom()
     * 
     * 
     * 
     */

    // inclusione del framework
    require '../../../_src/_config.php';

    // directory corrente
    var_dump( __DIR__ );

    // versione custom della directory corrente
    var_dump( glob2custom( __DIR__ ) );
