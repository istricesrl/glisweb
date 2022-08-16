<?php

    // modulo di questo file
	$m = DIR_MOD . '_0530.crediti/';

	// vista crediti
	$p['crediti.view'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'crediti' ),
		'h1'			=> array( $l		=> 'crediti' ),
		'parent'		=> array( 'id'		=> 'archivio' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_crediti.view.php' ),
		'etc'			=> array( 'tabs'	=> array(	'crediti.view' ) ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'crediti' ),
														'priority'	=> '310' ) ) )
	);

	// gestione crediti
	$p['crediti.form'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'gestione' ),
		'h1'			=> array( $l		=> 'gestione' ),
		'parent'		=> array( 'id'		=> 'crediti.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'crediti.form.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_crediti.form.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'crediti.form' ) )
	);
