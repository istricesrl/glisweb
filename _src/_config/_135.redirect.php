<?php

    /**
     * 
     * 
     * TODO implementare qui i redirect implicherebbe un bel risparmio di risorse
     * 
     */

    // indicizzazione redirect da csv
    foreach( array( 'csv', 'db' ) as $src ) {
        if( isset( $cf['redirect']['src'][ $src ] ) ) {
            foreach( $cf['redirect']['src'][ $src ] as $redirect ) {
                $cf['redirect']['index'][ $redirect['id_sito'] ][ $redirect['sorgente'] ] = $redirect;
            }
        }
    }

    // configurazione extra
    if( isset( $cx['redirect'] ) ) {
        $cf['redirect'] = array_replace_recursive(
            $cf['redirect'],
            $cx['redirect']
        );
    }

    // timer
    timerCheck( $cf['speed'], '-> fine indicizzazione dei redirect' );

    // URL sorgente al netto della query string
    $cf['uri']['base'] = strtok( $_SERVER['REQUEST_URI'], '?' );

    // debug
    // var_dump( $cf['uri']['base'] );
    // var_dump( $cf['redirect']['index'][ SITE_CURRENT ] );

    // esecuzione
    if( array_key_exists( $cf['uri']['base'], $cf['redirect']['index'][ SITE_CURRENT ] ) ) {

        // oggetto redirect
        $cf['redirect']['found'] = $cf['redirect']['index'][ SITE_CURRENT ][ $cf['uri']['base'] ];

        // log
        logger( 'reindirizzamento ' . $cf['redirect']['found']['codice_stato_http'] . ' da ' . $cf['uri']['base'] . ' a ' . $cf['redirect']['found']['destinazione'], 'redirect' );

        // debug
        // var_dump( $cf['uri']['base'] );
        // var_dump( $cf['redirect']['index'][ SITE_CURRENT ] );
        // var_dump( $cf['redirect']['found'] );
        // die();

        // salvo il redirect
        /* TODO decommentare quando abbiamo ripristinato il database
        if( isset( $r['id'] ) ) {
            mysqlInsertRow(
                $cf['mysql']['connection'],
                array(
                    'id_redirect' => $r['id'],
                    'referral' => $_SERVER['HTTP_REFERER'],
                    'azione' => 'redirect',
                    'timestamp_azione' => time()
                ),
                'redirect_azioni'
            );
        }
        */

        // restituisco il codice di stato HTTP
        http_response_code( $cf['redirect']['found']['codice_stato_http'] );

        // eseguo il redirect
        header( 'Location: ' . $cf['redirect']['found']['destinazione'] ); 

        // fine dell'esecuzione del framework
        exit;

    }

    // debug
    // var_dump( strtok( $_SERVER['REQUEST_URI'], '?' ) );

    // debug
    // var_dump( $cf['uri']['base'] );
    // var_dump( $cf['redirect'] );

