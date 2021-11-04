<?php

    /**
     * applicazione delle configurazioni di uso comune
     *
     * questo file attualmente non è utilizzato nel modulo base ma può essere usato nei moduli o nelle personalizzazioni
     *
     *
     *
     * @file
     *
     */

    // configurazioni extra
    foreach( array( 'teamsystem', 'zucchetti' ) as $xc ) {

        // configurazione extra
	    if( isset( $cx[ $xc ] ) ) {

            // recupero configurazione
            if( isset( $cf[ $xc ] ) ) {
                $cf[ $xc ]              = array_replace_recursive( $cf[ $xc ], $cx[ $xc ] );
            } else {
                $cf[ $xc ]              = $cx[ $xc ];
            }

            // collegamento all'array $ct
            $ct[ $xc ]					= &$cf[ $xc ];

            // link al profilo corrente
            $cf[ $xc ]['profile']		= &$cf[ $xc ]['profiles'][ $cf['site']['status'] ];

        }

    }
