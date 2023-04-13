<?php

	// lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_V300.immobiliari/';

    // vista indirizzi
	$p['indirizzi.immobiliari.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'indirizzi' ),
	    'h1'			=> array( $l		=> 'indirizzi' ),
	    'parent'		=> array( 'id'		=> 'immobiliari' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_indirizzi.immobiliari.view.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'			=> array( 'tabs'	=> array(	'indirizzi.view'
													) ),
		'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'indirizzi' ),
								'priority'	=> '030' ) ) )	
    );

	// form indirizzi
	$p['indirizzi.immobiliari.form'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'gestione' ),
	    'h1'			=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'indirizzi.immobiliari.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'indirizzi.form.html' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_indirizzi.immobiliari.form.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'			=> array( 'tabs'	=> array(	'indirizzi.immobiliari.form',
														'indirizzi.immobiliari.form.caratteristiche',
														'indirizzi.immobiliari.form.mappa',
														'indirizzi.immobiliari.form.edifici',
														'indirizzi.immobiliari.form.immagini',
														'indirizzi.immobiliari.form.video',
														'indirizzi.immobiliari.form.audio',
														'indirizzi.immobiliari.form.file',
														'indirizzi.immobiliari.form.metadati',
														'indirizzi.immobiliari.form.stampe'
													) )
	);
		
	// form immobili immagini
	$p['indirizzi.immobiliari.form.caratteristiche'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'caratteristiche' ),
		'h1'		=> array( $l		=> 'caratteristiche' ),
		'parent'		=> array( 'id'		=> 'indirizzi.immobiliari.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'indirizzi.immobiliari.form.caratteristiche.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_indirizzi.immobiliari.form.caratteristiche.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['indirizzi.immobiliari.form']['etc']['tabs'] )
	);

	// gestione mappa indirizzi
	$p['indirizzi.immobiliari.form.mappa'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'mappa' ),
		'h1'		=> array( $l		=> 'mappa' ),
		'parent'		=> array( 'id'		=> 'indirizzi.immobiliari.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'indirizzi.immobiliari.form.mappa.html' ),
		'macro'		=> array( $m. '_src/_inc/_macro/_indirizzi.immobiliari.form.mappa.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff'  ) ),
		'etc'		=> array( 'tabs'	=> $p['indirizzi.immobiliari.form']['etc']['tabs'] )
	);

	// gestione immobili edifici
	$p['indirizzi.immobiliari.form.edifici'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'edifci' ),
		'h1'		=> array( $l		=> 'edifci' ),
		'parent'		=> array( 'id'		=> 'indirizzi.immobiliari.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'indirizzi.immobiliari.form.edifici.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_indirizzi.immobiliari.form.edifici.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['indirizzi.immobiliari.form']['etc']['tabs'] )
	);

	// form edifici immagini
	$p['indirizzi.immobiliari.form.immagini'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-picture-o" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'immagini' ),
		'h1'		=> array( $l		=> 'immagini' ),
		'parent'		=> array( 'id'		=> 'indirizzi.immobiliari.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'indirizzi.immobiliari.form.immagini.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_indirizzi.immobiliari.form.immagini.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['indirizzi.immobiliari.form']['etc']['tabs'] )
	);

	// form edifici video
	$p['indirizzi.immobiliari.form.video'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-video-camera" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'video' ),
		'h1'		=> array( $l		=> 'video' ),
		'parent'		=> array( 'id'		=> 'indirizzi.immobiliari.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'indirizzi.immobiliari.form.video.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_indirizzi.immobiliari.form.video.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['indirizzi.immobiliari.form']['etc']['tabs'] )
	);
	
	// form edifici file
	$p['indirizzi.immobiliari.form.file'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-folder-open-o" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'file' ),
		'h1'		=> array( $l		=> 'file' ),
		'parent'		=> array( 'id'		=> 'indirizzi.immobiliari.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'indirizzi.immobiliari.form.file.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_indirizzi.immobiliari.form.file.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['indirizzi.immobiliari.form']['etc']['tabs'] )
	);

	// form edifici audio
	$p['indirizzi.immobiliari.form.audio'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-volume-up" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'audio' ),
		'h1'		=> array( $l		=> 'audio' ),
		'parent'		=> array( 'id'		=> 'indirizzi.immobiliari.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'indirizzi.immobiliari.form.audio.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_indirizzi.immobiliari.form.audio.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['indirizzi.immobiliari.form']['etc']['tabs'] )
	);

	// form edifici metadati
	$p['indirizzi.immobiliari.form.metadati'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-code" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'metadati' ),
		'h1'		=> array( $l		=> 'metadati' ),
		'parent'		=> array( 'id'		=> 'indirizzi.immobiliari.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'indirizzi.immobiliari.form.metadati.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_indirizzi.immobiliari.form.metadati.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['indirizzi.immobiliari.form']['etc']['tabs'] )
	);

	// gestione edifici stampe
	$p['indirizzi.immobiliari.form.stampe'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-print" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'stampe' ),
		'h1'		=> array( $l		=> 'stampe' ),
		'parent'		=> array( 'id'		=> 'indirizzi.immobiliari.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
		'macro'		=> array( $m.'_src/_inc/_macro/_indirizzi.immobiliari.form.stampe.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['indirizzi.immobiliari.form']['etc']['tabs'] )
	);
