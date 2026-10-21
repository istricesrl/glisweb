<?php

    // attivazione della visualizzazione degli errori
    ini_set( 'display_errors', 1 );
    ini_set( 'display_startup_errors', 1 );
    error_reporting( E_ALL );

    // cosa succede se chiamo is_array() su una variabile undefined?
    var_dump( is_array( $undefined ) );
