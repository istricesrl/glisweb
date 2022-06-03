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
/*
	// pagina principale
	$p['app.logistica'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'app logistica' ),
	    'h1'		=> array( $l		=> 'app logistica' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_minerva/', 'schema' => 'app.logistica.html' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_app.logistica.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'menu'				=> array( 'app'	=> array(	'' => 	array(	'label'		=> array( $l => 'logistica' ),
																	'priority'	=> '020' ) ) )
	);

	// pagina principale
	$p['app.logistica.ordine'] = array(
	    'sitemap'		=> false,
		'icon'				=> '<i class="fa fa-plus" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'nuovo ordine' ),
	    'h1'		=> array( $l		=> 'crea un nuovo ordine' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_minerva/', 'schema' => 'app.logistica.nuovo.ordine.html' ),
	    'parent'		=> array( 'id'		=> 'app.logistica' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_app.logistica.nuovo.ordine.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) )
	);

	// pagina principale
	$p['app.logistica.lista.ordini'] = array(
	    'sitemap'		=> false,
		'icon'				=> '<i class="fa fa-list" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'lista ordini' ),
	    'h1'		=> array( $l		=> 'lista ordini' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_minerva/', 'schema' => 'app.logistica.lista.ordini.html' ),
	    'parent'		=> array( 'id'		=> 'app.logistica' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_app.logistica.lista.ordini.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) )
	);

	// pagina principale
	$p['app.logistica.evasione.oridne'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'evasione ordine' ),
	    'h1'		=> array( $l		=> 'evasione ordine' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_minerva/', 'schema' => 'app.logistica.lista.ordini.html' ),
	    'parent'		=> array( 'id'		=> 'app.logistica.lista.ordini' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_app.logistica.lista.ordini.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) )
	);
*/
/*	// pagina principale
	$p['app.logistica.ddt'] = array(
	    'sitemap'		=> false,
		'icon'				=> '<i class="fa fa-truck" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'crea DDT' ),
	    'h1'		=> array( $l		=> 'crea DDT' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_minerva/', 'schema' => 'app.logistica.nuovo.ordine.html' ),
	    'parent'		=> array( 'id'		=> 'app.logistica' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_app.logistica.nuovo.ordine.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) )
	);
*/