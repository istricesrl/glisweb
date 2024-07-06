<?php

    /**
     * visualizzatore del contenuto dell'array $cf
     * 
     * 
     * TODO documentare
     * 
     */

    // inclusione del framework
    require '../../_config.php';

    // debug
    ini_set( 'display_errors', 1 );
    ini_set( 'display_startup_errors', 1 );
    error_reporting( E_ALL );

    // ordinamento degli array per la scrittura
    rksort( $cf );

    // output
    $tx    = '<span style="font-family: monospace;">';

    // array da stampare
    $print = $cf;

    // censuro l'array per evitare fughe accidentali di informazioni sensibili
    array2censored( $print );

    // radice
    $txl = array();
    $txa = array( '<a href="?">$cf</a>' );

    // scendo nell'array
    if( isset( $_REQUEST['lvl'] ) && is_array( $_REQUEST['lvl'] ) ) {
        foreach( $_REQUEST['lvl'] as $lvl ) {
            $txl['lvl'][] = $lvl;
            $txa[] = '<a href="?' . htmlentities( http_build_query( $txl ) ) . '">' . htmlentities( $lvl ) . '</a>';
            if( $lvl === 'NULL' ) { $lvl = NULL; }
            if( $lvl === 'ZERO' ) { $lvl = 0; }
            if( isset( $print[ $lvl ] ) ) {
                $print = $print[ $lvl ];
            } else {
                echo $lvl . ' non presente in: ' . print_r( $print, true );
            }
        }
    } else {
        $_REQUEST['lvl'] = array();
    }

    // output
    $tx    .= '<p>' . implode( ' → ', $txa ) . '</p>';
    $tx    .= '<ul>';

    // stampa
    if( empty( $print ) ) {

        $tx .= '<li>(vuoto)</li>';

    } else {

        foreach( array_keys( $print ) as $key ) {

            if( ! is_numeric( $key ) && empty( $key ) ) { $keyRef = 'NULL'; }
            elseif( is_numeric( $key ) && empty( $key ) ) { $keyRef = 'ZERO'; }
            else { $keyRef = $key; }

            $qs['lvl'] = array_merge( $_REQUEST['lvl'], array( $keyRef ) );

            if( isset( $print[ $key ] ) && is_array( $print[ $key ] ) ) {
                $tx .= '<li><a href="?' . htmlentities( http_build_query( $qs ) ) . '">' . ( ( ! is_numeric( $key ) && empty( $key ) ) ? '(vuoto)' : htmlspecialchars( $key ) ) . '</a></li>';
            } elseif( isset( $print[ $key ] ) && is_object( $print[ $key ] ) ) {
                $tx .= '<li>' . str_pad( $key . ' ', 32, '-' ) . ' &#x2192; ' . ( ( ! is_numeric( $key ) && empty( $print[ $key ] ) ) ? '(vuoto)' : print_r( $print[ $key ], true ) ) . '</li>';
            } else {
                $tx .= '<li>' . str_pad( $key . ' ', 32, '-' ) . ' &#x2192; ' . ( ( ! is_numeric( $key ) && empty( $print[ $key ] ) ) ? '(vuoto)' : htmlspecialchars( $print[ $key ] ) ) . '</li>';
            }

        }

    }

    // debug
    // echo '<pre>' . print_r( $_REQUEST, true ) . '</pre>';
    // echo '<pre>' . print_r( $cf, true ) . '</pre>';

    // output
    $tx    .= '</ul>';
    $tx    .= '</span>';

    // output
    buildHtml( $tx, 'variabili del framework' );
