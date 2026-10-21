<?php

    /**
     * file di esempio per la funzione string2array()
     * 
     * 
     * 
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // 
    $a = "https://www.google.com/pagina_di_prova";

    // applicazione della funzione
    $r = domainFromURL( $a );

    // output
    var_dump( $r );
