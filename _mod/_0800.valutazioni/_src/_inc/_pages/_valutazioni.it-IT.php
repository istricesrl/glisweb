<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0800.valutazioni/';

	// vista valutazioni
	$p['valutazioni.view'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'valutazioni' ),
	    'h1'		=> array( $l		=> 'valutazioni' ),
	    'parent'		=> array( 'id'		=> 'archivio' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'		=> array(  $m . '_src/_inc/_macro/_valutazioni.view.php' ),
	    'etc'		=> array( 'tabs'	=> array(	'valutazioni.view') ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'valutazioni' ),
									'priority'	=> '200' ) ) )						
	);

    // gestione valutazioni
	$p['valutazioni.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'valutazioni.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'valutazioni.form.html' ),
	    'macro'		=> array(  $m . '_src/_inc/_macro/_valutazioni.form.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> array(
													'valutazioni.form',
													'valutazioni.form.immagini',
													'valutazioni.form.video',
													'valutazioni.form.file',
													'valutazioni.form.metadati',
													'valutazioni.form.stampe' ) )
	);

	// form valutazioni immagini
	$p['valutazioni.form.immagini'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-picture-o" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'immagini' ),
		'h1'		=> array( $l		=> 'immagini' ),
		'parent'		=> array( 'id'		=> 'valutazioni.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'valutazioni.form.immagini.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_valutazioni.form.immagini.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['valutazioni.form']['etc']['tabs'] )
	);
	
	// form valutazioni file
	$p['valutazioni.form.file'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-folder-open-o" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'file' ),
		'h1'		=> array( $l		=> 'file' ),
		'parent'		=> array( 'id'		=> 'valutazioni.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'valutazioni.form.file.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_valutazioni.form.file.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['valutazioni.form']['etc']['tabs'] )
	);

	// form valutazioni video
	$p['valutazioni.form.video'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-video-camera" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'video' ),
		'h1'		=> array( $l		=> 'video' ),
		'parent'		=> array( 'id'		=> 'valutazioni.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'valutazioni.form.video.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_valutazioni.form.video.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['valutazioni.form']['etc']['tabs'] )
	);


	// form valutazioni metadati
	$p['valutazioni.form.metadati'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-code" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'metadati' ),
		'h1'		=> array( $l		=> 'metadati' ),
		'parent'		=> array( 'id'		=> 'valutazioni.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'valutazioni.form.metadati.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_valutazioni.form.metadati.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['valutazioni.form']['etc']['tabs'] )
	);

	// gestione anagrafica stampe
	$p['valutazioni.form.stampe'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-print" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'stampe' ),
	    'h1'		=> array( $l		=> 'stampe' ),
	    'parent'		=> array( 'id'		=> 'valutazioni.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_valutazioni.form.stampe.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['valutazioni.form']['etc']['tabs'] )
	);
	