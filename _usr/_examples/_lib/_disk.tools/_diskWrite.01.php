<?php

    /**
     * file di esempio per la funzione diskWrite()
     *
     * scrive un dato in cache e il file che lo contiene
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // chiave di test
    $k = 'TEST';

    // valore di test
    $v = 'TEST CONTENT';

    // scrivo la chiave
    var_dump( diskWrite( $k, $v ) );

    // il file della chiave esiste e non e' rimasto nessun temporaneo
    var_dump( is_file( diskKeyPath( diskUniqueKey( $k ) ) ) );
    var_dump( count( glob( DIR_VAR_SPOOL_CACHE . '*.tmp' ) ) );
