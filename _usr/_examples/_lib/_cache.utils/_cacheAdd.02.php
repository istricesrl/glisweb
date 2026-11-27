<?php

    /**
     * file di esempio per la funzione cacheAdd() come lock della ricostruzione delle pagine
     *
     * prende il lock CONTENTS_PAGES_LOCK e rende vecchia la cache dell'albero, poi chiede la home: la richiesta deve rispondere
     * con la copia in cache senza ricostruire, quindi CONTENTS_PAGES_CACHED non cambia ( vedi _src/_config/_300.pages.php );
     * gira in Apache, quindi con il motore della richiesta, e alla fine rimette tutto com'era
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // la cache com'e' adesso
    $cached = cacheRead( CONTENTS_PAGES_CACHED );
    $updated = cacheRead( CONTENTS_PAGES_UPDATED );

    // prendo il lock e rendo vecchia la cache
    var_dump( cacheAdd( CONTENTS_PAGES_LOCK, time(), 60 ) );
    cacheWrite( CONTENTS_PAGES_UPDATED, time() + 3600 );

    // chiedo la home
    $status = NULL;
    $raw = NULL;
    restCall( $cf['site']['url'], METHOD_GET, NULL, MIME_TEXT_HTML, MIME_TEXT_PLAIN, $status, array(), NULL, NULL, $error, NULL, CURLAUTH_BASIC, $raw );
    var_dump( (int) $status );

    // nessuno ha ricostruito
    var_dump( cacheRead( CONTENTS_PAGES_CACHED ) === $cached );

    // pulizia
    cacheWrite( CONTENTS_PAGES_UPDATED, $updated );
    cacheDelete( CONTENTS_PAGES_LOCK );
