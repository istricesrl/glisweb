<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_3300.banner/';

	// vista banner
	$p['banner.view'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'banner' ),
	    'h1'		=> array( $l		=> 'banner' ),
	    'parent'		=> array( 'id'		=> 'contenuti' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_banner.view.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'banner.view',
									'banner.tools' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'banner' ),
									'priority'	=> '060' ) ) )				
	    );

    // gestione banner
	$p['banner.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'banner.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'banner.form.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_banner.form.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> array(	'banner.form',
													'banner.form.pagine',
													'banner.form.immagini',
													'banner.form.metadati') )
	);

	// gestione pagine banner
	$p['banner.form.pagine'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'pagine' ),
	    'h1'		=> array( $l		=> 'pagine' ),
	    'parent'		=> array( 'id'		=> 'banner.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'banner.form.pagine.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_banner.form.pagine.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> $p['banner.form']['etc']['tabs'] )
	);

	// form banner metadati
	$p['banner.form.metadati'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-code" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'metadati' ),
		'h1'		=> array( $l		=> 'metadati' ),
		'parent'		=> array( 'id'		=> 'banner.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'banner.form.metadati.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_banner.form.metadati.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['banner.form']['etc']['tabs'] )
	);

	$p['banner.form.immagini'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-picture-o" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'immagini' ),
		'h1'		=> array( $l		=> 'immagini' ),
		'parent'		=> array( 'id'		=> 'banner.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'banner.form.immagini.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_banner.form.immagini.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['banner.form']['etc']['tabs'] )
	);