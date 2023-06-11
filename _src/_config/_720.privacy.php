<?php

    /**
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     * @file
     *
     */

    // debug
	// print_r( $cf['google'] );
	// print_r( $cf['privacy'] );

    // ...
    $cf['cookie']['index'] = array();

    // ...
    foreach( $cf['privacy']['cookie'] as $l1 => $c1 ) {

        // debug
        // echo $l1 . PHP_EOL;

        // ...
        foreach( $c1 as $l2 => $c2 ) {

            // debug
            // echo $l2 . PHP_EOL;

            // ...
            foreach( $c2 as $l3 => $c3 ) {

                // debug
                // echo $l3 . PHP_EOL;
                // print_r( $c3 );

                // ..
                foreach( $c3['id'] as $id ) {
                    $cf['cookie']['index'][ $id ] = &$cf['privacy']['cookie'][ $l1 ][ $l2 ][ $l3 ];
                }

            }

        } 

    }


