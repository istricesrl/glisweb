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
	    'etc'		=> array( 'tabs'	=> array(	'prodotti.view') ),
	    'menu'		=> array( 'admin'	=> array(	'label'		=> array( $l => 'prodotti' ),
									'priority'	=> '015' ) )
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
													'prodotti.form.sem',
													'prodotti.form.testo',
													'prodotti.form.articoli',
													'prodotti.form.prezzi',
													'prodotti.form.immagini',
													'prodotti.form.video',
													'prodotti.form.audio',
													'prodotti.form.file',
													'prodotti.form.metadati'
												) )
	);

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
		'title'		=> array( $l		=> 'caratteristiche' ),
		'h1'		=> array( $l		=> 'caratteristiche' ),
		'parent'		=> array( 'id'		=> 'prodotti.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'prodotti.form.caratteristiche.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_prodotti.form.caratteristiche.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> $p['prodotti.form']['etc']['tabs'] )
	);

	// gestione prodotti SEM/SMM
	$p['prodotti.form.sem'] = array(
	    'sitemap'		=> false,
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
	    'title'		=> array( $l		=> 'articoli' ),
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
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
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
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
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
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
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
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['prodotti.form']['etc']['tabs'] )
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
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['prodotti.form']['etc']['tabs'] )
	);
	
	// vista articoli
	$p['articoli.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'articoli' ),
	    'h1'			=> array( $l		=> 'articoli' ),
	    'parent'		=> array( 'id'		=> 'catalogo' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_articoli.view.php' ),
		'etc'			=> array( 'tabs'	=> array( 'articoli.view' ) ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'menu'			=> array( 'admin'	=> array(	'label'		=> array( $l => 'articoli' ),
								'priority'	=> '020' ) )
	);

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
     //                                               'articoli.form.pubblicazione',
													'articoli.form.caratteristiche',
													'articoli.form.sem',
													'articoli.form.testo',
													'articoli.form.prezzi',
													'articoli.form.immagini',
													'articoli.form.video',
													'articoli.form.audio',
													'articoli.form.file',
													'articoli.form.metadati'
												) )
	);
/*
	// gestione articoli pubblicazione
	$p['articoli.form.pubblicazione'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'pubblicazione' ),
		'h1'		=> array( $l		=> 'pubblicazione' ),
		'parent'		=> array( 'id'		=> 'articoli.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'articoli.form.pubblicazione.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_articoli.form.pubblicazione.php' ),
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
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
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
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
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
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
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
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['articoli.form']['etc']['tabs'] )
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
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['articoli.form']['etc']['tabs'] )
	);
	
	// vista listini
	$p['listini.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'listini' ),
	    'h1'			=> array( $l		=> 'listini' ),
	    'parent'		=> array( 'id'		=> 'catalogo' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_listini.view.php' ),
		'etc'			=> array( 'tabs'	=> array( 'listini.view' ) ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'menu'			=> array( 'admin'	=> array(	'label'		=> array( $l => 'listini' ),
								'priority'	=> '025' ) )
	);

	// gestione listini
	$p['listini.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'listini.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'listini.form.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_listini.form.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'listini.form'	, 'listini.form.gruppi'	) )
	);

	// gestione listini gruppi
	$p['listini.form.gruppi'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-users" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'gruppi' ),
		'h1'		=> array( $l		=> 'gruppi' ),
		'parent'		=> array( 'id'		=> 'listini.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'listini.form.gruppi.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_listini.form.gruppi.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['listini.form']['etc']['tabs'] )
	);
    
	// vista reparti
	$p['reparti.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'reparti' ),
	    'h1'			=> array( $l		=> 'reparti' ),
	    'parent'		=> array( 'id'		=> 'catalogo' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_reparti.view.php' ),
		'etc'			=> array( 'tabs'	=> array( 'reparti.view' ) ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'menu'			=> array( 'admin'	=> array(	'label'		=> array( $l => 'reparti' ),
								'priority'	=> '025' ) )
	);

	// gestione reparti
	$p['reparti.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'reparti.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'reparti.form.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_reparti.form.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'reparti.form' ) )
	);