<?php

    /* tool per l'analisi del funzionamento del framework */

    // header
	header( 'Content-type: text/plain' );

    // inclusione del framework
	require '../../_config.php';

    // output
	echo 'STATUS DEL FRAMEWORK' . PHP_EOL . PHP_EOL;

    // versione di PHP
	if( ( version_compare( PHP_VERSION, '7.0.0' ) >= 0 ) ) {
	    echo '[ OK ] versione di PHP (' . PHP_VERSION . ') supportata: ' . PHP_VERSION . PHP_EOL;
	} else {
	    die( '[FAIL] versione di PHP (' . PHP_VERSION . ') non supportata: ' . PHP_VERSION . PHP_EOL );
	}

    // versione del framework
	if( version_compare( VERSION_CURRENT, VERSION_LATEST ) == 0 ) {
	    echo '[ OK ] framework aggiornato alla stable (' . VERSION_CURRENT . ')' . PHP_EOL;
	} elseif( version_compare( VERSION_CURRENT, VERSION_LATEST ) == -1 ) {
	    echo '[WARN] stai usando una versione obsoleta (' . VERSION_CURRENT . ') rispetto alla stable ' . VERSION_LATEST . PHP_EOL;
	} else {
	    echo '[INFO] stai usando una versione di sviluppo (' . VERSION_CURRENT . ') superiore alla stable ' . VERSION_LATEST . PHP_EOL;
	}
