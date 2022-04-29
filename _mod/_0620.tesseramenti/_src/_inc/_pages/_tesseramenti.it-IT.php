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
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'anagrafica.form' )
	);

	// RELAZIONI CON IL MODULO CORSI
	if( in_array( "0920.corsi", $cf['mods']['active']['array'] ) ) {

		// vista tesseramenti
		$p['tesseramenti.view']	= array(
			'sitemap'			=> false,
			'title'				=> array( $l		=> 'tesseramenti' ),
			'h1'				=> array( $l		=> 'tesseramenti' ),
			'parent'			=> array( 'id'		=> 'corsi' ),
			'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
			'macro'				=> array( $m . '_src/_inc/_macro/_tesseramenti.view.php' ),
			'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'				=> array( 'tabs'	=> array(	'tesseramenti.view',
																'tesseramenti.archivio.view',
																'tesseramenti.stampe',
																'tesseramenti.tools' ) ),
			'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'tesseramenti' ),
																				'priority'	=> '050' ) ) )
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
