<?php

    /**
     * file di esempio per la funzione string2array()
     * 
     * 
     * 
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // token da controllare
    $j = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJrZXkxIjoidmFsMSIsImtleTIiOiJ2YWwyIn0.fCgASJgFuiqPXoxCWpJM_UYaBDNVF_3vfg1JPeUMURQ';

    // chiave segreta
    $c = 'segreto';

    // controllo del token JWT
    $a = checkJwt( $j, $c );

    // output 
    var_dump( $a );