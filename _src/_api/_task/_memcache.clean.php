<?php

    /**
     *
     *
     *
     *
     *
     *
     *
     *
     * @todo commentare
     *
     * @file
     *
     */

    // NOTA potete chiamare questa API con l'URL /task/memcache.clean

    // misuro ricreando la cache
	define( 'MEMCACHE_REFRESH', 1 );

    // inclusione del framework
	require_once '../../_config.php';

    // inizializzo l'array del risultato
	$status = array();

    // faccio il flush della cache
	$st['esito'] = memcacheFlush( $cf['memcache']['connection'] );

    // headers
	header( 'Access-Control-Allow-Origin: *' );

    // output
	buildJson( $st );

?>
