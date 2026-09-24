<?php

    // header
    if( ! headers_sent() ) {
        header( 'Content-type: text/plain' );
    }

    // inclusione del framework
	// require_once '../../../../../_src/_config/_config.php';

    // configurazione stampante
    if( empty( $cf['casse']['printer'] ) ) {
	    echo '[WARN] nessuna stampante fiscale configurata' . PHP_EOL;
    } else {
        echo '[ -- ] stampante fiscale configurata su ' . $cf['casse']['printer']['address'] . ':' . $cf['casse']['printer']['port'] . PHP_EOL;
        $pingRes = pingIp( $cf['casse']['printer']['address'], $cf['casse']['printer']['port'] );
        if( $pingRes ) {
            echo '[ OK ] stampante fiscale correttamente raggiungibile' . PHP_EOL;
        } else {
            echo '[FAIL] impossibile connettersi alla stampante fiscale (' . $pingRes . ')' . PHP_EOL;
        }
    }