<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_4000.catalogo/';

    // dashboard del modulo
	$p['catalogo'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'catalogo' ),
	    'h1'		=> array( $l		=> 'catalogo' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'catalogo.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_catalogo.php' ),
	    'parent'		=> array( 'id'		=> NULL ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> array(	'catalogo' ) ),
	    'menu'		=> array( 'admin'	=> array(	'label'		=> array( $l => 'catalogo' ),
									'priority'	=> '650' ) )
	);

	 // vista categorie prodotti
	 $p['categorie.prodotti.view'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'categorie' ),
	    'h1'		=> array( $l		=> 'categorie' ),
	    'parent'		=> array( 'id'		=> 'catalogo' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_categorie.prodotti.view.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'categorie.prodotti.view') ),
	    'menu'		=> array( 'admin'	=> array(	'label'		=> array( $l => 'categorie' ),
									'priority'	=> '010' ) )
	);
	
    // gestione categorie prodotti
	$p['categorie.prodotti.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'categorie.prodotti.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.prodotti.form.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_categorie.prodotti.form.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'categorie.prodotti.form',
													'categorie.prodotti.form.caratteristiche',
												'categorie.prodotti.form.immagini',
												'categorie.prodotti.form.video',
												'categorie.prodotti.form.audio',
												'categorie.prodotti.form.file',
												'categorie.prodotti.form.metadati',
												'categorie.prodotti.form.gruppi'
												) )
	);

	// gestione categorie prodotti caratteristiche
	$p['categorie.prodotti.form.caratteristiche'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'caratteristiche' ),
		'h1'		=> array( $l		=> 'caratteristiche' ),
		'parent'		=> array( 'id'		=> 'categorie.prodotti.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.prodotti.form.caratteristiche.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_categorie.prodotti.form.caratteristiche.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> $p['categorie.prodotti.form']['etc']['tabs'] )
	);

	// gestione categorie immagini
	$p['categorie.prodotti.form.immagini'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-picture-o" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'immagini' ),
		'h1'		=> array( $l		=> 'immagini' ),
		'parent'		=> array( 'id'		=> 'categorie.prodotti.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.prodotti.form.immagini.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_categorie.prodotti.form.immagini.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['categorie.prodotti.form']['etc']['tabs'] )
	);

	// gestione categorie video
	$p['categorie.prodotti.form.video'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-video-camera" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'video' ),
		'h1'		=> array( $l		=> 'video' ),
		'parent'		=> array( 'id'		=> 'categorie.prodotti.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.prodotti.form.video.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_categorie.prodotti.form.video.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['categorie.prodotti.form']['etc']['tabs'] )
	);
	
	// gestione pagina file
	$p['categorie.prodotti.form.file'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-folder-open-o" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'file' ),
		'h1'		=> array( $l		=> 'file' ),
		'parent'		=> array( 'id'		=> 'categorie.prodotti.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.prodotti.form.file.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_categorie.prodotti.form.file.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['categorie.prodotti.form']['etc']['tabs'] )
	);

	// gestione categorie audio
	$p['categorie.prodotti.form.audio'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-volume-up" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'audio' ),
		'h1'		=> array( $l		=> 'audio' ),
		'parent'		=> array( 'id'		=> 'categorie.prodotti.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.prodotti.form.audio.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_categorie.prodotti.form.audio.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['categorie.prodotti.form']['etc']['tabs'] )
	);

	// gestione categorie metadati
	$p['categorie.prodotti.form.metadati'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-code" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'metadati' ),
		'h1'		=> array( $l		=> 'metadati' ),
		'parent'		=> array( 'id'		=> 'categorie.prodotti.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.prodotti.form.metadati.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_categorie.prodotti.form.metadati.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['categorie.prodotti.form']['etc']['tabs'] )
	);
	
	// gestione categorie gruppi
	$p['categorie.prodotti.form.gruppi'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-users" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'gruppi' ),
		'h1'		=> array( $l		=> 'gruppi' ),
		'parent'		=> array( 'id'		=> 'categorie.prodotti.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.prodotti.form.gruppi.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_categorie.prodotti.form.gruppi.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['categorie.prodotti.form']['etc']['tabs'] )
	);

    // debug
	// die( print_r( $p ) );
