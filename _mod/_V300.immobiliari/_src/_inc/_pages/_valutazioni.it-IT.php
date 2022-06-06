<?php

	// lingua di questo file
	$l = 'it-IT';

	// modulo di questo file
	$m = DIR_MOD . '_V300.immobiliari/';
	$m_v = DIR_MOD . '_0800.valutazioni/';

	// RELAZIONI CON IL MODULO IMMOBILIARI
	if( in_array( "0800.valutazioni", $cf['mods']['active']['array'] ) ) {

		// gestione valutazioni
		$p['immobili.form.valutazioni'] = array(
			'sitemap'		=> false,
			'title'		=> array( $l		=> 'valutazioni' ),
			'h1'		=> array( $l		=> 'valutazioni' ),
			'parent'		=> array( 'id'		=> 'immobili.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'immobili.form.valutazioni.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_immobili.form.valutazioni.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> 'immobili.form' )
		);

		// vista immobili
		$p['valutazioni.immobiliari.view'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'valutazioni' ),
			'h1'			=> array( $l		=> 'valutazioni' ),
			'parent'		=> array( 'id'		=> 'immobiliari' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
			'macro'			=> array( $m . '_src/_inc/_macro/_valutazioni.immobiliari.view.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots' ) ),
			'etc'			=> array( 'tabs'	=>  array('valutazioni.immobiliari.view') ),
			'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'valutazioni' ),
									'priority'	=> '100' ) ) )	
		);


		// gestione valutazioni
		$p['valutazioni.immobiliari.form'] = array(
			'sitemap'		=> false,
			'title'		=> array( $l		=> 'gestione' ),
			'h1'		=> array( $l		=> 'gestione' ),
			'parent'		=> array( 'id'		=> 'valutazioni.immobiliari.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'valutazioni.immobiliari.form.html' ),
			'macro'		=> array(  $m . '_src/_inc/_macro/_valutazioni.immobiliari.form.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> array(
														'valutazioni.immobiliari.form',
														'valutazioni.immobiliari.form.immagini',
														'valutazioni.immobiliari.form.video',
														'valutazioni.immobiliari.form.file',
														'valutazioni.immobiliari.form.metadati',
														'valutazioni.immobiliari.form.stampe',
														'valutazioni.immobiliari.form.tools' ) )
		);



	// RELAZIONI CON IL MODULO CERTIFICAZIONI
	if( in_array( "6700.certificazioni", $cf['mods']['active']['array'] ) ) {
		arrayInsertSeq( 'valutazioni.immobiliari.form', $p['valutazioni.immobiliari.form']['etc']['tabs'], 'valutazioni.immobiliari.form.certificazioni' );
	}

		// form valutazioni immagini
		$p['valutazioni.immobiliari.form.immagini'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-picture-o" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'immagini' ),
			'h1'		=> array( $l		=> 'immagini' ),
			'parent'		=> array( 'id'		=> 'valutazioni.immobiliari.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'valutazioni.form.immagini.html' ),
			'macro'		=> array( $m_v . '_src/_inc/_macro/_valutazioni.form.immagini.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> $p['valutazioni.immobiliari.form']['etc']['tabs'] )
		);
		
		// form valutazioni file
		$p['valutazioni.immobiliari.form.file'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-folder-open-o" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'file' ),
			'h1'		=> array( $l		=> 'file' ),
			'parent'		=> array( 'id'		=> 'valutazioni.immobiliari.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'valutazioni.form.file.html' ),
			'macro'		=> array( $m_v . '_src/_inc/_macro/_valutazioni.form.file.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> $p['valutazioni.immobiliari.form']['etc']['tabs'] )
		);

		// form valutazioni video
		$p['valutazioni.immobiliari.form.video'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-video-camera" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'video' ),
			'h1'		=> array( $l		=> 'video' ),
			'parent'		=> array( 'id'		=> 'valutazioni.immobiliari.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'valutazioni.form.video.html' ),
			'macro'		=> array( $m_v . '_src/_inc/_macro/_valutazioni.form.video.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> $p['valutazioni.immobiliari.form']['etc']['tabs'] )
		);


		// form valutazioni metadati
		$p['valutazioni.immobiliari.form.metadati'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-code" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'metadati' ),
			'h1'		=> array( $l		=> 'metadati' ),
			'parent'		=> array( 'id'		=> 'valutazioni.immobiliari.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'valutazioni.form.metadati.html' ),
			'macro'		=> array( $m_v . '_src/_inc/_macro/_valutazioni.form.metadati.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> $p['valutazioni.immobiliari.form']['etc']['tabs'] )
		);

		// gestione anagrafica stampe
		$p['valutazioni.immobiliari.form.stampe'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-print" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'stampe' ),
			'h1'		=> array( $l		=> 'stampe' ),
			'parent'		=> array( 'id'		=> 'valutazioni.immobiliari.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
			'macro'		=> array( $m_v . '_src/_inc/_macro/_valutazioni.form.stampe.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> $p['valutazioni.immobiliari.form']['etc']['tabs'] )
		);
	
	}


