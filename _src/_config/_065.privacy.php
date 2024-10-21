<?php

    /**
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
     * NOTA qui si introduce il concetto di configurazione per sito
     *
     *
     *
     *
     * TODO applicare la strategia della configurazione extra per sito anche ai vari slack, google, criteo, ecc.
     * TODO rimuovere quel brutto codice che fa il controllo della configurazione per sito nei vari slack, google, criteo, ecc.
     *
     *
     */

    // debug
    // print_r( $_COOKIE );

    /**
     * integrazione della configurazione da file Json/Yaml e da cookie
     * ===============================================================
     * 
     * 
     */

    // configurazione extra
    if( isset( $cx['privacy'] ) ) {
        $cf['privacy'] = array_replace_recursive( $cf['privacy'], $cx['privacy'] );
    }

    // configurazione extra per sito
    if( isset( $cf['site']['privacy'] ) ) {
        $cf['privacy'] = array_replace_recursive( $cf['privacy'], $cf['site']['privacy'] );
    }

    // recupero i consensi dai cookie
    if( isset( $_COOKIE['privacy'] ) ) {
        $cf['privacy']['cookie'] = array_replace_recursive( $cf['privacy']['cookie'], unserialize( $_COOKIE['privacy'] ) );
    }

    /**
     * collegamento di $ct a $cf tramite puntatore
     * ===========================================
     * 
     * 
     */

    // collegamento con l'array $ct
    $ct['privacy'] = &$cf['privacy'];

    /**
     * gestione dell'invio dei moduli di consenso
     * ==========================================
     * 
     * 
     */

    // se è stato inviato un modulo di consenso
    if( isset( $_REQUEST['__cookie__'] ) ) {

        /*
                // registro il consenso nel cookie dei consensi
                $cf['privacy']['cookie'][ $_REQUEST['__cookie__']['owner'] ][ $_REQUEST['__cookie__']['type'] ][ $_REQUEST['__cookie__']['name'] ]['consenso'] = $_REQUEST['__cookie__']['value'];
        
                // TODO log del consenso
                // TODO implementare il log dei consensi
        */

        foreach( $_REQUEST['__cookie__'] as $cookie => $val ) {
            $cf['privacy']['cookie'][ $val['owner'] ][ $val['type'] ][ $cookie ]['consenso'] = $_REQUEST['__cookie__'][ $cookie ]['value'];
            $consensi[ $val['owner'] ][ $val['type'] ][ $cookie ]['consenso'] = $_REQUEST['__cookie__'][ $cookie ]['value'];
        }

        // die( print_r( $_REQUEST['__cookie__'], true ) );

        // setto il cookie
        /*
        $status = setcookie(
            '_glisweb.privacy',
            serialize( $cf['privacy']['cookie'] ),
            array(
                'expires' => time() + 60*60*24*30, 
                'path' => '/', 
                'domain' => '.'.$cf['site']['domain'],
                'secure' => true,
                'httponly' => true,
                'samesite' => 'Strict'
            )
        );
        */
        setcookie( 'privacy', serialize( $consensi ) );
        // setcookie( 'controllo', 'controllo' );
        // print_r( $cf['privacy']['cookie'] );

        // print_r( $cf['privacy']['cookie']);
        // die( print_r( $_COOKIE, true ) );
        // var_dump( $status );
        // die();

    }

    /*
    // aggiustamenti automatici ai cookie per Google Tag Manager
    if( isset( $cf['google']['profile']['gtm'] ) ) {
        $k = ( ( $cf['google']['profile']['gtm']['anonymous'] == true ) ? 'anonimi' : 'identificativi' );
        $cf['privacy']['cookie']['terzi']['analitici'][ $k ] = array(
        'GoogleTagManager' => array(
            'nome' => 'Google Tag Manager',
            'policy' => 'https://policies.google.com/privacy',
            'motivazione' => array( 'it-IT' => 'analisi statistica di utilizzo del sito da parte dei visitatori e monitoraggio del funzionamento del sito' ),
            'conservazione' => array( 'it-IT' => 'due anni' )
        )
        );
    }

    // aggiustamenti automatici ai cookie per Google Analytics
    if( isset( $cf['google']['profile']['analytics'] ) ) {
        $k = ( ( $cf['google']['profile']['analytics']['anonymous'] == true ) ? 'anonimi' : 'identificativi' );
        $cf['privacy']['cookie']['terzi']['analitici'][ $k ] = array(
        'GoogleAnalytics' => array(
            'nome' => 'Google Analytics',
            'policy' => 'http://www.google.it/intl/it/policies/privacy/',
            'motivazione' => array( 'it-IT' => 'analisi statistica di utilizzo del sito da parte dei visitatori e monitoraggio del funzionamento del sito' ),
            'conservazione' => array( 'it-IT' => 'due anni' )
        )
        );
    }
    */

    /**
     * debug del runlevel
     * ==================
     * 
     * 
     */

    // debug
    // print_r( $cf['privacy']['cookie'] );
    // print_r( $_REQUEST['__cookie__'] );
    // print_r( $cf['contents']['pages']['licenza']['content'] );
        

