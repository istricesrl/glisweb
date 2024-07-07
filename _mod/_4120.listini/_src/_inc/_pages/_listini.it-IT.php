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
		'etc'			=> array( 'tabs'	=> array( 'listini.view', 'prezzi.view', 'sconti.view' ) ),
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
													'listini.form.zone',
													'listini.form.anagrafiche',
#													'listini.form.account',
													'listini.form.gruppi',
													'listini.form.stampe',
													'listini.form.tools',
                                                	) )
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
	$p['listini.form.zone'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-map-o" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'zone' ),
		'h1'		=> array( $l		=> 'zone' ),
		'parent'		=> array( 'id'		=> 'listini.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'listini.form.zone.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_listini.form.zone.php' ),
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

	// gestione anagrafica stampe
	$p['listini.form.stampe'] = array(
	    'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-print" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'stampe prodotto' ),
	    'h1'				=> array( $l		=> 'stampe' ),
	    'parent'			=> array( 'id'		=> 'listini.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_listini.form.stampe.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['listini.form']['etc']['tabs'] )
	);

	// form azioni pagine
	$p['listini.form.tools'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'azioni prodotto' ),
	    'h1'		=> array( $l		=> 'azioni prodotto' ),
	    'parent'		=> array( 'id'		=> 'listini.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_listini.form.tools.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
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

	// gestione listini
	$p['listini.clienti.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione listini clienti' ),
	    'h1'		=> array( $l		=> 'gestione listini clienti' ),
	    'parent'		=> array( 'id'		=> 'listini.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'listini.clienti.form.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_listini.clienti.form.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'listini.clienti.form',
#													'listini.form.prezzi',
#													'listini.form.anagrafiche',
#													'listini.form.account',
#													'listini.form.gruppi'	
                                                ) )
	);

	// gestione listini
	$p['listini.zone.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione listini zone' ),
	    'h1'		=> array( $l		=> 'gestione listini zone' ),
	    'parent'		=> array( 'id'		=> 'listini.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'listini.zone.form.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_listini.zone.form.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'listini.zone.form',
#													'listini.form.prezzi',
#													'listini.form.anagrafiche',
#													'listini.form.account',
#													'listini.form.gruppi'	
                                                ) )
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

    // vista reparti
	$p['sconti.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'sconti' ),
	    'h1'			=> array( $l		=> 'sconti' ),
	    'parent'		=> array( 'id'		=> 'listini.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_sconti.view.php' ),
		'etc'			=> array( 'tabs'	=> 'listini.view' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) )
	);

	// gestione listini
	$p['sconti.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione sconti' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'sconti.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'sconti.form.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_sconti.form.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'sconti.form', 'sconti.form.listini', 'sconti.form.articoli'	) )
	);

	// gestione listini gruppi
	$p['sconti.form.listini'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'listini' ),
		'h1'		=> array( $l		=> 'listini' ),
		'parent'		=> array( 'id'		=> 'sconti.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'sconti.form.listini.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_sconti.form.listini.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['sconti.form']['etc']['tabs'] )
	);

	// gestione sconti gruppi
	$p['sconti.form.articoli'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'articoli' ),
		'h1'		=> array( $l		=> 'articoli' ),
		'parent'		=> array( 'id'		=> 'sconti.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'sconti.form.articoli.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_sconti.form.articoli.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['sconti.form']['etc']['tabs'] )
	);

	// gestione listini
	$p['sconti.articoli.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione sconti articoli' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'sconti.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'sconti.articoli.form.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_sconti.articoli.form.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'sconti.articoli.form'	) )
	);

	// gestione listini
	$p['sconti.listini.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione sconti listini' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'sconti.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'sconti.listini.form.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_sconti.listini.form.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'sconti.listini.form'	) )
	);

