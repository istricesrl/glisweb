<?php

    // modulo di questo file
	$m = DIR_MOD . '_0300.contatti/';

	// vista indirizzi
	$p['contatti.view'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'contatti' ),
		'h1'		=> array( $l		=> 'contatti' ),
		'parent'		=> array( 'id'		=> 'archivio.commerciale' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_contatti.view.php' ),
		'etc'		=> array( 'tabs'	=> array( 'contatti.view' ) ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'contatti' ),
		'priority'	=> '050' ) ) )
	);

	// gestione indirizzi
	$p['contatti.form'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'gestione' ),
		'h1'		=> array( $l		=> 'gestione' ),
		'parent'		=> array( 'id'		=> 'contatti.view' ),
		'template'		=> array( 'path'	=>  '_src/_templates/_athena/', 'schema' => 'contatti.form.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_contatti.form.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff'  ) ),
		'etc'		=> array( 'tabs'	=> array( 'contatti.form' ) )
		
	);
