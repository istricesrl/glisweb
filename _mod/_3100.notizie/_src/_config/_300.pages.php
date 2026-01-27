<?php

    /**
     * cache delle notizie
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

    // se è presente la connessione a memcache
    if( ! empty( $cf['memcache']['connection'] ) ) {

        // tento di leggere i valori dalla cache
        // TODO documentare tutte queste chiavi spiegando bene cosa fanno, cosa contengono e a cosa servono
        $cf['notizie']['cached']                = memcacheRead( $cf['memcache']['connection'], NOTIZIE_PAGES_CACHED );
        $cf['notizie']['updated']               = memcacheRead( $cf['memcache']['connection'], NOTIZIE_PAGES_UPDATED );
        $cf['notizie']['index']                 = memcacheRead( $cf['memcache']['connection'], NOTIZIE_INDEX_KEY );

        // timer
        timerCheck( $cf['speed'], '-> fine lettura cache contenuti' );

        // elegibilità della cache
        if( defined( 'MEMCACHE_REFRESH' ) ) {

            // la costante MEMCACHE_REFRESH è definita, forzo il refresh
            $cf['notizie']['cached'] = false;

            // log
            logger( 'la costante MEMCACHE_REFRESH è definita, forzo il refresh della cache', 'speed', LOG_INFO );

        } elseif( $cf['notizie']['updated']    === false
            || $cf['notizie']['index']         === false
            || $cf['notizie']['cached']        <= $cf['notizie']['updated']
        ) {

            // i contenuti non sono in cache, forzo il refresh
            $cf['contenuti']['cached'] = false;

            // log
            logger( 'cache dei contenuti non trovata', 'speed', LOG_INFO );

        } else {

            // log
            logger( 'cache dei contenuti trovata', 'speed' );

        }

    } else {

        // memcache non è attivo, impossibile leggere la cache
        $cf['contenuti']['cached'] = false;

        // log
        logger( 'nessuna connessione a memcache, controlli sulla cache dei contenuti bypassati', 'speed' );

    }

    /**
     * debug del runlevel
     * ==================
     * 
     * 
     */

    // debug
    // var_dump( $cf['notizie']['cached'] );
    // var_dump( $cf['notizie']['updated'] );
    // print_r( $cx['notizie'] );
    // die( 'fine ' . __FILE__ );
