<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0620.tesseramenti/';

    // gestione anagrafica tesseramenti
	$p['anagrafica.form.tesseramenti'] = array(
	    'sitemap'			=> false,
	    'title'				=> array( $l		=> 'tesseramenti' ),
	    'h1'				=> array( $l		=> 'tesseramenti' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'anagrafica.form.tesseramenti.html' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_anagrafica.form.tesseramenti.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'				=> array( 'tabs'	=> 'anagrafica.form' )
	);

	// RELAZIONI CON IL MODULO CORSI
	if( in_array( "0920.corsi", $cf['mods']['active']['array'] ) ) {

		// vista tesseramenti
		$p['tesseramenti.view']	= array(
			'sitemap'			=> false,
			'title'				=> array( $l		=> 'tesseramenti' ),
			'h1'				=> array( $l		=> 'tesseramenti' ),
			'parent'			=> array( 'id'		=> 'segreteria' ),
			'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
			'macro'				=> array( $m . '_src/_inc/_macro/_tesseramenti.view.php' ),
			'auth'				=> array( 'groups'	=> array(	'roots' ) ),
			'etc'				=> array( 'tabs'	=> array(	'tesseramenti.view',
																'tesseramenti.archivio.view',
																'tesseramenti.tools'
															) ),
			'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'tesseramenti' ),
															'priority'	=> '080' ) ) )

		);

		// vista archivio tesseramenti
		$p['tesseramenti.archivio.view'] = array(
			'sitemap'			=> false,
			'icon'				=> '<i class="fa fa-archive" aria-hidden="true"></i>',
			'title'				=> array( $l		=> 'archivio' ),
			'h1'				=> array( $l		=> 'archivio' ),
			'parent'			=> array( 'id'		=> 'tesseramenti.view' ),
			'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
			'macro'				=> array( $m . '_src/_inc/_macro/_tesseramenti.archivio.view.php' ),
			'auth'				=> array( 'groups'	=> array(	'roots' ) ),
			'etc'				=> array( 'tabs'	=> $p['tesseramenti.view']['etc']['tabs'] )
		);

		// tools tesseramenti
		$p['tesseramenti.tools'] = array(
			'sitemap'			=> false,
			'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
			'title'				=> array( $l		=> 'azioni' ),
			'h1'				=> array( $l		=> 'azioni' ),
			'parent'			=> array( 'id'		=> 'tesseramenti.view' ),
			'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
			'macro'				=> array( $m . '_src/_inc/_macro/_tesseramenti.tools.php' ),
			'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'				=> array( 'tabs'	=> $p['tesseramenti.view']['etc']['tabs'] )
		);

		// gestione progetti
		$p['tesseramenti.form'] = array(
			'sitemap'			=> false,
			'title'				=> array( $l		=> 'gestione' ),
			'h1'				=> array( $l		=> 'gestione' ),
			'parent'			=> array( 'id'		=> 'tesseramenti.view' ),
			'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'tesseramenti.form.html' ),
			'macro'				=> array( $m . '_src/_inc/_macro/_tesseramenti.form.php' ),
			'auth'				=> array( 'groups'	=> array(	'roots' ) ),
			'etc'				=> array( 'tabs'	=> array(	'tesseramenti.form',
																'tesseramenti.form.stampe',
																'tesseramenti.form.tools' 
															) )
		);

		// stampe form tesseramenti
		$p['tesseramenti.form.stampe'] = array(
			'sitemap'			=> false,
			'icon'				=> '<i class="fa fa-print" aria-hidden="true"></i>',
			'title'				=> array( $l		=> 'stampe corso' ),
			'h1'				=> array( $l		=> 'stampe' ),
			'parent'			=> array( 'id'		=> 'tesseramenti.view' ),
			'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
			'macro'				=> array( $m . '_src/_inc/_macro/_tesseramenti.form.stampe.php' ),
			'auth'				=> array( 'groups'	=> array(	'roots' ) ),
			'etc'				=> array( 'tabs'	=> $p['tesseramenti.form']['etc']['tabs'] )
		);

		// tools form tesseramenti
		$p['tesseramenti.form.tools'] = array(
			'sitemap'			=> false,
			'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
			'title'				=> array( $l		=> 'azioni corso' ),
			'h1'				=> array( $l		=> 'azioni' ),
			'parent'			=> array( 'id'		=> 'tesseramenti.view' ),
			'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
			'macro'				=> array( $m . '_src/_inc/_macro/_tesseramenti.form.tools.php' ),
			'auth'				=> array( 'groups'	=> array(	'roots' ) ),
			'etc'				=> array( 'tabs'	=> $p['tesseramenti.form']['etc']['tabs'] )
		);


    // vista archivio tesseramenti
	$p['tesseramenti.archivio.view'] = array(
	    'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-archive" aria-hidden="true"></i>',
		'title'				=> array( $l		=> 'archivio' ),
	    'h1'				=> array( $l		=> 'archivio' ),
	    'parent'			=> array( 'id'		=> 'tesseramenti.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_tesseramenti.archivio.view.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['tesseramenti.view']['etc']['tabs'] )
	);

	// stampe tesseramenti
	$p['tesseramenti.stampe'] = array(
	    'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-print" aria-hidden="true"></i>',
		'title'				=> array( $l		=> 'stampe' ),
	    'h1'				=> array( $l		=> 'stampe' ),
	    'parent'			=> array( 'id'		=> 'tesseramenti.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_tesseramenti.stampe.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['tesseramenti.view']['etc']['tabs'] )
	);
}