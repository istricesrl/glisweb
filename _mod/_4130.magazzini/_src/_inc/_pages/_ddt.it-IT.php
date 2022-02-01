<?php

    // modulo di questo file
	$m = DIR_MOD . '_4130.magazzini/';

	// vista ddt
   	$p['ddt.magazzini.view'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'DDT attivi' ),
		'h1'			=> array( $l		=> 'DDT attivi' ),
		'parent'		=> array( 'id'		=> 'magazzini.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_ddt.magazzini.view.php' ),
		'etc'			=> array( 'tabs'	=> array(   'ddt.magazzini.view', 'ddt.passivi.magazzini.view' ) ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'DDT' ),
														'priority'	=> '010' ) ) )	
	);

	// gestione ddt
	$p['ddt.magazzini.form'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'gestione' ),
		'h1'			=> array( $l		=> 'gestione' ),
		'parent'		=> array( 'id'		=> 'ddt.magazzini.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'ddt.magazzini.form.html' ),
		'macro'			=> array( $m.'_src/_inc/_macro/_ddt.magazzini.form.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'ddt.magazzini.form',
														'ddt.magazzini.form.righe',
														'ddt.magazzini.form.stampe',
														'ddt.magazzini.form.tools' ) )
	);

	// gestione righe ddt
	$p['ddt.magazzini.form.righe'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'righe_fatture' ),
		'h1'			=> array( $l		=> 'righe' ),
		'parent'		=> array( 'id'		=> 'ddt.magazzini.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'ddt.magazzini.form.righe.html' ),
		'macro'			=> array( $m.'_src/_inc/_macro/_ddt.magazzini.form.righe.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> $p['ddt.magazzini.form']['etc']['tabs'] )
	);

	// gestione ddt_righe
	$p['ddt.magazzini.righe.form'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'gestione righe' ),
	    'h1'			=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'ddt.magazzini.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'ddt.magazzini.righe.form.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_ddt.magazzini.righe.form.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'ddt.magazzini.righe.form' ) )
	);

	// vista ddt
	$p['ddt.passivi.magazzini.view'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'DDT passivi' ),
		'h1'			=> array( $l		=> 'DDT passivi' ),
		'parent'		=> array( 'id'		=> 'magazzini.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_ddt.passivi.magazzini.view.php' ),
		'etc'			=> array( 'tabs'	=> array(   'ddt.magazzini.view', 'ddt.passivi.magazzini.view' ) ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) )
	);

	// gestione ddt
	$p['ddt.passivi.magazzini.form'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'gestione' ),
		'h1'			=> array( $l		=> 'gestione' ),
		'parent'		=> array( 'id'		=> 'ddt.passivi.magazzini.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'ddt.passivi.magazzini.form.html' ),
		'macro'			=> array( $m.'_src/_inc/_macro/_ddt.passivi.magazzini.form.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'ddt.magazzini.form',
														'ddt.magazzini.form.righe',
														'ddt.magazzini.form.stampe',
														'ddt.magazzini.form.tools' ) )
	);

	// gestione righe ddt
	$p['ddt.passivi.magazzini.form.righe'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'righe_fatture' ),
		'h1'			=> array( $l		=> 'righe' ),
		'parent'		=> array( 'id'		=> 'ddt.passivi.magazzini.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'ddt.passivi.magazzini.form.righe.html' ),
		'macro'			=> array( $m.'_src/_inc/_macro/_ddt.passivi.magazzini.form.righe.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> $p['ddt.passivi.magazzini.form']['etc']['tabs'] )
	);

	// gestione ddt_righe
	$p['ddt.passivi.magazzini.righe.form'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'gestione righe' ),
	    'h1'			=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'ddt.passivi.magazzini.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'ddt.passivi.magazzini.righe.form.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_ddt.passivi.magazzini.righe.form.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'ddt.passivi.magazzini.righe.form' ) )
	);

