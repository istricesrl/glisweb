<?php

    /**
     * file di esempio per la funzione ftpListFiles()
     * 
     * 
     * 
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // percorso
    $f = 'tmp/example/' . microtime( true ) . '.txt';

    // valuto il tipo di upload
    var_dump( ftpGetUploadTypeByFile( $f ) );
