<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_4100.prodotti/';

	// vista prodotti
	$p['prodotti.view'] = array(
		'sitemap'		=> false,
	    'title'		=> array( $l		=> 'prodotti' ),
	    'h1'		=> array( $l		=> 'prodotti' ),
	    'parent'		=> array( 'id'		=> 'catalogo' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_prodotti.view.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'prodotti.view', 'articoli.view', 'prodotti.stampe') ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'prodotti' ),
									'priority'	=> '015' ) ) )	
	);

	// gestione anagrafica stampe
	$p['prodotti.stampe'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-print" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'stampe' ),
	    'h1'		=> array( $l		=> 'stampe' ),
	    'parent'		=> array( 'id'		=> 'prodotti.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_prodotti.stampe.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['prodotti.view']['etc']['tabs'] )
	);

    // gestione prodotti
	$p['prodotti.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'prodotti.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'prodotti.form.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_prodotti.form.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'prodotti.form',
                                                    'prodotti.form.categorie',
													'prodotti.form.caratteristiche',
#													'prodotti.form.sem',
#													'prodotti.form.testo',
													'prodotti.form.articoli',
													'prodotti.form.prezzi',
													'prodotti.form.immagini',
													'prodotti.form.video',
													'prodotti.form.audio',
													'prodotti.form.file',
													'prodotti.form.stampe',
													'prodotti.form.metadati'
												) )
	);

	// RELAZIONI CON IL MODULO CONTENUTI
	if( in_array( "3000.contenuti", $cf['mods']['active']['array'] ) ) {
		arrayInsertSeq( 'prodotti.form', $p['prodotti.form']['etc']['tabs'], 'prodotti.form.web' );
		arrayInsertSeq( 'prodotti.form.web', $p['prodotti.form']['etc']['tabs'], 'prodotti.form.sem' );
		arrayInsertSeq( 'prodotti.form.sem', $p['prodotti.form']['etc']['tabs'], 'prodotti.form.testo' );
	}

	// gestione prodotti categorie
	$p['prodotti.form.categorie'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'categorie' ),
		'h1'		=> array( $l		=> 'categorie' ),
		'parent'		=> array( 'id'		=> 'prodotti.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'prodotti.form.categorie.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_prodotti.form.categorie.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> $p['prodotti.form']['etc']['tabs'] )
	);

	// gestione prodotti caratteristiche
	$p['prodotti.form.caratteristiche'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'caratteristiche prodotto' ),
		'h1'		=> array( $l		=> 'caratteristiche' ),
		'parent'		=> array( 'id'		=> 'prodotti.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'prodotti.form.caratteristiche.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_prodotti.form.caratteristiche.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> $p['prodotti.form']['etc']['tabs'] )
	);

	// gestione prodotti SEM/SMM
	$p['prodotti.form.web'] = array(
	    'sitemap'		=> false,
		'icon'			=> '<i class="fa fa-chrome" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'web' ),
	    'h1'		=> array( $l		=> 'web' ),
	    'parent'		=> array( 'id'		=> 'prodotti.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'prodotti.form.web.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_prodotti.form.web.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['prodotti.form']['etc']['tabs'] )
	);

	// gestione prodotti SEM/SMM
	$p['prodotti.form.sem'] = array(
	    'sitemap'		=> false,
		'icon'			=> '<i class="fa fa-google" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'SEM/SMM' ),
	    'h1'		=> array( $l		=> 'SEM/SMM' ),
	    'parent'		=> array( 'id'		=> 'prodotti.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'prodotti.form.sem.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_prodotti.form.sem.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['prodotti.form']['etc']['tabs'] )
	);

	// gestione prodotti testo
	$p['prodotti.form.testo'] = array(
	    'sitemap'		=> false,
		'icon'			=> '<i class="fa fa-file-text-o" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'testo' ),
	    'h1'		=> array( $l		=> 'testo' ),
	    'parent'		=> array( 'id'		=> 'prodotti.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'prodotti.form.testo.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_prodotti.form.testo.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['prodotti.form']['etc']['tabs'] )
	);

	// gestione prodotti articoli
	$p['prodotti.form.articoli'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'articoli prodotto' ),
	    'h1'		=> array( $l		=> 'articoli' ),
	    'parent'		=> array( 'id'		=> 'prodotti.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'prodotti.form.articoli.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_prodotti.form.articoli.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['prodotti.form']['etc']['tabs'] )
	);

	// gestione prodotti prezzi
	$p['prodotti.form.prezzi'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-eur" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'prezzi' ),
	    'h1'		=> array( $l		=> 'prezzi' ),
	    'parent'		=> array( 'id'		=> 'prodotti.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'prodotti.form.prezzi.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_prodotti.form.prezzi.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['prodotti.form']['etc']['tabs'] )
	);


	// gestione prodotti immagini
	$p['prodotti.form.immagini'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-picture-o" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'immagini' ),
		'h1'		=> array( $l		=> 'immagini' ),
		'parent'		=> array( 'id'		=> 'prodotti.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'prodotti.form.immagini.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_prodotti.form.immagini.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff') ),
		'etc'		=> array( 'tabs'	=> $p['prodotti.form']['etc']['tabs'] )
	);

	// gestione prodotti video
	$p['prodotti.form.video'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-video-camera" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'video' ),
		'h1'		=> array( $l		=> 'video' ),
		'parent'		=> array( 'id'		=> 'prodotti.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'prodotti.form.video.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_prodotti.form.video.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> $p['prodotti.form']['etc']['tabs'] )
	);
	
	// gestione prodotti file
	$p['prodotti.form.file'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-folder-open-o" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'file' ),
		'h1'		=> array( $l		=> 'file' ),
		'parent'		=> array( 'id'		=> 'prodotti.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'prodotti.form.file.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_prodotti.form.file.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> $p['prodotti.form']['etc']['tabs'] )
	);

	// gestione prodotti audio
	$p['prodotti.form.audio'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-volume-up" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'audio' ),
		'h1'		=> array( $l		=> 'audio' ),
		'parent'		=> array( 'id'		=> 'prodotti.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'prodotti.form.audio.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_prodotti.form.audio.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> $p['prodotti.form']['etc']['tabs'] )
	);

	// gestione anagrafica stampe
	$p['prodotti.form.stampe'] = array(
	    'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-print" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'stampe prodotto' ),
	    'h1'				=> array( $l		=> 'stampe' ),
	    'parent'			=> array( 'id'		=> 'prodotti.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_prodotti.form.stampe.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['prodotti.form']['etc']['tabs'] )
	);

	// gestione prodotti metadati
	$p['prodotti.form.metadati'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-code" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'metadati' ),
		'h1'		=> array( $l		=> 'metadati' ),
		'parent'		=> array( 'id'		=> 'prodotti.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'prodotti.form.metadati.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_prodotti.form.metadati.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> $p['prodotti.form']['etc']['tabs'] )
	);
	
	 // vista caratteristiche prodotti
	 $p['caratteristiche.prodotti.view'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'caratteristiche' ),
	    'h1'		=> array( $l		=> 'caratteristiche' ),
	    'parent'		=> array( 'id'		=> 'prodotti.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_caratteristiche.prodotti.view.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'caratteristiche.prodotti.view') ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'caratteristiche' ),
									'priority'	=> '100' ) ) )	
	);

	 // gestione catecaratteristichegorie prodotti
	 $p['caratteristiche.prodotti.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'caratteristiche.prodotti.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'caratteristiche.prodotti.form.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_caratteristiche.prodotti.form.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'caratteristiche.prodotti.form' ) )
	 );
