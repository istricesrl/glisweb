<?php

    /**
     * esempio di encryptString()
     *
     * L'output è controllato da _usr/_test/_tests/unit/cryptographyToolsCest.php: il risultato è il base64 di IV
     * ( 16 byte ), testo cifrato ( lungo quanto il chiaro ) e MAC ( 32 byte ), e l'IV cambia a ogni chiamata, quindi
     * la stessa stringa cifrata due volte dà due risultati diversi ( le asserzioni non dipendono dal formato di
     * var_dump(), che cambia con xdebug ).
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // ...
    header( 'content-type: text/plain' );

    // ...
    $k = 'TEST';

    // ...
    $s = 'TEST CONTENT';

    // ...
    $e1 = encryptString( $s, $k );
    $e2 = encryptString( $s, $k );

    // ...
    echo 'base64 valido: ' . var_export( base64_decode( $e1, true ) !== false, true ) . PHP_EOL;
    echo 'lunghezza grezza: ' . strlen( base64_decode( $e1 ) ) . PHP_EOL;
    echo 'contiene il chiaro: ' . var_export( strpos( base64_decode( $e1 ), $s ) !== false, true ) . PHP_EOL;
    echo 'IV diverso a ogni chiamata: ' . var_export( substr( base64_decode( $e1 ), 0, 16 ) !== substr( base64_decode( $e2 ), 0, 16 ), true ) . PHP_EOL;
    echo 'risultati diversi: ' . var_export( $e1 !== $e2, true ) . PHP_EOL;
    echo 'round trip: ' . var_export( decryptString( $e1, $k ), true ) . PHP_EOL;
    echo 'round trip del secondo: ' . var_export( decryptString( $e2, $k ), true ) . PHP_EOL;
