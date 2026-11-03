<?php

    /**
     * inizializzazione dati speciali della sessione
     *
     * introduzione
     * ============
     * 
     * 
     *
     * l'array $_SESSION['__view__']
     * -----------------------------
     * 
     * 
     *
     *
     * l'array $_SESSION['__work__']
     * -----------------------------
     *
     *
     * 
     * l'array $_REQUEST['__err__']
     * ----------------------------
     * 
     * 
     * 
     * l'array $_REQUEST['__info__']
     * -----------------------------
     *
     *
     *
     * TODO documentare
     *
     *
     */

    /**
     * inizializzazione di $_SESSION['__view__']
     * =========================================
     * 
     * 
     */

    // inizializzo l'array della view
    if( ! isset( $_SESSION['__view__'] ) ) {
        $_SESSION['__view__'] = array();
    }

    // defaults
    if( ! isset( $_SESSION['__view__']['__site__'] ) ) {
        $_SESSION['__view__']['__site__'] = SITE_CURRENT;
    }

    // defaults
    if( ! isset( $_SESSION['__view__']['__lang__'] ) ) {
        $_SESSION['__view__']['__lang__'] = ID_LINGUA_CORRENTE;
    }

    /**
     * inizializzazione di $_SESSION['__work__']
     * =========================================
     * 
     * 
     * 
     */

    // inizializzo l'array di lavoro
    if( ! isset( $_SESSION['__work__'] ) ) {
        $_SESSION['__work__'] = array();
    }

    /**
     * inizializzazione di $_REQUEST['__err__']
     * ========================================
     * 
     * 
     * 
     */

    // inizializzo l'array degli errori
    if( ! isset( $_REQUEST['__err__'] ) ) {
        $_REQUEST['__err__'] = array();
    }

    /**
     * inizializzazione di $_REQUEST['__info__']
     * =========================================
     * 
     * 
     * 
     */

    // inizializzo l'array delle informazioni
    if( ! isset( $_REQUEST['__info__'] ) ) {
        $_REQUEST['__info__'] = array();
    }

    /**
     * debug del runlevel
     * ==================
     * 
     * 
     */

    // debug
    // print_r( $_REQUEST );
    // print_r( $_SESSION );
    // print_r( $cf['contents']['pages']['licenza']['content'] );
    // die( 'lingua corrente: ' . $_SESSION['__view__']['__lang__'] );
