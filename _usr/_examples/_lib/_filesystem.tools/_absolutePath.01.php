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
    var_dump( absolutePath( '_etc/_common/_lorem.conf' ) );

    // ...
    var_dump( absolutePath( '../_etc/_common/_lorem.conf' ) );

    // ...
    var_dump( absolutePath( '_etc/../../../_common/_lorem.conf' ) );
