<?php

    // inclusione del framework
	require '../../../_src/_config.php';

    $static = 'anagrafica_view_static';
    $function = 'update' . implode( '', array_map( 'ucfirst', explode( '_', $static ) ) );

    if( function_exists( $function ) ) {

        echo $function;
        $function( 1 );

    }
