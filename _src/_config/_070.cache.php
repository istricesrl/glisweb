<?php

    /**
     * utilizzo della cache statica delle pagine
     *
     * Quando la cache delle pagine è abilitata (profilo cache 'pages' attivo), questo runlevel intercetta
     * la richiesta prima che venga eseguito il codice di rendering e, se esiste un file di cache valido
     * per la richiesta corrente, ne restituisce direttamente il contenuto evitando l'intero stack del
     * framework. La chiave di cache è un hash MD5 calcolato a partire da: nome del server, URI richiesta,
     * parametri $_REQUEST, vista corrente in sessione, stato di spedizione del carrello, id account
     * loggato, parametri di login e cookie privacy — in modo che varianti significative della stessa
     * pagina abbiano file di cache distinti.
     *
     * Quando la pagina viene servita dalla cache, in coda al contenuto vengono aggiunti dei commenti
     * HTML diagnostici che riportano data di scrittura del file di cache (cached:), data di scadenza
     * effettiva (expire:), URL della pagina (page:) e nome del file di cache (file:). Questi commenti
     * permettono di verificare al volo, leggendo l'HTML della pagina, se è stata servita dalla cache
     * e quando scadrà.
     *
     *
     *
     */

    // debug
    // print_r( $_COOKIE );

    /**
     * recupero della cache dei contenuti statici
     * ==========================================
     * Se il profilo cache 'pages' è attivo, viene calcolata la chiave del file di cache per la
     * richiesta corrente, definita la costante FILE_CACHE_PAGE con il path del file e le costanti
     * FILE_CACHE_PAGE_LIMIT (timestamp di scadenza, fra 18 e 24 ore fa con jitter casuale per evitare
     * stampede di rigenerazione) e FILE_CACHE_PAGE_TIME (timestamp di scrittura del file, se esiste).
     * Se il file esiste e non è scaduto viene servito al client insieme ai commenti HTML diagnostici
     * e l'esecuzione termina con die().
     *
     */

    // se è attiva la cache delle pagine
    if( isset( $cf['cache']['profile']['pages'] ) && ! empty( $cf['cache']['profile']['pages'] ) ) {

        // file per la cache della pagina corrente
        $cachefile = DIR_VAR_CACHE_PAGES . md5(
            $_SERVER['SERVER_NAME'] .
            $_SERVER['REQUEST_URI'] .
            serialize( $_REQUEST ) .
            ( ( isset( $_SESSION['__view__'] ) ) ? serialize( $_SESSION['__view__'] ) : NULL ) .
            ( ( isset( $_SESSION['carrello']['spedizione_id_stato'] ) ) ? $_SESSION['carrello']['spedizione_id_stato'] : NULL ) .
            ( ( isset( $_SESSION['account']['id'] ) ) ? $_SESSION['account']['id'] : NULL ) .
            ( ( isset( $_REQUEST['__login__'] ) ) ? serialize( $_REQUEST['__login__'] ) : NULL ) .
            ( ( isset( $_COOKIE['privacy'] ) ) ? $_COOKIE['privacy'] : NULL )
        );

        // costante per il file per la cache della pagina corrente
        define( 'FILE_CACHE_PAGE', $cachefile );

        // costanti per i tempi
        define( 'FILE_CACHE_PAGE_LIMIT', ( strtotime( '-' . ( 18 + rand( 0, 6 ) ) . ' hours' ) ) );
        define( 'FILE_CACHE_PAGE_TIME', ( file_exists( $cachefile ) ) ? filemtime( $cachefile ) : NULL );

        // se il file di cache esiste e non è scaduto
        if( FILE_CACHE_PAGE_TIME > FILE_CACHE_PAGE_LIMIT ) {
            $cacheinfo = PHP_EOL .
            '<!-- cached: ' . date( 'Y/m/d H:i:s', FILE_CACHE_PAGE_TIME ) . ' -->'        . PHP_EOL .
            '<!-- expire: ' . date( 'Y/m/d H:i:s', FILE_CACHE_PAGE_LIMIT ) . ' -->'        . PHP_EOL .
            '<!-- page: ' . $_SERVER['SERVER_NAME'] . $_SERVER['REQUEST_URI'] . ' -->'    . PHP_EOL .
            '<!-- file: ' . basename( FILE_CACHE_PAGE ) . ' -->'                . PHP_EOL;
            header( 'Content-type: text/html; charset=utf8' );
            die( file_get_contents( FILE_CACHE_PAGE ) . $cacheinfo );
        }

    }

    /**
     * debug del runlevel
     * ==================
     * In questa sezione sono presenti, commentate, delle righe utili per il debug di questo runlevel.
     *
     */

    // debug
    // echo 'OUTPUT';
