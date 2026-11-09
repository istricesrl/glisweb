<?php

    /**
     * API della struttura per glisweb-cli
     *
     * restituisce in JSON, per l'utente autenticato, l'account e l'albero del menu di amministrazione
     * con le pagine che l'utente puo' vedere; si chiama con l'header gliswebAuthKey ottenuto da api/login
     *
     * va installata come _src/_api/_cli.php: la regola generica dell'.htaccess la serve su api/cli
     *
     * TODO aggiungere per ogni pagina schede ( etc.tabs ), template.schema e macro della vista
     *
     */

    // inclusione del framework
    if( ! defined( 'INCLUDE_SUBDIR' ) ) {
        require '../_config.php';
    } else {
        require INCLUDE_SUBDIR . '_config.php';
    }

    // costruisce l'albero completo del menu, con gli stessi filtri di buildMenu() ma senza fermarsi al percorso attivo
    function cliMenu( $menu, $tree, $pages ) {

        // ...
        $nav = array();

        // ...
        foreach( (array) $tree as $k => $v ) {

            // la pagina non sta in questo menu
            if( ! isset( $pages[ $k ]['menu'][ $menu ] ) ) {
                continue;
            }

            // stessi controlli di permesso di buildMenu()
            $permesso = ! isset( $pages[ $k ]['auth']['groups'] )
                || ( isset( $_SESSION['account']['gruppi'] ) && count( array_intersect( $pages[ $k ]['auth']['groups'], $_SESSION['account']['gruppi'] ) ) > 0 );

            // ...
            foreach( $pages[ $k ]['menu'][ $menu ] as $mv ) {

                // le voci senza etichetta non si mostrano, ma i figli si
                $figli = ( is_array( $v ) && count( $v ) > 0 ) ? cliMenu( $menu, $v, $pages ) : array();

                if( ! $permesso && ! ( isset( $mv['visualizza'] ) && $mv['visualizza'] == SHOW_ALWAYS ) ) {
                    continue;
                }

                if( empty( $mv['label'] ) && empty( $figli ) ) {
                    continue;
                }

                $nav[] = array(
                    'id'       => $k,
                    'label'    => $mv['label'] ?? NULL,
                    'priority' => $mv['priority'] ?? 0,
                    'title'    => $pages[ $k ]['title'] ?? NULL,
                    'location' => menuLocation( $pages[ $k ] ),
                    'schema'   => $pages[ $k ]['template']['schema'] ?? NULL,
                    'content'  => $figli
                );

            }

        }

        // ordine per priorita', come nel menu web
        usort( $nav, function( $a, $b ) { return strnatcmp( (string) $a['priority'], (string) $b['priority'] ); } );

        // ...
        return $nav;

    }

    // senza login non si risponde; buildJson() non termina lo script, quindi le due risposte stanno in rami alternativi
    if( ! isset( $_SESSION['account']['username'] ) ) {

        // risposta
        http_response_code( 401 );
        $reply = array( 'err' => 'login richiesto', 'status' => 'KO' );

    } else {

        // risposta, con l'account filtrato come in _user.php
        $reply = array(
            'status'  => 'OK',
            'version' => ( file_exists( DIR_BASE . '_etc/_current.version' ) ) ? trim( file_get_contents( DIR_BASE . '_etc/_current.version' ) ) : NULL,
            'account' => array_diff_key( $_SESSION['account'], array( 'permissions' => '', 'privilegi' => '', 'password' => '' ) ),
            'menu'    => array( 'admin' => cliMenu( 'admin', $cf['contents']['tree'][ NULL ], $cf['contents']['pages'] ) )
        );

    }

    // output
    buildJson( $reply );
