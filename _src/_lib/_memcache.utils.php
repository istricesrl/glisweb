<?php

    /**
     * questo file contiene funzioni per l'utilizzo di memcache
     *
     *
     *
     *
     *
     * @file
     *
     */

    /**
     *
     * @todo documentare
     *
     */
    function memcacheCleanFromIndex( $k ) {

        global $cf;

        // echo 'pulizia di ' . $k;

        if( isset( $cf['memcache']['connection'] ) && ! empty( $cf['memcache']['connection'] ) ) {

            logWrite( 'richiesta pulizia cache da indice per ' . $k, 'speed' );

            if( isset( $cf['memcache']['index'][ $k ] ) && is_array( $cf['memcache']['index'][ $k ] ) ) {
                foreach( $cf['memcache']['index'][ $k ] as $t => $l ) {
                logWrite( 'pulizia cache da indice per ' . $k . '/' . $t, 'speed' );
                foreach( $l as $j => $v ) {
                    unset( $cf['memcache']['index'][ $k ][ $t ][ $j ] );
                    memcacheDelete( $cf['memcache']['connection'], $j );
                    logWrite( 'pulizia cache da indice per ' . $k . '/' . $t . '/' . $j, 'speed' );
                }
                }
            }

        }

    }
