<?php

	// lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_5000.logistica/';

	// dashboard logistica
	$p['logistica'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'logistica' ),
	    'h1'			=> array( $l		=> 'logistica' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'logistica.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_logistica.php' ),
		'etc'			=> array( 'tabs'	=> array(	'logistica' ) ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'logistica' ),
														'priority'	=> '320' ) ) )
	);
