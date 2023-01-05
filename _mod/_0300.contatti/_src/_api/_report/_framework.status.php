<?php

    // header
    if( ! headers_sent() ) {
        header( 'Content-type: text/plain' );
    }

    // inclusione del framework
	// require_once '../../../../../_src/_config/_config.php';

    // verifica moduli
    foreach( $cf['contatti'] as $form => $dati ) {
        if( ! isset( $cf['privacy']['moduli'][ $form ]['consensi'] ) || empty( $cf['privacy']['moduli'][ $form ]['consensi'] ) ) {
            echo '[WARN] informazioni di privacy mancanti per il modulo: ' . $form . PHP_EOL;
        } else {
            echo '[ OK ] informazioni di privacy presenti per il modulo: ' . $form . PHP_EOL;
        }
    }
