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
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../_config.php';
	}

    // inizializzo l'array del risultato
	$status = array();

    // elimino i log
	$maps = glob( DIR_ETC_SITEMAP . 'sitemap.*.{xml,csv}', GLOB_BRACE );
	foreach( $maps as $map ) {
        $status['files'][] = $map;
	    deleteFile( $map );
	}

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
