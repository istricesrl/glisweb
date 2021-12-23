<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_V900.software/';

	 // vista software
	 $p['software.view'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'software' ),
	    'h1'		=> array( $l		=> 'software' ),
	    'parent'		=> array( 'id'		=> 'catalogo' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_software.view.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'software.view') ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'software' ),
									'priority'	=> '025' ) ) )	
	);
	
	// gestione software
	$p['software.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'software.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'software.form.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_software.form.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'software.form' ) )
	);