<?php

    // modulo di questo file
	$m = DIR_MOD . '_6300.mastri/';

	// vista mastri
	$p['mastri.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'mastri' ),
	    'h1'			=> array( $l		=> 'mastri' ),
	    'parent'		=> array( 'id'		=> 'archivio' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_mastri.view.php' ),
		'etc'			=> array( 'tabs'	=> array(	'mastri.view' ) ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'menu'			=> array( 'admin'	=> array(	'label'		=> array( $l => 'mastri' ),
														'priority'	=> '130' ) )
	);

	// gestione mastri
	$p['mastri.form'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'gestione' ),
	    'h1'			=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'mastri.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'mastri.form.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_mastri.form.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'mastri.form', 'mastri.form.movimenti', 'mastri.form.tools' ) )
	);

	// gestione tools mastri
	$p['mastri.form.movimenti'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'righe' ),
	    'h1'			=> array( $l		=> 'righe' ),
	    'parent'		=> array( 'id'		=> 'mastri.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'mastri.form.movimenti.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_mastri.form.movimenti.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> $p['mastri.form']['etc']['tabs'] )
	);

	// gestione tools mastri
	$p['mastri.form.tools'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'			=> array( $l		=> 'azioni mastri' ),
	    'h1'			=> array( $l		=> 'azioni mastri' ),
	    'parent'		=> array( 'id'		=> 'mastri.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_mastri.form.tools.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> $p['mastri.form']['etc']['tabs'] )
	);

