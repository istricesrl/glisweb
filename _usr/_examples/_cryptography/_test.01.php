<?php

    // ...
    require '../../../_src/_config.php';

    // ...
    header( 'content-type: text/plain' );

    // ...
    $s = 'prova';

    // ...
    $es = encryptString( $s, 'test' );

    // ...
    echo 'stringa cifrata da funzione: ' . $es . PHP_EOL;

    // ...
    $ds = decryptString( $es, 'test' );

    // ...
    echo 'stringa decifrata da funzione: ' . $ds . PHP_EOL;
