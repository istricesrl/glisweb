<?php

    /**
     * file di esempio per la funzione cacheEngine()
     *
     * il motore scelto da solo, quello forzato, e uno forzato che non esiste
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // motore scelto dal framework
    var_dump( in_array( cacheEngine(), array( 'memcache', 'apcu', 'disk' ) ) );

    // motore forzato
    $cf['cache']['engine'] = 'disk';
    var_dump( cacheEngine() );

    // un motore che non esiste fa tornare alla scelta automatica
    $cf['cache']['engine'] = 'inesistente';
    var_dump( in_array( cacheEngine(), array( 'memcache', 'apcu', 'disk' ) ) );
