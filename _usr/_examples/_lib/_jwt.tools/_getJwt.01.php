<?php

    /**
     * file di esempio per la funzione string2array()
     * 
     * 
     * 
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // dati da codificare
    $a = array( 'key1' => 'val1', 'key2' => 'val2' );

    // chiave segreta
    $c = 'segreto';

    // generazione del token JWT
    $j = getJwt( $a, $c );

    // output
    var_dump( $j );
