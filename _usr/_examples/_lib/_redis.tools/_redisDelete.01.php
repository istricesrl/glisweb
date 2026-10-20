<?php

    /**
     * file di esempio per la funzione openFile()
     * 
     * 
     * 
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // chiave di test
    $k = 'TEST';

    // valore di test
    $v = 'TEST CONTENT';

    // scrivo la chiave
    var_dump( redisWrite( $cf['redis']['connection'], $k, $v ) );

    // stampa il risultato
    var_dump( redisDelete( $cf['redis']['connection'], $k ) );
