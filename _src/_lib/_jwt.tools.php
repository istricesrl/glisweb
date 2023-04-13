<?php

    /**
     *
     *
     *
     * https://www.sitepoint.com/php-authorization-jwt-json-web-tokens/
     * https://auth0.com/learn/token-based-authentication-made-easy/
     * https://hasura.io/blog/best-practices-of-using-jwt-with-graphql/
     * https://dev.to/robdwaller/how-to-create-a-json-web-token-using-php-3gml
     * https://jwt.io/
     *
     * @todo documentare
     *
     * @file
     *
     */

    function getJwt( $a = array(), $s = NULL ) {

        $eh = cleanJwt( base64_encode( json_encode( ['typ' => 'JWT', 'alg' => 'HS256'] ) ) );
        
        $ep = cleanJwt( base64_encode( json_encode( $a ) ) );
        
        $hp = $eh . '.' . $ep;
        
        $sg = cleanJwt( base64_encode( hash_hmac( 'sha256', $hp, $s, true ) ) );
        
        $jwt = $hp . '.' . $sg;
        
        return $jwt;
    
    }

    function checkJwt( $t = NULL, $s = NULL ) {

        $jwt = explode('.', $t);
        
        $rs = $jwt[2];
        
        $hp = $jwt[0] . '.' . $jwt[1];
        
        $sg = cleanJwt( base64_encode( hash_hmac( 'sha256', $hp, $s, true ) ) );
        
        if($sg == $rs) {
            return true;
        }

        return false;
    
    }

    function cleanJwt( $s ) {

        return str_replace( ['+', '/', '='], ['-', '_', ''], $s );

    }

    function jwt2array( $t, $s ) {

        $r = array();

        if( checkJwt( $t, $s ) ) {

            $tx = explode( '.', $t );  
            $th = base64_decode( $tx[0] );
            $tp = base64_decode( $tx[1] );
            $r['head'] = json_decode( $th, true );
            $r['data'] = json_decode( $tp, true );

        }

        return $r;

    }