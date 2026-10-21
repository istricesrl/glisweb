<?php

    /**
     * esempio di decryptString()
     *
     * L'output è controllato da _usr/_test/_tests/unit/cryptographyToolsCest.php: la stringa cifrata da
     * encryptString() torna in chiaro con la stessa chiave, anche dopo essere passata da un URL; in tutti gli altri
     * casi ( MAC o testo cifrato alterati, chiave sbagliata, formato precedente al 30/09/2026, stringa vuota o non
     * base64 ) il risultato è false.
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
    $e = encryptString( $s, $k );
    $raw = base64_decode( $e );

    // MAC alterato: ultimo byte invertito
    $macAlterato = base64_encode( substr( $raw, 0, -1 ) . chr( ord( substr( $raw, -1 ) ) ^ 1 ) );

    // testo cifrato alterato: primo byte dopo l'IV invertito
    $ctAlterato = base64_encode( substr( $raw, 0, 16 ) . chr( ord( $raw[16] ) ^ 1 ) . substr( $raw, 17 ) );

    // ...
    echo 'round trip: ' . var_export( decryptString( $e, $k ), true ) . PHP_EOL;
    echo 'round trip da URL: ' . var_export( decryptString( urldecode( urlencode( $e ) ), $k ), true ) . PHP_EOL;
    echo 'MAC alterato: ' . var_export( decryptString( $macAlterato, $k ), true ) . PHP_EOL;
    echo 'testo cifrato alterato: ' . var_export( decryptString( $ctAlterato, $k ), true ) . PHP_EOL;
    echo 'chiave sbagliata: ' . var_export( decryptString( $e, 'ALTRA' ), true ) . PHP_EOL;
    echo 'formato vecchio: ' . var_export( decryptString( 'y32VOlv7x3MuzMn7', $k ), true ) . PHP_EOL;
    echo 'stringa vuota: ' . var_export( decryptString( '', $k ), true ) . PHP_EOL;
    echo 'non base64: ' . var_export( decryptString( '%%% non base64 %%%', $k ), true ) . PHP_EOL;
    echo 'troppo corta: ' . var_export( decryptString( base64_encode( 'corta' ), $k ), true ) . PHP_EOL;
