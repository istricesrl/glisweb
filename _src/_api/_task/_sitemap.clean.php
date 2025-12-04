<?php

    /**
     *
     *
     *
     *
     * TODO commentare
     *
     * 
     *
     */

    // inclusione del framework
    if( ! defined( 'CRON_RUNNING' ) ) {
        if( ! defined( 'INCLUDE_SUBDIR' ) ) {
            require '../../_config.php';
        } else {
            require INCLUDE_SUBDIR . '_config.php';
        }
    }

    // inizializzo l'array del risultato
	$status = array();

    // elimino i log
	$maps = glob( DIR_VAR_SITEMAP . 'sitemap.*.{xml,csv}', GLOB_BRACE );
	foreach( $maps as $map ) {
        $status['files'][] = $map;
	    deleteFile( $map );
	}

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
