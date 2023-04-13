<?php

    // debug
	// echo __FILE__ . PHP_EOL;

    // directory solo custom
	define( 'DIR_VAR_LOG_ESCPOS'		, DIR_BASE . 'var/log/escpos/' );

    // file
	define( 'FILE_ESCPOS_TRANSCRIPT'	, DIR_VAR_LOG_ESCPOS . date( 'YmdH' ) . '.log' );

    // array di base
	$cf['casse'] = array();

    // configurazione extra
	if( isset( $cx['casse'] ) ) {
	    $cf['casse'] = array_replace_recursive( $cf['casse'], $cx['casse'] );
	}
