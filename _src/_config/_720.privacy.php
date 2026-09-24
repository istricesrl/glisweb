<?php

    /**
     * indicizzazione dei cookie
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
     * TODO documentare
     *
     *
     */

    /**
     * indicizzazione dei cookie
     * =========================
     * 
     * 
     * 
     */

    // ...
    $cf['cookie']['index'] = array();

    // ...
    if( is_array( $cf['privacy']['cookie'] ) ) {

        // ...
        foreach( $cf['privacy']['cookie'] as $l1 => $c1 ) {

            // ...
            if( is_array( $c1 ) ) {

                // ...
                foreach( $c1 as $l2 => $c2 ) {
    
                    // ...
                    if( is_array( $c2 ) ) {

                        // ...
                        foreach( $c2 as $l3 => $c3 ) {
        
                            // ..
                            if( is_array( $c3 ) ) {

                                // ...
                                if( is_array( $c3['id'] ) ) {

                                    // ...
                                    foreach( $c3['id'] as $id ) {
                                        $cf['cookie']['index'][ $id ] = &$cf['privacy']['cookie'][ $l1 ][ $l2 ][ $l3 ];
                                    }

                                } else {
                                    $cf['cookie']['index'][ $c3['id'] ] = &$cf['privacy']['cookie'][ $l1 ][ $l2 ][ $l3 ];
                                }
                            }
                        }
    
                    }
        
                } 
        
            }
    
        }
    
    }

    /**
     * debug del runlevel
     * ==================
     * 
     * 
     */

    // ...
    // print_r( $cf['cookie']['index'] );
