<?php

    /**
     * test delle cache
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // inclusione del framework
	require '../../../_src/_config.php';

    // inizio output
	$tx	 = 'esempio memcache: ' . PHP_EOL;

    // Memcache
	if( ! empty( $cf['memcache']['connection'] ) ) {
	    $tempo = time();
	    $st  = $cf['memcache']['connection']->getStats( '127.0.0.1:11211' );
	    $tx .= 'test di scrittura: ' . $tempo . PHP_EOL;
	    memcacheWrite( $cf['memcache']['connection'], 'test', $tempo );
#	    $tx .= print_r( $cf['memcache'], true );
	    $tx .= 'test di lettura: ' . memcacheRead( $cf['memcache']['connection'], 'test' ) . PHP_EOL;
#	    $tx .= print_r( $st, true );
#	    $tx .= writeByte( $st['bytes'] ) . ' usati su ' . writeByte( $st['limit_maxbytes'] ) . PHP_EOL;
#	    $tx .= sprintf( '%01.2f', $st['bytes'] * 100 / $st['limit_maxbytes'] ) . '% in uso' . PHP_EOL;
#	    $tx .= 'trovati ' . $st['get_hits'] . ' oggetti contro ' . $st['get_misses'] . ' non trovati' . PHP_EOL;
#	    $tx .= sprintf( '%01.2f', $st['get_hits'] * 100 / $st['cmd_get'] ) . '% trovati' . PHP_EOL;
	} else {
	    $tx	.= 'Memcache non attivo' . PHP_EOL;
	}

    // output
	build( $tx );
