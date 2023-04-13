<?php

    /**
     * libreria per la geolocalizzazione
     *
     *
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
     *
     *
     * @todo documentare
     *
     */
    function getCoordsDistance( $ltf, $lgf, $ltt, $lgt ) {

        $rad = M_PI / 180;

        $tha = $lgf - $lgt;

        $dst = sin( $ltf * $rad ) 
            * sin( $ltt * $rad ) + cos( $ltf * $rad )
            * cos( $ltt * $rad ) * cos( $tha * $rad );
    
        return acos( $dst ) / $rad * 60 *  1.853;

    }

    /**
     *
     *
     *
     * @todo documentare
     *
     */
    function degrees2coords( $deg, $min, $sec, $dir ) {
    
        $mod = ( in_array( $dir, array( 'N', 'E' ) ) ? 1 : -1 );

        return ( ( $deg + ( ( ( $min * 60) + ( $sec ) ) / 3600 ) ) * $mod );

    }
    
    /**
     *
     *
     *
     * @todo documentare
     *
     */
    function coords2degrees( $dec ) {

        $vars = explode( '.', $dec );
        $deg = $vars[0];
        $tempma = '0.' . $vars[1];
    
        $tempma = $tempma * 3600;
        $min = floor( $tempma / 60 );
        $sec = $tempma - ( $min * 60 );
    
        return array( 'deg' => $deg, 'min' => $min, 'sec' => $sec );

    }

    /**
     *
     *
     *
     * @todo documentare
     *
     */
    function string2degrees( $s ) {

        // preg_match_all( '([0-9\.]+)°[\s]*([0-9\.]+)[\']+[\s]*([0-9\.]+)[\'\"]+[\s]*([NSWE]){1}', $s, $a );
        // preg_match_all( "/([0-9\.]+)°[\s]*([0-9\.]+)[\']+[\s]*([0-9\.]+)[\'\"]+[\s]*([NSWE]){1}/gm", $s, $a );
        // /([0-9\.]+)°[\s]*([0-9\.]+)[']{1}[\s]*([0-9\.]+)[\'\"]{1,2}[\s]*([NSWE]){1}/g
        // preg_match_all( '/([0-9\.]+)°[\s]*([0-9\.]+)/'[\s]*([0-9\.]+)[\'\"]+[\s]*([NSWE]){1}/g', $s, $a );
        // OK /([0-9.,]+)[°]{1}[\s]*([0-9.,]+)['′]{1}[\s]*([0-9.,]+)['"″]{1,2}[\s]*([NSWE]){1}/g
        // preg_match_all( '/([0-9]+)//', $s, $a );
        // OK? preg_match_all( '/([0-9.,]+)[°]{1}[\s]*([0-9.,]+)[\'′]{1}[\s]*([0-9.,]+)[\'"″]{1,2}[\s]*([NSWE]){1}/', $s, $a );
        // preg_match_all( "/([0-9.,]+)[°]{1}[\s]*([0-9.,]+)[']{1}[\s]*([0-9.,]+)['\"]{1,2}[\s]*([NSWE]){1}/", $s, $a );
        // OOK? preg_match_all( '/([0-9.,]+)°[\s]*([0-9.,]+)\'/', '23.1°11.2\'', $a );
        // preg_match_all( '/([0-9.,]+)°[\s]*([0-9.,]+)[\'′]+[\s]*([0-9.,]+)[\'"″]+([NSWE]{1})/', '23.1°11.2\' 15,7"', $a );

        preg_match( '/([0-9.,]+)°[\s]*([0-9.,]+)[\'′]+[\s]*([0-9.,]+)[\'"″]+([NSWE]{1})/', $s, $a );

        // print_r( array_slice( $a, 1 ) );

        return array_slice( $a, 1 );

    }

    /**
     *
     *
     *
     * @todo documentare
     *
     */
    function string2coords( $s ) {

        $a = string2degrees( $s );

        return degrees2coords( $a[0], $a[1], $a[2], $a[3] );

    }

    /**
     *
     *
     *
     * @todo documentare
     *
     */
    function splitAddress( $a ) {

        // trovo il civico
        preg_match( '/([0-9\/a-zA-Z]+)$/', $a, $pCivici );
        $pCivico = ( is_array( $pCivici ) && ! empty( $pCivici ) ) ? $pCivici[0] : NULL;

        // pulisco l'indirizzo
        $pIndirizzo = trim( str_replace( $pCivico, NULL, $a ), ' ,' );        

        return array( 'indirizzo' => $pIndirizzo, 'civico' => $pCivico );

    }
