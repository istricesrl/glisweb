<?php

    // header
    if( ! headers_sent() ) {
        header( 'Content-type: text/plain' );
    }

    // inclusione del framework
	// require_once '../../../../../_src/_config/_config.php';
/*
    // configurazione Google
    if( empty( $cf['google']['profile'] ) ) {
	    echo '[WARN] servizi Google non configurati' . PHP_EOL;
    } else {
        echo '[ -- ] profilo Google esistente per lo status ' . $cf['site']['status'] . PHP_EOL;
        if( empty( $cf['google']['profile']['analytics']['ua'] ) ) {
            echo '[WARN] servizi Google non configurati' . PHP_EOL;
        } else {
            echo '[ -- ] profilo Google Analytics: ' . $cf['google']['profile']['analytics']['ua'] . PHP_EOL;
        }
    }

    // configurazione Facebook
    if( empty( $cf['facebook']['profile'] ) ) {
	    echo '[WARN] servizi Facebook non configurati' . PHP_EOL;
    } else {
        echo '[ -- ] profilo Facebook esistente per lo status ' . $cf['site']['status'] . PHP_EOL;
        if( empty( $cf['facebook']['profile']['pixel']['id'] ) ) {
            echo '[WARN] servizi Facebook non configurati' . PHP_EOL;
        } else {
            echo '[ -- ] pixel di Facebook attivo: ' . $cf['facebook']['profile']['pixel']['id'] . PHP_EOL;
        }
    }
*/