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
    //
    // chi ricostruisce l'albero prende il lock CONTENTS_PAGES_LOCK ( cacheAdd() è atomica, una sola richiesta lo ottiene ) e
    // _330.pages.php lo toglie dopo aver scritto la cache: mentre c'è, chi trova la cache vecchia usa la copia vecchia invece di
    // ricostruire a sua volta, e chi la trova vuota aspetta che compaia, fino a CONTENTS_PAGES_LOCK_WAIT secondi. Fino al
    // 2026-11-12 ogni richiesta che non trovava la cache si metteva a ricostruire, e su un sito grande dieci ricostruzioni
    // insieme si rallentavano a vicenda; se il lock non si riesce a scrivere né a leggere si ricostruisce come allora
    $cf['contents']['lock'] = false;

    if( defined( 'MEMCACHE_REFRESH' ) ) {

        // la costante MEMCACHE_REFRESH è definita, forzo il refresh
        $cf['contents']['cached'] = false;

        // il lock lo prende anche il refresh forzato, se è libero: chi trova la cache vecchia nel frattempo non ricostruisce
        $cf['contents']['lock'] = cacheAdd( CONTENTS_PAGES_LOCK, time(), CONTENTS_PAGES_LOCK_TTL );

        // log
        logger( 'la costante MEMCACHE_REFRESH è definita, forzo il refresh della cache', 'speed', LOG_INFO );

    } elseif( $cf['contents']['updated']    === false
        || $cf['contents']['pages']         === false
        || $cf['contents']['tree']          === false
        || $cf['contents']['index']         === false
        || $cf['contents']['shortcuts']     === false
        || $cf['contents']['cached']        <= $cf['contents']['updated']
    ) {

        // provo a prendere il lock della ricostruzione
        $preso = cacheAdd( CONTENTS_PAGES_LOCK, time(), CONTENTS_PAGES_LOCK_TTL );

        if( $preso || cacheRead( CONTENTS_PAGES_LOCK ) === false ) {

            // i contenuti non sono in cache, o sono vecchi, e nessun altro li sta ricostruendo: forzo il refresh
            $cf['contents']['cached'] = false;
            $cf['contents']['lock'] = $preso;

            // log
            logger( 'cache dei contenuti non trovata o vecchia, la ricostruisco', 'speed', LOG_INFO );

        } elseif( $cf['contents']['pages']  !== false
            && $cf['contents']['tree']      !== false
            && $cf['contents']['index']     !== false
            && $cf['contents']['shortcuts'] !== false
        ) {

            // un'altra richiesta sta ricostruendo e la copia in cache c'è, anche se vecchia: la uso ( cached resta com'è, quindi
            // né i _310.pages.php dei moduli né _330.pages.php ricostruiscono o scrivono )
            logger( 'ricostruzione dei contenuti in corso in un\'altra richiesta, uso la copia in cache', 'speed', LOG_INFO );

        } else {

            // un'altra richiesta sta ricostruendo e la cache è vuota: aspetto che l'albero compaia, finché c'è il lock
            $attesa = time() + CONTENTS_PAGES_LOCK_WAIT;
            do {
                usleep( 250000 );
                $cf['contents']['pages'] = cacheRead( CONTENTS_PAGES_KEY );
            } while( $cf['contents']['pages'] === false && time() < $attesa && cacheRead( CONTENTS_PAGES_LOCK ) !== false );

            // rileggo il resto
            $cf['contents']['cached']               = cacheRead( CONTENTS_PAGES_CACHED );
            $cf['contents']['updated']              = cacheRead( CONTENTS_PAGES_UPDATED );
            $cf['contents']['tree']                 = cacheRead( CONTENTS_TREE_KEY );
            $cf['contents']['index']                = cacheRead( CONTENTS_INDEX_KEY );
            $cf['contents']['reverse']              = cacheRead( CONTENTS_REVERSE_KEY );
            $cf['contents']['shortcuts']            = cacheRead( CONTENTS_SHORTCUTS_KEY );

            if( $cf['contents']['pages']        === false
                || $cf['contents']['tree']      === false
                || $cf['contents']['index']     === false
                || $cf['contents']['shortcuts'] === false
                || $cf['contents']['cached']    === false
            ) {

                // l'altra ricostruzione non è finita in tempo, o è morta: ricostruisco da me
                $cf['contents']['cached'] = false;

                // log
                logger( 'ricostruzione dei contenuti in un\'altra richiesta non conclusa in ' . CONTENTS_PAGES_LOCK_WAIT . ' secondi, la ricostruisco', 'speed', LOG_WARNING );

            } else {

                // log
                logger( 'cache dei contenuti trovata dopo l\'attesa ( ' . cacheEngine() . ' )', 'speed', LOG_INFO );

            }

        }

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
