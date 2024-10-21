<?php

    /**
     * 
     * 
     * TODO documentare
     * 
     */

    // configurazioni extra per TeamSystem e Zucchetti
    // TODO questa cosa non deve stare qui ma in un file del 600 ad es. _600.common.php
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
            $ct[ $xc ]                    = &$cf[ $xc ];

            // link al profilo corrente
            $cf[ $xc ]['profile']        = &$cf[ $xc ]['profiles'][ SITE_STATUS ];

        }

    }

