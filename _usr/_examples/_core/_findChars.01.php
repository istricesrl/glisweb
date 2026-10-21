<?php

    /**
     * file di esempio per la funzione findChars()
     * 
     * 
     * 
     */

    // inclusione del framework
    require '../../../_src/_config.php';

    // array di caratteri di esempio
    $a = array( 'a', 'b', 'c' );

    // esempio che deve restituire true
    var_dump( findChars( 'janbhhjcz', $a ) );

    // esempio che deve restituire false
    var_dump( findChars( 'janbhhjz', $a ) );
