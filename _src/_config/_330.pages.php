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

    /**
     * salvataggio della cache dei contenuti
     * =====================================
     * 
     * 
     */

    // debug
    // print_r( $cf['contents']['pages'] );

    // la cache si scrive con il motore della richiesta ( memcache, apcu o disco, vedi _src/_lib/_cache.utils.php ): fino
    // al 2026-11-05 si scriveva solo in memcache
    // cache della timestamp di aggiornamento
    // NOTA questa scrittura deve avvenire ANCHE quando la cache è calda: il gate di _300.pages.php
    // decide se rigenerare confrontando CONTENTS_PAGES_CACHED con CONTENTS_PAGES_UPDATED leggendoli
    // entrambi dalla cache; se CONTENTS_PAGES_UPDATED viene riscritto solo a cache fredda resta
    // congelato al valore del primo build e la struttura delle pagine non si invalida mai più
    cacheWrite( CONTENTS_PAGES_UPDATED, $cf['contents']['updated'] );

    // cache delle pagine
    if( $cf['contents']['cached'] === false ) {

        // scrittura della cache
        cacheWrite( CONTENTS_PAGES_KEY, $cf['contents']['pages'] );
        cacheWrite( CONTENTS_TREE_KEY, $cf['contents']['tree'] );
        cacheWrite( CONTENTS_INDEX_KEY, $cf['contents']['index'] );
        cacheWrite( CONTENTS_REVERSE_KEY, $cf['contents']['reverse'] );
        cacheWrite( CONTENTS_SHORTCUTS_KEY, $cf['contents']['shortcuts'] );
        cacheWrite( CONTENTS_PAGES_CACHED, time() );

        // timer
        timerCheck( $cf['speed'], '-> fine scrittura cache pagine' );

        // log
        logger( 'struttura delle pagine scritta in cache ( ' . cacheEngine() . ' )', 'speed', LOG_INFO );

        // tolgo il lock della ricostruzione, se è mio ( vedi _300.pages.php )
        if( ! empty( $cf['contents']['lock'] ) ) {
            cacheDelete( CONTENTS_PAGES_LOCK );
        }

    } else {

        // log
        logger( 'pagine già presenti in cache, nessuna scrittura richiesta', 'speed' );

    }

    /**
     * debug del runlevel
     * ==================
     * 
     * 
     */

    // debug
    // memcacheDelete( $cf['memcache']['connection'], CONTENTS_TREE_KEY );
    // memcacheDelete( $cf['memcache']['connection'], CONTENTS_INDEX_KEY );
    // memcacheDelete( $cf['memcache']['connection'], CONTENTS_PAGES_KEY );
    // print_r( memcacheRead( $cf['memcache']['connection'], CONTENTS_PAGES_KEY ) );
    // print_r( $cf['localization']['language'] );
    // print_r( $cf['contents']['index'] );
    // print_r( $cf['contents']['pages']['licenza']['content'] );
    // echo $cf['contents']['updated'];
