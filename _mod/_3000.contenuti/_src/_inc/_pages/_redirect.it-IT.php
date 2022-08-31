<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_3000.contenuti/';

	// vista redirect
	$p['redirect.view'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'redirect' ),
	    'h1'		=> array( $l		=> 'redirect' ),
	    'parent'		=> array( 'id'		=> 'contenuti' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_redirect.view.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'redirect.view',
									'redirect.stats' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'redirect' ),
									'priority'	=> '070' ) ) )										
    );

	// statistiche redirect
	$p['redirect.stats'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-bar-chart" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'statistiche' ),
	    'h1'		=> array( $l		=> 'statistiche' ),
	    'parent'		=> array( 'id'		=> 'contenuti' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.stats.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_redirect.stats.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['redirect.view']['etc']['tabs'] )
    );

    // form redirect
	$p['redirect.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'redirect.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'redirect.form.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_redirect.form.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> array(	'redirect.form',
													'redirect.form.stats') )
	);

	// statistiche form redirect
	$p['redirect.form.stats'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-bar-chart" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'statistiche redirect' ),
	    'h1'		=> array( $l		=> 'statistiche redirect' ),
	    'parent'		=> array( 'id'		=> 'contenuti' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.stats.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_redirect.form.stats.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['redirect.form']['etc']['tabs'] )
    );

