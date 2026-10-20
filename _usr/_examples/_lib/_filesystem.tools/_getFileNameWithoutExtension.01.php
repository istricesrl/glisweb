<?php

    /**
     * file di esempio per la funzione glob2custom()
     * 
     *
     * 
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // percorso
    $f = 'src/config.json';

    // percorso assoluto
    $d = getFileNameWithoutExtension( $f );

    // output
    var_dump( $f );
    var_dump( $d );
