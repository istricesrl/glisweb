<?php

    /**
     * file di esempio per la funzione string2utf8()
     * 
     *
     * 
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // stringa di test
    $s = iconv('UTF-8', 'ISO-8859-1', 'èéòàìù');;
    var_dump( mb_detect_encoding( $s ) );
    var_dump( $s );

    // test della lingua del browser
    var_dump( string2utf8( $s, 'ISO-8859-1' ) );
    var_dump( mb_detect_encoding( $s ) );
