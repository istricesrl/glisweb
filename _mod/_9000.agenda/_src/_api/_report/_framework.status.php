<?php

    // header
    if( ! headers_sent() ) {
        header( 'Content-type: text/plain' );
    }

    // dipendenza dal modulo attività
    if( ! in_array( '0200.attivita', $cf['mods']['active']['array'] ) ) {
	    die( '[FAIL] dipendenza chiave non soddisfatta con il modulo 0200.attivita' . PHP_EOL );
    }
