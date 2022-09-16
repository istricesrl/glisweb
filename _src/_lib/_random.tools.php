<?php

    /**
     *
     *
     *
     * @todo finire di documentare
     *
     * @file
     *
     */

    /**
     *
     * @todo documentare
     *
     */
    function getToken() {

	    return md5( microtime( true ) * random_int( 0, 10000 ) );

    }

    /**
     *
     * @todo documentare
     *
     */
    function getPassword( $length = 16, $keyspace = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-_!?%' ) {

        $str = '';

        $max = mb_strlen( $keyspace, '8bit' ) - 1;

        for( $i = 0; $i < $length; ++$i ) {
            $str .= $keyspace[ random_int( 0, $max ) ];
        }

        return $str;

    }
