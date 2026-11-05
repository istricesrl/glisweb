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

    /**
     * verifica della cache dei contenuti
     * ==================================
     * 
     * 
     */

    // la cache si legge con il motore della richiesta ( memcache, apcu o disco, vedi _src/_lib/_cache.utils.php ): fino al
    // 2026-11-05 si leggeva solo da memcache, e senza memcache l'albero delle pagine si ricostruiva a ogni richiesta
    // tento di leggere i valori dalla cache
    // TODO documentare tutte queste chiavi spiegando bene cosa fanno, cosa contengono e a cosa servono
    $cf['contents']['cached']               = cacheRead( CONTENTS_PAGES_CACHED );
    $cf['contents']['updated']              = cacheRead( CONTENTS_PAGES_UPDATED );
    $cf['contents']['pages']                = cacheRead( CONTENTS_PAGES_KEY );
    $cf['contents']['tree']                 = cacheRead( CONTENTS_TREE_KEY );
    $cf['contents']['index']                = cacheRead( CONTENTS_INDEX_KEY );
    $cf['contents']['reverse']              = cacheRead( CONTENTS_REVERSE_KEY );
    $cf['contents']['shortcuts']            = cacheRead( CONTENTS_SHORTCUTS_KEY );

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
        logger( 'cache dei contenuti trovata ( ' . cacheEngine() . ' )', 'speed' );

    }

    /**
     * debug del runlevel
     * ==================
     * 
     * 
     */

    // debug
    // var_dump( $cf['contents']['cached'] );
    // var_dump( $cf['contents']['updated'] );
    // print_r( $cx['contents'] );
    // die( 'fine ' . __FILE__ );
