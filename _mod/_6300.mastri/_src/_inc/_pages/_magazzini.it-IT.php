<?php

    // modulo di questo file
	$m = DIR_MOD . '_6300.mastri/';

	// vista magazzini
	$p['magazzini.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'magazzini' ),
	    'h1'			=> array( $l		=> 'magazzini' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_magazzini.view.php' ),
		'etc'			=> array( 'tabs'	=> array(	'magazzini.view' ) ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'magazzini' ),
														'priority'	=> '230' ) ) )
	);

	// gestione magazzini
	$p['magazzini.form'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'gestione' ),
	    'h1'			=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'magazzini.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'magazzini.form.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_magazzini.form.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'magazzini.form', 'magazzini.form.giacenze', 'magazzini.form.movimenti', 'magazzini.form.stampe', 'magazzini.form.tools' ) )
	);

	// vista giacenze magazzini
	$p['magazzini.form.giacenze'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'giacenze' ),
	    'h1'			=> array( $l		=> 'giacenze' ),
	    'parent'		=> array( 'id'		=> 'magazzini.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'magazzini.form.giacenze.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_magazzini.form.giacenze.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> $p['magazzini.form']['etc']['tabs'] )
	);

	// vista movimenti magazzini
	$p['magazzini.form.movimenti'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'movimenti' ),
	    'h1'			=> array( $l		=> 'movimenti' ),
	    'parent'		=> array( 'id'		=> 'magazzini.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'magazzini.form.movimenti.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_magazzini.form.movimenti.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> $p['magazzini.form']['etc']['tabs'] )
	);

	// vista ddt
   	$p['ddt.magazzini.view'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'DDT' ),
		'h1'			=> array( $l		=> 'DDT' ),
		'parent'		=> array( 'id'		=> 'magazzini.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_ddt.magazzini.view.php' ),
		'etc'			=> array( 'tabs'	=> array(   'ddt.magazzini.view' ) ),
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

