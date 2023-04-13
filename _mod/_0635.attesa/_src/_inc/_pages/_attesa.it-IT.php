<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0635.attesa/';

	// dashboard attesa
	$p['attesa.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'lista di attesa' ),
	    'h1'			=> array( $l		=> 'lista di attesa' ),
	    'parent'		=> array( 'id'		=> 'segreteria' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_attesa.view.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'attesa.view',
														'attesa.archivio.view',
														'attesa.stampe',
														'attesa.tools' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'lista di attesa' ),
																		'priority'	=> '220' ) ) )														
	);

    // vista archivio attesa
	$p['attesa.archivio.view'] = array(
	    'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-archive" aria-hidden="true"></i>',
		'title'				=> array( $l		=> 'archivio' ),
	    'h1'				=> array( $l		=> 'archivio' ),
	    'parent'			=> array( 'id'		=> 'attesa.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'				=> array( '_src/_inc/_macro/_attesa.archivio.view.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['attesa.view']['etc']['tabs'] )
	);

	// stampe attesa
	$p['attesa.stampe'] = array(
	    'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-print" aria-hidden="true"></i>',
		'title'				=> array( $l		=> 'stampe' ),
	    'h1'				=> array( $l		=> 'stampe' ),
	    'parent'			=> array( 'id'		=> 'attesa.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_attesa.stampe.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['attesa.view']['etc']['tabs'] )
	);

    // tools attesa
	$p['attesa.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'attesa.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_attesa.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['attesa.view']['etc']['tabs'] )
	);

	// gestione progetti
	$p['attesa.form'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'gestione' ),
		'h1'			=> array( $l		=> 'gestione' ),
		'parent'		=> array( 'id'		=> 'attesa.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'attesa.form.html' ),
		'macro'			=> array( $m.'_src/_inc/_macro/_attesa.form.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'attesa.form', 
														'attesa.form.archiviazione',
														'attesa.form.stampe',
														'attesa.form.tools' ) )
	);

	// stampe attesa
	$p['attesa.form.stampe'] = array(
	    'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-print" aria-hidden="true"></i>',
		'title'				=> array( $l		=> 'stampe corso' ),
	    'h1'				=> array( $l		=> 'stampe' ),
	    'parent'			=> array( 'id'		=> 'attesa.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_attesa.form.stampe.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['attesa.form']['etc']['tabs'] )
	);

    // tools attesa
	$p['attesa.form.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni corso' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'attesa.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_attesa.form.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['attesa.form']['etc']['tabs'] )
	);

	$p['attesa.form.archiviazione'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-archive" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'archiviazione' ),
	    'h1'		=> array( $l		=> 'archiviazione' ),
	    'parent'		=> array( 'id'		=> 'attesa.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'attesa.form.archiviazione.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_attesa.form.archiviazione.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['attesa.form']['etc']['tabs'] )
	);
