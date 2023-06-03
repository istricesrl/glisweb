<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_4100.prodotti/';

	// vista articoli
	$p['articoli.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'articoli' ),
	    'h1'			=> array( $l		=> 'articoli' ),
	    'parent'		=> array( 'id'		=> 'prodotti.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_articoli.view.php' ),
#		'etc'			=> array( 'tabs'	=> array( 'articoli.view' , 'articoli.stampe' ) ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'prodotti.view' )
#		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'articoli' ),
#									'priority'	=> '020' ) ) )
	);
/*
	// gestione articoli stampe
	$p['articoli.stampe'] = array(
	    'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-print" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'stampe_articoli' ),
	    'h1'				=> array( $l		=> 'stampe' ),
	    'parent'			=> array( 'id'		=> 'articoli.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_articoli.stampe.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['articoli.view']['etc']['tabs'] )
	);
*/
	// gestione articoli
	$p['articoli.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'articoli.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'articoli.form.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_articoli.form.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'articoli.form',
     //                                               'articoli.form.pubblicazioni',
													'articoli.form.caratteristiche',
#													'articoli.form.sem',
#													'articoli.form.testo',
													'articoli.form.prezzi',
													'articoli.form.immagini',
													'articoli.form.video',
													'articoli.form.audio',
													'articoli.form.file',
													'articoli.form.stampe',
													'articoli.form.metadati',
													'articoli.form.tools'
												) )
	);

	// RELAZIONI CON IL MODULO CONTENUTI
	if( in_array( "3000.contenuti", $cf['mods']['active']['array'] ) ) {
		arrayInsertSeq( 'articoli.form', $p['articoli.form']['etc']['tabs'], 'articoli.form.sem' );
		arrayInsertSeq( 'articoli.form.sem', $p['articoli.form']['etc']['tabs'], 'articoli.form.testo' );
	}

/*
	// gestione articoli pubblicazioni
	$p['articoli.form.pubblicazioni'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'pubblicazioni' ),
		'h1'		=> array( $l		=> 'pubblicazioni' ),
		'parent'		=> array( 'id'		=> 'articoli.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'articoli.form.pubblicazioni.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_articoli.form.pubblicazioni.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> $p['articoli.form']['etc']['tabs'] )
	);
*/
	// gestione articoli caratteristiche
	$p['articoli.form.caratteristiche'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'caratteristiche' ),
		'h1'		=> array( $l		=> 'caratteristiche' ),
		'parent'		=> array( 'id'		=> 'articoli.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'articoli.form.caratteristiche.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_articoli.form.caratteristiche.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> $p['articoli.form']['etc']['tabs'] )
	);

	// gestione articoli SEM/SMM
	$p['articoli.form.sem'] = array(
	    'sitemap'		=> false,
		'icon'			=> '<i class="fa fa-google" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'SEM/SMM' ),
	    'h1'		=> array( $l		=> 'SEM/SMM' ),
	    'parent'		=> array( 'id'		=> 'articoli.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'articoli.form.sem.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_articoli.form.sem.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['articoli.form']['etc']['tabs'] )
	);

	// gestione articoli testo
	$p['articoli.form.testo'] = array(
	    'sitemap'		=> false,
		'icon'			=> '<i class="fa fa-file-text-o" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'testo' ),
	    'h1'		=> array( $l		=> 'testo' ),
	    'parent'		=> array( 'id'		=> 'articoli.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'articoli.form.testo.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_articoli.form.testo.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['articoli.form']['etc']['tabs'] )
	);

	// gestione articoli prezzi
	$p['articoli.form.prezzi'] = array(
	    'sitemap'		=> false,
		'icon'			=> '<i class="fa fa-eur" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'prezzi' ),
	    'h1'		=> array( $l		=> 'prezzi' ),
	    'parent'		=> array( 'id'		=> 'articoli.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'articoli.form.prezzi.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_articoli.form.prezzi.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['articoli.form']['etc']['tabs'] )
	);


	// gestione articoli immagini
	$p['articoli.form.immagini'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-picture-o" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'immagini' ),
		'h1'		=> array( $l		=> 'immagini' ),
		'parent'		=> array( 'id'		=> 'articoli.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'articoli.form.immagini.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_articoli.form.immagini.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> $p['articoli.form']['etc']['tabs'] )
	);

	// gestione articoli video
	$p['articoli.form.video'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-video-camera" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'video' ),
		'h1'		=> array( $l		=> 'video' ),
		'parent'		=> array( 'id'		=> 'articoli.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'articoli.form.video.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_articoli.form.video.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' , 'staff') ),
		'etc'		=> array( 'tabs'	=> $p['articoli.form']['etc']['tabs'] )
	);
	
	// gestione articoli file
	$p['articoli.form.file'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-folder-open-o" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'file' ),
		'h1'		=> array( $l		=> 'file' ),
		'parent'		=> array( 'id'		=> 'articoli.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'articoli.form.file.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_articoli.form.file.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' , 'staff') ),
		'etc'		=> array( 'tabs'	=> $p['articoli.form']['etc']['tabs'] )
	);

	// gestione articoli audio
	$p['articoli.form.audio'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-volume-up" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'audio' ),
		'h1'		=> array( $l		=> 'audio' ),
		'parent'		=> array( 'id'		=> 'articoli.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'articoli.form.audio.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_articoli.form.audio.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> $p['articoli.form']['etc']['tabs'] )
	);

	// gestione articoli stampe
	$p['articoli.form.stampe'] = array(
	    'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-print" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'stampe' ),
	    'h1'				=> array( $l		=> 'stampe' ),
	    'parent'			=> array( 'id'		=> 'articoli.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_articoli.form.stampe.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['articoli.form']['etc']['tabs'] )
	);


	// gestione articoli metadati
	$p['articoli.form.metadati'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-code" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'metadati' ),
		'h1'		=> array( $l		=> 'metadati' ),
		'parent'		=> array( 'id'		=> 'articoli.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'articoli.form.metadati.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_articoli.form.metadati.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> $p['articoli.form']['etc']['tabs'] )
	);

	// form azioni articoli
	$p['articoli.form.tools'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'azioni pagina' ),
	    'h1'		=> array( $l		=> 'azioni pagina' ),
	    'parent'		=> array( 'id'		=> 'articoli.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_articoli.form.tools.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['articoli.form']['etc']['tabs'] )
	);
