<?php

    /**
     * 
     * 
     * 
     * 
     * 
     * https://tcpdf.org/examples/example_009/
     *
     * @todo documentare
     *
     * @file
     *
     */

    // inclusione del framework
    require '../../../../../_src/_config.php';

    // status
    $status = array( 'test' => 'OK', 'print' => '/print/5600.colli/etichette.colli' );

    // output
    buildJson( $status );
