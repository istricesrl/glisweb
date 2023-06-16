<?php

    if( isset( $ct['page']['parser'] ) ) {

        foreach( $ct['page']['parser'] as $parser ) {

            require $parser;

        }
    }

    // print_r( $ct['page']);
