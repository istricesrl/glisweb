<?php

    /**
     * stato per il controllo di uptime
     *
     * Risponde all'URL /status/uptime ( regola generica degli status in /.htaccess ) e ha due usi.
     *
     * Per tutti dice solo se il sito funziona: fa il bootstrap del framework e risponde OK, oppure KO con 503 se il
     * deploy ha un database configurato e la connessione non c'e'. Niente versioni, percorsi o nomi di database: la
     * pagina e' pubblica.
     *
     * Agli altri server del cluster, che presentano nell'header X-Glisweb-Uptime il token di /etc/glisweb/uptime.yaml,
     * restituisce invece la vista di questo server, cioe' il var/uptime/stato.json del deploy indicato nel campo
     * deploy: della stessa configurazione. Quel ramo non fa il bootstrap, cosi' risponde anche se il database di
     * questo sito e' giu'. Il controllo nel suo insieme e' descritto in _src/_lib/_uptime.tools.php.
     *
     * @file
     *
     */

    // vista per gli altri server del cluster
    if( isset( $_SERVER['HTTP_X_GLISWEB_UPTIME'] ) ) {

        $conf = ( function_exists( 'yaml_parse_file' ) && is_readable( '/etc/glisweb/uptime.yaml' ) ) ? @yaml_parse_file( '/etc/glisweb/uptime.yaml' ) : false;

        if( empty( $conf['token'] ) || ! hash_equals( (string) $conf['token'], (string) $_SERVER['HTTP_X_GLISWEB_UPTIME'] ) ) {
            http_response_code( 403 );
            exit;
        }

        $stato = rtrim( $conf['deploy'], '/' ) . '/var/uptime/stato.json';

        if( ! is_readable( $stato ) ) {
            http_response_code( 404 );
            exit;
        }

        header( 'Content-type: application/json' );
        header( 'Cache-Control: no-store, no-cache, must-revalidate, max-age=0, s-maxage=0' );
        readfile( $stato );
        exit;

    }

    // inclusione del framework
    if( ! defined( 'INCLUDE_SUBDIR' ) ) {
        require '../../_config.php';
    } else {
        require INCLUDE_SUBDIR . '_config.php';
    }

    // output
    header( 'Content-type: text/plain' );
    header( 'Cache-Control: no-store, no-cache, must-revalidate, max-age=0, s-maxage=0' );
    header( 'Pragma: no-cache' );
    header( 'Expires: 0' );
    header( 'X-Proxy-Cache: BYPASS' );
    header( 'X-GlisWeb-No-Cache: true' );

    // il database conta solo se il deploy ne ha uno
    if( ! empty( $cf['mysql']['profiles'][ $cf['site']['status'] ]['servers'] ) && empty( $cf['mysql']['connection'] ) ) {
        http_response_code( 503 );
        echo 'KO' . PHP_EOL;
    } else {
        echo 'OK' . PHP_EOL;
    }
