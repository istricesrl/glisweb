<?php

    // modulo di questo file
	$m = DIR_MOD . '_0350.campagne/';

	// vista campagne
	$p['campagne.view'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'campagne' ),
		'h1'		=> array( $l		=> 'campagne' ),
		'parent'		=> array( 'id'		=> 'archivio' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_campagne.view.php' ),
		'etc'		=> array( 'tabs'	=> array( 'campagne.view' ) ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'campagne' ),
		'priority'	=> '050' ) ) )
	);

	// gestione campagne
	$p['campagne.form'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'gestione' ),
		'h1'		=> array( $l		=> 'gestione' ),
		'parent'		=> array( 'id'		=> 'campagne.view' ),
		'template'		=> array( 'path'	=>  '_src/_templates/_athena/', 'schema' => 'campagne.form.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_campagne.form.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff'  ) ),
		'etc'		=> array( 'tabs'	=> array( 'campagne.form', 'campagne.form.contatti' ) )		
	);

	// subview contatti
	$p['campagne.form.contatti'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'contatti_campagna' ),
	    'h1'			=> array( $l		=> 'contatti' ),
	    'parent'		=> array( 'id'		=> 'campagne.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'campagne.form.contatti.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_campagne.form.contatti.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> $p['campagne.form']['etc']['tabs'] )
	);