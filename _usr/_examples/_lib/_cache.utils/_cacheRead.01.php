<?php

    /**
     * file di esempio per la funzione cacheRead()
     *
     * rilegge quello che ha scritto cacheWrite(), con ciascun motore disponibile
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // motori da provare
    foreach( array( 'memcache', 'apcu', 'disk' ) as $motore ) {

        $cf['cache']['engine'] = $motore;

        // il motore forzato non c'e', si salta
        if( cacheEngine() !== $motore ) {
            continue;
        }

        cacheWrite( 'TEST_CACHE', array( 'TEST CONTENT ' . $motore ) );
        $letto = cacheRead( 'TEST_CACHE' );
        echo $motore . ': ' . ( ( $letto === array( 'TEST CONTENT ' . $motore ) ) ? 'OK' : 'KO' ) . PHP_EOL;
        cacheDelete( 'TEST_CACHE' );

    }
