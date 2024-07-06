<?php

    /**
     *
     *
     *
     *
     *
     *
     * TODO documentare
     *
     */

    // popolo l'array dei permessi
    if( $cf['auth']['status'] == LOGIN_SUCCESS ) {

        // se la sessione corrente ha almeno un gruppo associato
        if( isset( $_SESSION['account']['gruppi'] ) ) {

            // per ogni entità $t valuto le coppie permesso / gruppi $w
            foreach( $cf['auth']['permissions'] as $t => $w ) {

                // per ogni coppia permesso $k / gruppi $j
                foreach( $w as $k => $j ) {

                    // se almeno un gruppo associato alla sessione corrente è presente tra i gruppi autorizzati
                    if( array_intersect( $_SESSION['account']['gruppi'], $j ) ) {
                        $_SESSION['account']['permissions'][ $t ][] = $k;
                    }

                }
            }

        }

    } elseif( isset( $_SESSION['account'] ) && ! empty( $_SESSION['account'] ) ) {

        // ...
        $cf['auth']['status'] = LOGIN_LOGGED;

    }

    // debug
    // print_r( $_SESSION['account'] );
    // print_r( $_SESSION['account']['permissions'] );
    // print_r( $cf['auth'] );
    // echo $cf['auth']['status'];
