<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_3500.risorse/';

	// vista risorse
	$p['risorse.view'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'risorse' ),
	    'h1'		=> array( $l		=> 'risorse' ),
	    'parent'		=> array( 'id'		=> 'contenuti' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_risorse.view.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'risorse.view' ) ),
		'menu'		=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'risorse' ),
									'priority'	=> '025' ) ) )				
	);

    // gestione risorse
	$p['risorse.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'risorse.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'risorse.form.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_risorse.form.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> array(	'risorse.form',
													'risorse.form.sem',
													'risorse.form.testo',
													'risorse.form.immagini',
													'risorse.form.video',
													'risorse.form.audio',
													'risorse.form.metadati' ) )
	);

	// gestione risorse SEM/SMM
	$p['risorse.form.sem'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'SEM/SMM' ),
	    'h1'		=> array( $l		=> 'SEM/SMM' ),
	    'parent'		=> array( 'id'		=> 'risorse.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'risorse.form.sem.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_risorse.form.sem.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['risorse.form']['etc']['tabs'] )
	);

	// gestione risorse testo
	$p['risorse.form.testo'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'testo' ),
	    'h1'		=> array( $l		=> 'testo' ),
	    'parent'		=> array( 'id'		=> 'risorse.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'risorse.form.testo.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_risorse.form.testo.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['risorse.form']['etc']['tabs'] )
	);

	// gestione risorse immagini
	$p['risorse.form.immagini'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-picture-o" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'immagini' ),
		'h1'		=> array( $l		=> 'immagini' ),
		'parent'		=> array( 'id'		=> 'risorse.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'risorse.form.immagini.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_risorse.form.immagini.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> $p['risorse.form']['etc']['tabs'] )
	);

	// gestione risorse video
	$p['risorse.form.video'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-video-camera" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'video' ),
		'h1'		=> array( $l		=> 'video' ),
		'parent'		=> array( 'id'		=> 'risorse.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'risorse.form.video.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_risorse.form.video.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' , 'staff') ),
		'etc'		=> array( 'tabs'	=> $p['risorse.form']['etc']['tabs'] )
	);

	// gestione risorse audio
	$p['risorse.form.audio'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-volume-up" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'audio' ),
		'h1'		=> array( $l		=> 'audio' ),
		'parent'		=> array( 'id'		=> 'risorse.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'risorse.form.audio.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_risorse.form.audio.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> $p['risorse.form']['etc']['tabs'] )
	);

	// gestione risorse metadati
	$p['risorse.form.metadati'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-code" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'metadati' ),
		'h1'		=> array( $l		=> 'metadati' ),
		'parent'		=> array( 'id'		=> 'risorse.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'risorse.form.metadati.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_risorse.form.metadati.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> $p['risorse.form']['etc']['tabs'] )
	);

	// vista risorse categorie
	$p['categorie.risorse.view'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'categorie' ),
		'h1'		=> array( $l		=> 'categorie' ),
		'parent'		=> array( 'id'		=> 'risorse.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_categorie.risorse.view.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> array(	'categorie.risorse.view' ) ),
		'menu'		=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'categorie' ),
									'priority'	=> '010' ) ) )				
	);

	// gestione risorse categorie
	$p['categorie.risorse.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'categorie.risorse.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.risorse.form.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_categorie.risorse.form.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> array(	'categorie.risorse.form',
													'categorie.risorse.form.sem',
													'categorie.risorse.form.testo',
													'categorie.risorse.form.menu',
													'categorie.risorse.form.risorse',
													'categorie.risorse.form.macro',
													'categorie.risorse.form.immagini',
													'categorie.risorse.form.video',
													'categorie.risorse.form.audio',
													'categorie.risorse.form.file',
													'categorie.risorse.form.metadati' ) )
	);

	// gestione categorie SEM/SMM
	$p['categorie.risorse.form.sem'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'SEM/SMM' ),
	    'h1'		=> array( $l		=> 'SEM/SMM' ),
	    'parent'		=> array( 'id'		=> 'categorie.risorse.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.risorse.form.sem.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_categorie.risorse.form.sem.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['categorie.risorse.form']['etc']['tabs'] )
	);

	// gestione categorie testo
	$p['categorie.risorse.form.testo'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'testo' ),
	    'h1'		=> array( $l		=> 'testo' ),
	    'parent'		=> array( 'id'		=> 'categorie.risorse.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.risorse.form.testo.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_categorie.risorse.form.testo.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['categorie.risorse.form']['etc']['tabs'] )
	);

	// gestione categorie menu
	$p['categorie.risorse.form.menu'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'menu' ),
		'h1'		=> array( $l		=> 'menu' ),
		'parent'		=> array( 'id'		=> 'categorie.risorse.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.risorse.form.menu.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_categorie.risorse.form.menu.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> $p['categorie.risorse.form']['etc']['tabs'] )
	);

	// gestione categorie risorse
	$p['categorie.risorse.form.risorse'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'risorse' ),
	    'h1'		=> array( $l		=> 'risorse' ),
	    'parent'		=> array( 'id'		=> 'categorie.risorse.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.risorse.form.risorse.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_categorie.risorse.form.risorse.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['categorie.risorse.form']['etc']['tabs'] )
	);

	// gestione categorie macro
	$p['categorie.risorse.form.macro'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-caret-square-o-right" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'macro' ),
	    'h1'		=> array( $l		=> 'macro' ),
	    'parent'		=> array( 'id'		=> 'categorie.risorse.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.risorse.form.macro.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_categorie.risorse.form.macro.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['categorie.risorse.form']['etc']['tabs'] )
	);

	// gestione categorie immagini
	$p['categorie.risorse.form.immagini'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-picture-o" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'immagini' ),
		'h1'		=> array( $l		=> 'immagini' ),
		'parent'		=> array( 'id'		=> 'categorie.risorse.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.risorse.form.immagini.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_categorie.risorse.form.immagini.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff'  ) ),
		'etc'		=> array( 'tabs'	=> $p['categorie.risorse.form']['etc']['tabs'] )
	);

	// gestione categorie video
	$p['categorie.risorse.form.video'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-video-camera" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'video' ),
		'h1'		=> array( $l		=> 'video' ),
		'parent'		=> array( 'id'		=> 'categorie.risorse.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.risorse.form.video.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_categorie.risorse.form.video.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff'  ) ),
		'etc'		=> array( 'tabs'	=> $p['categorie.risorse.form']['etc']['tabs'] )
	);
	
	// gestione categorie file
	$p['categorie.risorse.form.file'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-folder-open-o" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'file' ),
		'h1'		=> array( $l		=> 'file' ),
		'parent'		=> array( 'id'		=> 'categorie.risorse.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.risorse.form.file.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_categorie.risorse.form.file.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> $p['categorie.risorse.form']['etc']['tabs'] )
	);

	// gestione categorie audio
	$p['categorie.risorse.form.audio'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-volume-up" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'audio' ),
		'h1'		=> array( $l		=> 'audio' ),
		'parent'		=> array( 'id'		=> 'categorie.risorse.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.risorse.form.audio.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_categorie.risorse.form.audio.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> $p['categorie.risorse.form']['etc']['tabs'] )
	);

	// gestione categorie metadati
	$p['categorie.risorse.form.metadati'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-code" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'metadati' ),
		'h1'		=> array( $l		=> 'metadati' ),
		'parent'		=> array( 'id'		=> 'categorie.risorse.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.risorse.form.metadati.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_categorie.risorse.form.metadati.php' ),
		'auth'		=> array( 'groups'	=> array('roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> $p['categorie.risorse.form']['etc']['tabs'] )
	);