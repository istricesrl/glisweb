<?php

    /**
     * file di esempio per la funzione shortPAth()
     * 
     *
     * 
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // percorso
    $f = '/src/config.json';

    // output
    var_dump( $f );

    // percorso assoluto
    $d = shortPath( $f );

    // output
    var_dump( $f );
    var_dump( $d );
