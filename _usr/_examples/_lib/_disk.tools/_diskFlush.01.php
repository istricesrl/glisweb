<?php

    /**
     * file di esempio per la funzione diskFlush()
     *
     * svuota la cartella della cache
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // scrivo una chiave
    var_dump( diskWrite( 'TEST', 'TEST CONTENT' ) );

    // svuoto la cache
    var_dump( diskFlush() );

    // la chiave non c'e' piu'
    var_dump( diskRead( 'TEST' ) );
