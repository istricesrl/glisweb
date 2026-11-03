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
     * pulizia dei flag dei moduli di account
     * ======================================
     *
     * Fix 2026-11-03: i flag __tk_ok__, __tk_sent__, __ts_check__ e __err__ dei blocchi __signup__,
     * __profile__ e __pwreset__ li scrivono le macro di registrazione, profilo e reimpostazione della
     * password, e i template li stampano con |raw perche' i testi contengono HTML. Se arrivano gia'
     * dalla richiesta ( ?__signup__[__tk_sent__][testo][it-IT]=<script>... ) sono HTML iniettato nella
     * pagina, anche dove la macro non gira ( il blocco di registrazione incluso nella pagina di login ):
     * quindi si tolgono qui, prima di qualunque macro, e restano solo quelli scritti dal server.
     *
     */

    // tolgo i flag arrivati dal client
    foreach( array( '__signup__', '__profile__', '__pwreset__' ) as $blocco ) {
        if( isset( $_REQUEST[ $blocco ] ) && is_array( $_REQUEST[ $blocco ] ) ) {
            foreach( array( '__tk_ok__', '__tk_sent__', '__ts_check__', '__err__' ) as $flag ) {
                unset( $_REQUEST[ $blocco ][ $flag ] );
            }
        }
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
