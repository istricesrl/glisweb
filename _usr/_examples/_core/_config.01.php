<?php

    /**
     * file di esempio per la funzione glob2custom()
     * 
     * 
     * 
     */

    // inclusione del framework
    require '../../../_src/_config.php';

    // output
    header( 'Content-type: text/plain' );

    // scrittura $cf
    print_r( array2censored( $cf ) );

    // output
    print_r( get_included_files() );
