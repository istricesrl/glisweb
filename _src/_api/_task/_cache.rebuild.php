<?php

    /**
     * ricostruzione della cache del sito corrente
     *
     * Questa API ricostruisce l'albero delle pagine e la sitemap del sito a cui appartiene l'host con cui è chiamata,
     * svuota la cache chiave-valore del sito ( memcache, APCU e disco ) e riscrive subito l'albero appena ricostruito,
     * poi risponde con un report in JSON. Non si chiama a mano: la chiama /task/memcache.clean, una volta per ogni sito
     * da pulire, dopo aver controllato i privilegi di chi l'ha lanciato.
     *
     * perché è un'API a parte
     * =======================
     * La ricostruzione forzata si chiede definendo MEMCACHE_REFRESH prima del bootstrap, ma i privilegi si possono
     * controllare solo dopo: fino al 2026-11-12 memcache.clean definiva la costante e controllava GESTIONE_CACHE dopo, quindi
     * anche un anonimo respinto faceva ricostruire pagine e sitemap ( 10-17 secondi a richiesta su utensilerialughese ). E la
     * ricostruzione andava persa, perché il task svuotava la cache subito dopo: la rifaceva il primo visitatore.
     *
     * Questa API si protegge con un gettone, che si controlla **prima** del framework: è un file con un nome casuale che
     * memcache.clean scrive in DIR_VAR_SPOOL_REBUILD ( var/spool/rebuild/, chiusa dal .htaccess ) e che vale una volta sola
     * e per un minuto; chi non lo ha prende un 403 senza che il framework parta.
     *
     * ordine delle operazioni
     * =======================
     * La cache non resta mai vuota per il tempo della ricostruzione:
     *
     * 1. il bootstrap con MEMCACHE_REFRESH ricostruisce tutto e scrive l'albero **sopra** quello vecchio ( _330.pages.php ),
     *    comprese le chiavi sfuggite all'indice CACHE_INDEX ( vedi memcacheGetKeyAge() ); nel frattempo chi visita il sito
     *    legge l'albero vecchio;
     * 2. si svuota la cache del sito, come faceva memcache.clean;
     * 3. si riscrive l'albero ricostruito al punto 1, così la prima richiesta dopo la pulizia lo trova già pronto.
     *
     * Fra il 2 e il 3 passano pochi millesimi di secondo, in cui la cache è vuota: per questo durante il 2 e il 3 l'API tiene
     * il lock della ricostruzione ( CONTENTS_PAGES_LOCK, vedi _src/_config/_300.pages.php ), e chi arriva in quel momento
     * aspetta l'albero invece di ricostruirlo da sé.
     *
     * report
     * ======
     * La risposta dice il sito, il motore di cache, il numero di pagine ricostruite, l'esito dello svuotamento di ciascun
     * motore e della riscrittura, i tempi in secondi e un esito complessivo; se l'esito è negativo risponde con status 500.
     *
     */

    // NOTA questa API si chiama con l'URL /task/cache.rebuild?t=<gettone>, e la chiama /task/memcache.clean

    // il gettone si controlla prima del framework, che non deve partire per chi non ce l'ha; unlink() lo consuma, e se due
    // richieste arrivano con lo stesso gettone passa solo quella che riesce a cancellarlo
    $gettone = ( isset( $_REQUEST['t'] ) && preg_match( '/^[0-9a-f]{32}$/', $_REQUEST['t'] ) ) ? dirname( __DIR__, 3 ) . '/var/spool/rebuild/' . $_REQUEST['t'] : NULL;
    if( empty( $gettone ) || ! is_file( $gettone ) || filemtime( $gettone ) < time() - 60 || ! @unlink( $gettone ) ) {
        http_response_code( 403 );
        header( 'Content-Type: application/json' );
        echo json_encode( array( 'err' => array( 'gettone assente o non valido' ) ) );
        exit;
    }

    // tempo di partenza
    $inizio = microtime( true );

    // inclusione del framework, con la ricostruzione forzata
    define( 'MEMCACHE_REFRESH', 1 );
    if( ! defined( 'INCLUDE_SUBDIR' ) ) {
        require '../../_config.php';
    } else {
        require INCLUDE_SUBDIR . '_config.php';
    }

    // inizializzo l'array del risultato
    $status = array(
        'sito'      => $cf['site']['fqdn'],
        'motore'    => cacheEngine(),
        'pagine'    => count( (array) $cf['contents']['pages'] )
    );

    // tempo della ricostruzione
    $status['tempi']['ricostruzione'] = round( microtime( true ) - $inizio, 3 );

    // il lock della ricostruzione ( vedi _300.pages.php ) l'ha tolto _330.pages.php alla fine del bootstrap: lo riprendo, così
    // chi arriva mentre la cache è vuota, fra lo svuotamento e la riscrittura, aspetta invece di ricostruire da sé
    $cf['contents']['lock'] = cacheAdd( CONTENTS_PAGES_LOCK, time(), CONTENTS_PAGES_LOCK_TTL );

    // svuotamento della cache del sito, in tutti i motori, tranne il lock ( che memcacheFlush() non tocca comunque, perché
    // non sta nell'indice )
    $status['memcache'] = memcacheFlush( $cf['memcache']['connection'], $cf['sites']['1']['domains'][ SITE_STATUS ] );
    $status['apcu'] = ( function_exists( 'apcu_enabled' ) && apcu_enabled() ) ? apcuFlush( $cf['site']['fqdn'], array( CONTENTS_PAGES_LOCK ) ) : null;
    $status['disk'] = diskFlush( $cf['site']['fqdn'], array( CONTENTS_PAGES_LOCK ) );

    // riscrittura dell'albero ricostruito, con le stesse chiavi di _330.pages.php
    $status['scrittura'] = cacheWrite( CONTENTS_PAGES_UPDATED, $cf['contents']['updated'] )
        && cacheWrite( CONTENTS_PAGES_KEY, $cf['contents']['pages'] )
        && cacheWrite( CONTENTS_TREE_KEY, $cf['contents']['tree'] )
        && cacheWrite( CONTENTS_INDEX_KEY, $cf['contents']['index'] )
        && cacheWrite( CONTENTS_REVERSE_KEY, $cf['contents']['reverse'] )
        && cacheWrite( CONTENTS_SHORTCUTS_KEY, $cf['contents']['shortcuts'] )
        && cacheWrite( CONTENTS_PAGES_CACHED, time() );

    // tolgo il lock, se è mio
    if( $cf['contents']['lock'] ) {
        cacheDelete( CONTENTS_PAGES_LOCK );
    }

    // tempo totale
    $status['tempi']['totale'] = round( microtime( true ) - $inizio, 3 );

    // esito complessivo; memcacheFlush() senza memcache non ha niente da svuotare
    $status['esito'] = $status['pagine'] > 0
        && ( $status['memcache'] !== false || ! is_object( $cf['memcache']['connection'] ) )
        && $status['apcu'] !== false
        && $status['disk'] !== false
        && $status['scrittura'];

    // log
    logWrite( 'ricostruzione della cache di ' . $status['sito'] . ': ' . $status['pagine'] . ' pagine in ' . $status['tempi']['totale'] . ' s', 'memcache', ( $status['esito'] ) ? LOG_INFO : LOG_ERR );

    // status
    if( ! $status['esito'] ) {
        http_response_code( 500 );
    }

    // headers
    header( 'Access-Control-Allow-Origin: *' );

    // output
    buildJson( $status );
