<?php

    /**
     * file di esempio per la funzione array2censored()
     * 
     * 
     * 
     */

    // inclusione del framework
    require '../../../_src/_config.php';

    // array associativo per il test
    $a = array( 
        'username' => 'username',
        'password' => '1234asd',
        'key' => 'lkjhg13245'
     );

    // chiamo funzione array2censored() per modificare l'array
    array2censored( $a );

    // esempio che dovrebbe restituire array con "username, ***, ***"
    var_dump( $a );
