<?php

    /**
     *
     *
     *
     *
     *
     *
     * TODO spostare a _135.redirect.php per risparmiare risorse
     *
     * @todo finire di documentare
     *
     * @file
     *
     */

    // debug
	// print_r( $r );

    // indicizzazione dei redirect
	if( is_array( $r ) ) {
	    foreach( $r as $redir ) {
            if( isset( $redir['sorgente'] ) ) {
                $cf['redirect'][ $redir['sorgente'] ] = $redir;
            } else {
                logWrite( 'redirect malformato: ' . print_r( $redir, true ), 'redirect', LOG_ERR );
            }
	    }
	}

    // debug
    // print_r( $cf['redirect'] );

    // timer
	timerCheck( $cf['speed'], '-> fine indicizzazione dei redirect' );

    // URL sorgente al netto della query string
	$source					= strtok( $_SERVER['REQUEST_URI'], '?' );

    // debug
    // var_dump( $cf['site']['id'] );
    // var_dump( $source );
    // print_r( $cf['redirect'] );
    // die();

    // esecuzione
	if( array_key_exists( $source, $cf['redirect'] ) ) {

        // debug
        // var_dump( $cf['site']['id'] );
        // var_dump( $source );
        // die();

        // ...
        $r = $cf['redirect'][ $source ];

        // ...
        if( $cf['site']['id'] == $r['id_sito'] || empty( $r['id_sito'] ) ) {

            // debug
            // var_dump( $cf['site']['id'] );
            // var_dump( $source );
            // die();

            logWrite( 'reindirizzamento ' . $r['codice'] . ' da ' . $_SERVER['REQUEST_URI'] . ' a ' . $r['target'], 'redirect' );

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

            http_response_code( $r['codice'] );

            header( 'Location: ' . $r['destinazione'] ); 

            exit;

        }

    }

    // debug
	// var_dump( strtok( $_SERVER['REQUEST_URI'], '?' ) );
