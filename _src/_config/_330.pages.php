<?php

    /**
     * salvataggio in cache dei dati delle pagine
     *
     *
     *
     *
     *
     * TODO documentare
     * TODO salvare in cache il rewriteIndex e il tree
     * TODO la funzione rewritePath() viene chiamata per pagine che hanno già un path!
     *
     *
     */

    // debug
    // print_r( $cf['contents']['pages'] );

    // se è presente la connessione a memcache
    if( ! empty( $cf['memcache']['connection'] ) ) {

        // cache della timestamp di aggiornamento
        memcacheWrite( $cf['memcache']['connection'], CONTENTS_PAGES_UPDATED, $cf['contents']['updated'] );

        // cache delle pagine
        if( $cf['contents']['cached'] === false ) {

            // controllo connessione
            if( ! empty( $cf['memcache']['connection'] ) ) {

                // scrittura della cache
                memcacheWrite( $cf['memcache']['connection'], CONTENTS_PAGES_KEY, $cf['contents']['pages'] );
                memcacheWrite( $cf['memcache']['connection'], CONTENTS_TREE_KEY, $cf['contents']['tree'] );
                memcacheWrite( $cf['memcache']['connection'], CONTENTS_INDEX_KEY, $cf['contents']['index'] );
                memcacheWrite( $cf['memcache']['connection'], CONTENTS_REVERSE_KEY, $cf['contents']['reverse'] );
                memcacheWrite( $cf['memcache']['connection'], CONTENTS_SHORTCUTS_KEY, $cf['contents']['shortcuts'] );
                memcacheWrite( $cf['memcache']['connection'], CONTENTS_PAGES_CACHED, time() );

                // timer
                timerCheck( $cf['speed'], '-> fine scrittura cache pagine' );

                // log
                logger( 'struttura delle pagine scritta in cache', 'speed', LOG_ERR );

            } else {

                // log
                logger( 'impossibile scrivere le pagine in cache per mancanza di connessione a memcache', 'speed' );

            }

        } else {

            // log
            logger( 'pagine già presenti in cache, nessuna scrittura richiesta', 'speed' );

        }

    } else {

        // log
        logger( 'nessuna connessione a memcache, controlli sulla cache dei contenuti bypassati', 'speed' );

    }

    // debug
    // memcacheDelete( $cf['memcache']['connection'], CONTENTS_TREE_KEY );
    // memcacheDelete( $cf['memcache']['connection'], CONTENTS_INDEX_KEY );
    // memcacheDelete( $cf['memcache']['connection'], CONTENTS_PAGES_KEY );
    // print_r( memcacheRead( $cf['memcache']['connection'], CONTENTS_PAGES_KEY ) );
    // print_r( $cf['localization']['language'] );
    // print_r( $cf['contents']['index'] );
    // print_r( $cf['contents']['pages']['licenza']['content'] );
    // echo $cf['contents']['updated'];
