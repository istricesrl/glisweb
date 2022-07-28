<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0630.iscrizioni/';

    // gestione anagrafica iscrizioni
	$p['anagrafica.form.iscrizioni'] = array(
	    'sitemap'			=> false,
	    'title'				=> array( $l		=> 'iscrizioni' ),
	    'h1'				=> array( $l		=> 'iscrizioni' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'anagrafica.form.iscrizioni.html' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_anagrafica.form.iscrizioni.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'anagrafica.form' )
	);

	// RELAZIONI CON IL MODULO CORSI
	if( in_array( "0920.corsi", $cf['mods']['active']['array'] ) ) {

		// vista iscrizioni
		$p['iscrizioni.view']	= array(
			'sitemap'			=> false,
			'title'				=> array( $l		=> 'iscrizioni' ),
			'h1'				=> array( $l		=> 'iscrizioni' ),
			'parent'			=> array( 'id'		=> 'segreteria' ),
			'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
			'macro'				=> array( $m . '_src/_inc/_macro/_iscrizioni.view.php' ),
			'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'				=> array( 'tabs'	=> array(	'iscrizioni.view',
																'iscrizioni.archivio.view',
																'iscrizioni.stampe',
																'iscrizioni.tools' ) ),
			'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'iscrizioni' ),
																				'priority'	=> '050' ) ) )
		);

		// vista archivio iscrizioni
		$p['iscrizioni.archivio.view'] = array(
			'sitemap'			=> false,
			'icon'				=> '<i class="fa fa-archive" aria-hidden="true"></i>',
			'title'				=> array( $l		=> 'archivio' ),
			'h1'				=> array( $l		=> 'archivio' ),
			'parent'			=> array( 'id'		=> 'iscrizioni.view' ),
			'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
			'macro'				=> array( $m . '_src/_inc/_macro/_iscrizioni.archivio.view.php' ),
			'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'				=> array( 'tabs'	=> $p['iscrizioni.view']['etc']['tabs'] )
		);

		// stampe iscrizioni
		$p['iscrizioni.stampe'] = array(
			'sitemap'			=> false,
			'icon'				=> '<i class="fa fa-print" aria-hidden="true"></i>',
			'title'				=> array( $l		=> 'stampe' ),
			'h1'				=> array( $l		=> 'stampe' ),
			'parent'			=> array( 'id'		=> 'iscrizioni.view' ),
			'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
			'macro'				=> array( $m . '_src/_inc/_macro/_iscrizioni.stampe.php' ),
			'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'				=> array( 'tabs'	=> $p['iscrizioni.view']['etc']['tabs'] )
		);


		// stampe iscrizioni
		$p['iscrizioni.form'] = array(
			'sitemap'			=> false,
			'title'				=> array( $l		=> 'gestione' ),
			'h1'				=> array( $l		=> 'gestione' ),
			'parent'			=> array( 'id'		=> 'iscrizioni.view' ),
			'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'iscrizioni.form.html' ),
			'macro'				=> array( $m . '_src/_inc/_macro/_iscrizioni.form.php' ),
			'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'				=> array( 'tabs'	=> array(	'iscrizioni.form'  ) )
		);
	}
