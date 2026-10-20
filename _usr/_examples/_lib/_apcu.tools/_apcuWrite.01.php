<?php

    /**
     * file di esempio per la funzione openFile()
     * 
     * 
     * 
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // ...
    $k = 'TEST';

    // ...
    $v = 'TEST CONTENT';

    // ...
    var_dump( apcuWrite( $k, $v ) );
