<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0640.abbonamenti/';

    // gestione anagrafica abbonamenti
	$p['anagrafica.form.abbonamenti'] = array(
	    'sitemap'			=> false,
	    'title'				=> array( $l		=> 'abbonamenti' ),
	    'h1'				=> array( $l		=> 'abbonamenti' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'anagrafica.form.abbonamenti.html' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_anagrafica.form.abbonamenti.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'anagrafica.form' )
	);

    // vista abbonamenti
	$p['abbonamenti.view']	= array(
	    'sitemap'			=> false,
	    'title'				=> array( $l		=> 'abbonamenti' ),
	    'h1'				=> array( $l		=> 'abbonamenti' ),
	    'parent'			=> array( 'id'		=> 'amministrazione' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'				=> array( '_src/_inc/_macro/_abbonamenti.view.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> array(	'abbonamenti.view',
															'abbonamenti.archivio.view',
															'abbonamenti.stampe',
															'abbonamenti.tools' ) ),
	    'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'abbonamenti' ),
																			'priority'	=> '050' ) ) )
	);

    // vista archivio abbonamenti
	$p['abbonamenti.archivio.view'] = array(
	    'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-archive" aria-hidden="true"></i>',
		'title'				=> array( $l		=> 'archivio' ),
	    'h1'				=> array( $l		=> 'archivio' ),
	    'parent'			=> array( 'id'		=> 'abbonamenti.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'				=> array( '_src/_inc/_macro/_abbonamenti.archivio.view.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['abbonamenti.view']['etc']['tabs'] )
	);

	// stampe abbonamenti
	$p['abbonamenti.stampe'] = array(
	    'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-print" aria-hidden="true"></i>',
		'title'				=> array( $l		=> 'stampe' ),
	    'h1'				=> array( $l		=> 'stampe' ),
	    'parent'			=> array( 'id'		=> 'abbonamenti.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'				=> array( '_src/_inc/_macro/_abbonamenti.stampe.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['abbonamenti.view']['etc']['tabs'] )
	);
