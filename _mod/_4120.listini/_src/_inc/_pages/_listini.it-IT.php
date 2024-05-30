<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_4120.listini/';

	// vista listini
	$p['listini.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'listini' ),
	    'h1'			=> array( $l		=> 'listini' ),
	    'parent'		=> array( 'id'		=> 'catalogo' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_listini.view.php' ),
		'etc'			=> array( 'tabs'	=> array( 'listini.view', 'prezzi.view' ) ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'listini' ),
								'priority'	=> '035' ) ) )
	);

	// gestione listini
	$p['listini.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'listini.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'listini.form.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_listini.form.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'listini.form',
													'listini.form.prezzi',
													'listini.form.anagrafiche',
													'listini.form.account',
													'listini.form.gruppi'	) )
	);

	// gestione listini gruppi
	$p['listini.form.prezzi'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'prezzi listino' ),
		'h1'		=> array( $l		=> 'prezzi' ),
		'parent'		=> array( 'id'		=> 'listini.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'listini.form.prezzi.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_listini.form.prezzi.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['listini.form']['etc']['tabs'] )
	);

	// gestione listini gruppi
	$p['listini.form.anagrafiche'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-user-o" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'anagrafiche' ),
		'h1'		=> array( $l		=> 'anagrafiche' ),
		'parent'		=> array( 'id'		=> 'listini.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'listini.form.anagrafiche.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_listini.form.anagrafiche.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['listini.form']['etc']['tabs'] )
	);

	// gestione listini gruppi
	$p['listini.form.account'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-user" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'account' ),
		'h1'		=> array( $l		=> 'account' ),
		'parent'		=> array( 'id'		=> 'listini.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'listini.form.account.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_listini.form.account.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['listini.form']['etc']['tabs'] )
	);

	// gestione listini gruppi
	$p['listini.form.gruppi'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-users" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'gruppi' ),
		'h1'		=> array( $l		=> 'gruppi' ),
		'parent'		=> array( 'id'		=> 'listini.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'listini.form.gruppi.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_listini.form.gruppi.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['listini.form']['etc']['tabs'] )
	);

	// vista reparti
	$p['prezzi.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'prezzi' ),
	    'h1'			=> array( $l		=> 'prezzi' ),
	    'parent'		=> array( 'id'		=> 'listini.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_prezzi.view.php' ),
		'etc'			=> array( 'tabs'	=> 'listini.view' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) )
	);

	// gestione listini
	$p['prezzi.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione prezzi' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'prezzi.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'prezzi.form.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_prezzi.form.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'prezzi.form'	) )
	);

	// vista reparti
	$p['reparti.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'reparti' ),
	    'h1'			=> array( $l		=> 'reparti' ),
	    'parent'		=> array( 'id'		=> 'catalogo' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_reparti.view.php' ),
		'etc'			=> array( 'tabs'	=> array( 'reparti.view' ) ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'reparti' ),
		'priority'	=> '045' ) ) )
	);

	// gestione reparti
	$p['reparti.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'reparti.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'reparti.form.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_reparti.form.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'reparti.form' ) )
	);

/*
	TODO spostare nel modulo coupon

		// vista coupon
	$p['coupon.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'coupon' ),
	    'h1'			=> array( $l		=> 'coupon' ),
	    'parent'		=> array( 'id'		=> 'catalogo' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_coupon.view.php' ),
		'etc'			=> array( 'tabs'	=> array( 'coupon.view' ) ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'coupon' ),
								'priority'	=> '025' ) ) )
	);

	// gestione listini
	$p['coupon.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'coupon.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'coupon.form.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_coupon.form.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'coupon.form'		) )
	);
*/
