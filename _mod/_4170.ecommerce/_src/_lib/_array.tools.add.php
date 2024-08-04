<?php

    function carrello2mail( $carrello ) {

        $r = array();
        
        foreach( $carrello as $k => $v ) {
            
            if( ! empty( $v ) ) {

                if( is_array( $v ) ) {
                    
                    $r[ $k ] = carrello2mail( $v );
                    
                } else {
                    
                    // se k inizia per timestamp, lo converto in data e ora
                    if( substr( $k, 0, 9 ) == 'timestamp' ) {
                        $v = date( 'Y-m-d H:i', $v );
                    }

                    // se k inizia per prezzo, lo converto in euro
                    if( substr( $k, 0, 6 ) == 'prezzo' ) {
                        $v = number_format( $v, 2, ',', '.' ) . ' €';
                    }

                    $r[ $k ] = $v;
                    
                }
            
            }

        }

        return $r;

    }
