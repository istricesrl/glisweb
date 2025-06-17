<?php

    /**
     * report sulla gestione dei cookie
     * 
     * Questo report visualizza tutti i cookie presenti nel browser e verifica se sono gestiti dal framework.
     * 
     * 
     * TODO documentare
     * 
     */

    // inclusione del framework
    require '../../_config.php';

    // header
    header( 'Content-type: text/plain' );

    // visualizzazione dei cookie
    if ( !empty( $_COOKIE ) ) {
        foreach ( $_COOKIE as $key => $value ) {
            echo "$key: $value\n";
            echo str_pad('', strlen($key.': '.$value), '-') . "\n";
            $cookieId = '';
            foreach ( $cf['cookie']['index'] as $index => $cookie ) {
                if( preg_match( '/^' . $index . '$/', $key ) ) {
                    $cookieId = $index;
                    break;
                }
            }
            if ( $cookieId ) {
                echo "OK cookie gestito: " . $cf['cookie']['index'][$cookieId]['nome']['it-IT'] . "\n";
                echo $cf['cookie']['index'][$cookieId]['descrizione']['it-IT'] . "\n";
            } else {
                echo "ATTENZIONE cookie non gestito\n";
            }
            echo "\n";
        }
    } else {
        echo "Nessun cookie presente.\n";
    }
