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

	// RELAZIONI CON IL MODULO CORSI
	if( in_array( "0920.corsi", $cf['mods']['active']['array'] ) ) {

		// vista abbonamenti
		$p['abbonamenti.view']	= array(
			'sitemap'			=> false,
			'title'				=> array( $l		=> 'abbonamenti' ),
			'h1'				=> array( $l		=> 'abbonamenti' ),
			'parent'			=> array( 'id'		=> 'segreteria' ),
			'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
			'macro'				=> array( $m . '_src/_inc/_macro/_abbonamenti.view.php' ),
			'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'				=> array( 'tabs'	=> array(	'abbonamenti.view',
																'abbonamenti.archivio.view',
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
			'macro'				=> array( $m . '_src/_inc/_macro/_abbonamenti.archivio.view.php' ),
			'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'				=> array( 'tabs'	=> $p['abbonamenti.view']['etc']['tabs'] )
		);

		// stampe abbonamenti
		$p['abbonamenti.tools'] = array(
			'sitemap'			=> false,
			'icon'				=> '<i class="fa fa-print" aria-hidden="true"></i>',
			'title'				=> array( $l		=> 'azioni' ),
			'h1'				=> array( $l		=> 'azioni' ),
			'parent'			=> array( 'id'		=> 'abbonamenti.view' ),
			'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
			'macro'				=> array( $m . '_src/_inc/_macro/_abbonamenti.tools.php' ),
			'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'				=> array( 'tabs'	=> $p['abbonamenti.view']['etc']['tabs'] )
		);

		// gestione progetti
		$p['abbonamenti.form'] = array(
			'sitemap'			=> false,
			'title'				=> array( $l		=> 'gestione' ),
			'h1'				=> array( $l		=> 'gestione' ),
			'parent'			=> array( 'id'		=> 'abbonamenti.view' ),
			'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'abbonamenti.form.html' ),
			'macro'				=> array( $m . '_src/_inc/_macro/_abbonamenti.form.php' ),
			'auth'				=> array( 'groups'	=> array(	'roots' ) ),
			'etc'				=> array( 'tabs'	=> array(	'abbonamenti.form',
																'abbonamenti.form.stampe',
																'abbonamenti.form.tools' 
															) )
		);

		// stampe form abbonamenti
		$p['abbonamenti.form.stampe'] = array(
			'sitemap'			=> false,
			'icon'				=> '<i class="fa fa-print" aria-hidden="true"></i>',
			'title'				=> array( $l		=> 'stampe corso' ),
			'h1'				=> array( $l		=> 'stampe' ),
			'parent'			=> array( 'id'		=> 'abbonamenti.view' ),
			'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
			'macro'				=> array( $m . '_src/_inc/_macro/_abbonamenti.form.stampe.php' ),
			'auth'				=> array( 'groups'	=> array(	'roots' ) ),
			'etc'				=> array( 'tabs'	=> $p['abbonamenti.form']['etc']['tabs'] )
		);

		// tools form abbonamenti
		$p['abbonamenti.form.tools'] = array(
			'sitemap'			=> false,
			'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
			'title'				=> array( $l		=> 'azioni corso' ),
			'h1'				=> array( $l		=> 'azioni' ),
			'parent'			=> array( 'id'		=> 'abbonamenti.view' ),
			'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
			'macro'				=> array( $m . '_src/_inc/_macro/_abbonamenti.form.tools.php' ),
			'auth'				=> array( 'groups'	=> array(	'roots' ) ),
			'etc'				=> array( 'tabs'	=> $p['abbonamenti.form']['etc']['tabs'] )
		);

		// rinnovi contratti
		$p['abbonamenti.form.rinnovi' ] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'rinnovi' ),
			'h1'			=> array( $l		=> 'rinnovi' ),
			'parent'		=> array( 'id'		=> 'abbonamenti.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'abbonamenti.form.rinnovi.html' ),
			'macro'			=> array(  $m . '_src/_inc/_macro/_abbonamenti.form.rinnovi.php' ),
			'etc'			=> array( 'tabs'	=>$p['abbonamenti.form']['etc']['tabs'] ),
			'auth'			=> array( 'groups'	=> array(	'roots' ) )
		);
	}