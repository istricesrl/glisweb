<?php

    /**
     *
     *
     *
     *
     * @todo commentare
     *
     * @file
     *
     */

    // inclusione del framework
	require_once '../../_config.php';

    // inizializzo l'array del risultato
	$status = array();

    // faccio il flush della cache
	$st['esito'] = recursiveDelete( DIR_VAR_CACHE_PAGES );

    // headers
	header( 'Access-Control-Allow-Origin: *' );

    // output
	buildJson( $st );

?>
