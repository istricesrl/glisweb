<?php

    /**
     * cache delle pagine
     *
     * la logica generale della cache dei contenuti è che questo file va a leggere tutti i dati necessari per la
     * costruzione dell'albero delle pagine del sito dalla cache; se non ci riesce innesca il ricalcolo di tutto
     * settando come falsa la variabile $cf['contents']['cached']
     *
     *
     * cache dell'elaborazione dei contenuti
     * =====================================
     * In questo file vediamo in azione il meccanismo centrale di caching della parte più onerosa dell'esecuzione del
     * framework, nella fattispecie il caricamento e l'elaborazione dell'albero delle pagine; poiché molti moduli
     * creano, con i loro dati, delle pagine virtuali a loro volta, anche in essi si ritroverà lo stesso meccanismo.
     *
     *
     *
     *
     *
     *
     *
     *
     *
     * TODO documentare
     *
     *
     */

    // se è presente la connessione a memcache
    if( ! empty( $cf['memcache']['connection'] ) ) {

        // tento di leggere i valori dalla cache
        // TODO documentare tutte queste chiavi spiegando bene cosa fanno, cosa contengono e a cosa servono
        $cf['contents']['cached']               = memcacheRead( $cf['memcache']['connection'], CONTENTS_PAGES_CACHED );
        $cf['contents']['updated']              = memcacheRead( $cf['memcache']['connection'], CONTENTS_PAGES_UPDATED );
        $cf['contents']['pages']                = memcacheRead( $cf['memcache']['connection'], CONTENTS_PAGES_KEY );
        $cf['contents']['tree']                 = memcacheRead( $cf['memcache']['connection'], CONTENTS_TREE_KEY );
        $cf['contents']['index']                = memcacheRead( $cf['memcache']['connection'], CONTENTS_INDEX_KEY );
        $cf['contents']['reverse']              = memcacheRead( $cf['memcache']['connection'], CONTENTS_REVERSE_KEY );
        $cf['contents']['shortcuts']            = memcacheRead( $cf['memcache']['connection'], CONTENTS_SHORTCUTS_KEY );

        // timer
        timerCheck( $cf['speed'], '-> fine lettura cache contenuti' );

        // elegibilità della cache
        if( defined( 'MEMCACHE_REFRESH' ) ) {

            // la costante MEMCACHE_REFRESH è definita, forzo il refresh
            $cf['contents']['cached'] = false;

            // log
            logger( 'la costante MEMCACHE_REFRESH è definita, forzo il refresh della cache', 'speed', LOG_INFO );

        } elseif( $cf['contents']['updated']    === false
            || $cf['contents']['pages']         === false
            || $cf['contents']['tree']          === false
            || $cf['contents']['index']         === false
            || $cf['contents']['shortcuts']     === false
            || $cf['contents']['cached']        <= $cf['contents']['updated']
        ) {

            // i contenuti non sono in cache, forzo il refresh
            $cf['contents']['cached'] = false;

            // log
            logger( 'cache dei contenuti non trovata', 'speed', LOG_INFO );

        } else {

            // log
            logger( 'cache dei contenuti trovata', 'speed' );

        }

    } else {

        // memcache non è attivo, impossibile leggere la cache
        $cf['contents']['cached'] = false;

        // log
        logger( 'nessuna connessione a memcache, controlli sulla cache dei contenuti bypassati', 'speed' );

    }

    // debug
    // var_dump( $cf['contents']['cached'] );
    // var_dump( $cf['contents']['updated'] );
    // print_r( $cx['contents'] );
