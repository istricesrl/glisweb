<?php

	// lingua di questo file
	$l = 'it-IT';

	// modulo di questo file
	$m = DIR_MOD . '_V300.immobiliari/';
	$m_c = DIR_MOD . '_0600.contratti/';

	// RELAZIONI CON IL MODULO IMMOBILIARI
	if( in_array( "0600.contratti", $cf['mods']['active']['array'] ) ) {

		// vista immobili
		$p['contratti.immobiliari.view'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'contratti' ),
			'h1'			=> array( $l		=> 'contratti' ),
			'parent'		=> array( 'id'		=> 'immobiliari' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
			'macro'			=> array( $m . '_src/_inc/_macro/_contratti.immobiliari.view.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots' ) ),
			'etc'			=> array( 'tabs'	=>  array('contratti.immobiliari.view') ),
			'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'contratti' ),
									'priority'	=> '120' ) ) )	
		);


		// gestione contratti
		$p['contratti.immobiliari.form'] = array(
			'sitemap'		=> false,
			'title'		=> array( $l		=> 'gestione' ),
			'h1'		=> array( $l		=> 'gestione' ),
			'parent'		=> array( 'id'		=> 'contratti.immobiliari.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'contratti.form.html' ),
			'macro'		=> array(  $m_c . '_src/_inc/_macro/_contratti.form.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> array(
														'contratti.immobiliari.form',
														'contratti.immobiliari.form.rinnovi',
														'contratti.immobiliari.form.immagini',
														'contratti.immobiliari.form.file',
														'contratti.immobiliari.form.metadati',
														'contratti.immobiliari.form.stampe',
														'contratti.immobiliari.form.tools' ) )
		);


		// form contratti immagini
		$p['contratti.immobiliari.form.immagini'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-picture-o" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'immagini' ),
			'h1'		=> array( $l		=> 'immagini' ),
			'parent'		=> array( 'id'		=> 'contratti.immobiliari.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'contratti.form.immagini.html' ),
			'macro'		=> array( $m_c . '_src/_inc/_macro/_contratti.form.immagini.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> $p['contratti.immobiliari.form']['etc']['tabs'] )
		);
		
		// form contratti file
		$p['contratti.immobiliari.form.file'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-folder-open-o" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'file' ),
			'h1'		=> array( $l		=> 'file' ),
			'parent'		=> array( 'id'		=> 'contratti.immobiliari.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'contratti.form.file.html' ),
			'macro'		=> array( $m_c . '_src/_inc/_macro/_contratti.form.file.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> $p['contratti.immobiliari.form']['etc']['tabs'] )
		);


		// form contratti metadati
		$p['contratti.immobiliari.form.metadati'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-code" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'metadati' ),
			'h1'		=> array( $l		=> 'metadati' ),
			'parent'		=> array( 'id'		=> 'contratti.immobiliari.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'contratti.form.metadati.html' ),
			'macro'		=> array( $m_c . '_src/_inc/_macro/_contratti.form.metadati.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> $p['contratti.immobiliari.form']['etc']['tabs'] )
		);

		// gestione anagrafica stampe
		$p['contratti.immobiliari.form.stampe'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-print" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'stampe' ),
			'h1'		=> array( $l		=> 'stampe' ),
			'parent'		=> array( 'id'		=> 'contratti.immobiliari.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
			'macro'		=> array( $m_c . '_src/_inc/_macro/_contratti.form.stampe.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> $p['contratti.immobiliari.form']['etc']['tabs'] )
		);
	
		// rinnovi contratti
		$p['contratti.immobiliari.form.rinnovi'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'rinnovi' ),
			'h1'			=> array( $l		=> 'rinnovi' ),
			'parent'		=> array( 'id'		=> 'contratti.immobiliari.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'contratti.form.rinnovi.html' ),
			'macro'			=> array(  $m_c . '_src/_inc/_macro/_contratti.form.rinnovi.php' ),
			'etc'			=> array( 'tabs'	=>$p['contratti.immobiliari.form']['etc']['tabs'] ),
			'auth'			=> array( 'groups'	=> array(	'roots' ) )
		);
	}


