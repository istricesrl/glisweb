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

    // scrittura $cx
    print_r( array2censored( $cx ) );

    // output
    print_r( get_included_files() );
