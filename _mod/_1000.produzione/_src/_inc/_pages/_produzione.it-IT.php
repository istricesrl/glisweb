<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_1000.produzione/';

	// dashboard produzione
	$p['produzione'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'produzione' ),
	    'h1'			=> array( $l		=> 'produzione' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'produzione.html' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_produzione.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'produzione' ) ),
	    'menu'			=> array( 'admin'	=> array(	'label'		=> array( $l => 'produzione' ),
														'priority'	=> '200' ) )
	);

