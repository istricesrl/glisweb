<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_3100.annunci/';

    // vista annunci
	$p['annunci.view'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'annunci' ),
	    'h1'		=> array( $l		=> 'annunci' ),
	    'parent'		=> array( 'id'		=> 'contenuti' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_annunci.view.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'annunci.view' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'annunci' ),
									'priority'	=> '090' ) ) )	
    );


    // form annunci
	$p['annunci.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'annunci.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'annunci.form.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_annunci.form.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'annunci.form',
													'annunci.form.web',
													'annunci.form.sem',
													'annunci.form.testo',
													'annunci.form.immagini',
													'annunci.form.video',
													'annunci.form.audio',
													'annunci.form.file',
													'annunci.form.metadati',
													'annunci.form.tools'
												) )
	);

	// gestione annunci SEM/SMM
	$p['annunci.form.web'] = array(
	    'sitemap'		=> false,
		'icon'			=> '<i class="fa fa-chrome" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'web' ),
	    'h1'		=> array( $l		=> 'web' ),
	    'parent'		=> array( 'id'		=> 'annunci.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'annunci.form.web.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_annunci.form.web.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['annunci.form']['etc']['tabs'] )
	);

	// form annunci SEM/SMM
	$p['annunci.form.sem'] = array(
	    'sitemap'		=> false,
		'icon'			=> '<i class="fa fa-google" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'SEM/SMM' ),
	    'h1'		=> array( $l		=> 'SEM/SMM' ),
	    'parent'		=> array( 'id'		=> 'annunci.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'annunci.form.sem.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_annunci.form.sem.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['annunci.form']['etc']['tabs'] )
	);

	// form annunci testo
	$p['annunci.form.testo'] = array(
	    'sitemap'		=> false,
		'icon'			=> '<i class="fa fa-file-text-o" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'testo' ),
	    'h1'		=> array( $l		=> 'testo' ),
	    'parent'		=> array( 'id'		=> 'annunci.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'annunci.form.testo.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_annunci.form.testo.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['annunci.form']['etc']['tabs'] )
	);

	$p['annunci.form.contenuti'] = array(
	    'sitemap'		=> false,
		'icon'			=> '<i class="fa fa-file-text-o" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'testo' ),
	    'h1'		=> array( $l		=> 'testo' ),
	    'parent'		=> array( 'id'		=> 'annunci.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'annunci.form.contenuti.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_annunci.form.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> $p['annunci.form']['etc']['tabs'] )
	);

	$p['annunci.form.immagini'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-picture-o" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'immagini' ),
		'h1'		=> array( $l		=> 'immagini' ),
		'parent'		=> array( 'id'		=> 'annunci.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'annunci.form.immagini.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_annunci.form.immagini.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['annunci.form']['etc']['tabs'] )
	);

	// form annunci video
	$p['annunci.form.video'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-video-camera" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'video' ),
		'h1'		=> array( $l		=> 'video' ),
		'parent'		=> array( 'id'		=> 'annunci.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'annunci.form.video.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_annunci.form.video.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['annunci.form']['etc']['tabs'] )
	);
	
	// form annunci file
	$p['annunci.form.file'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-folder-open-o" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'file' ),
		'h1'		=> array( $l		=> 'file' ),
		'parent'		=> array( 'id'		=> 'annunci.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'annunci.form.file.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_annunci.form.file.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['annunci.form']['etc']['tabs'] )
	);

	// form annunci audio
	$p['annunci.form.audio'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-volume-up" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'audio' ),
		'h1'		=> array( $l		=> 'audio' ),
		'parent'		=> array( 'id'		=> 'annunci.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'annunci.form.audio.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_annunci.form.audio.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['annunci.form']['etc']['tabs'] )
	);

	// form annunci metadati
	$p['annunci.form.metadati'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-code" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'metadati' ),
		'h1'		=> array( $l		=> 'metadati' ),
		'parent'		=> array( 'id'		=> 'annunci.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'annunci.form.metadati.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_annunci.form.metadati.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['annunci.form']['etc']['tabs'] )
	);
	
	// form azioni annunci
	$p['annunci.form.tools'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'azioni annuncio' ),
	    'h1'		=> array( $l		=> 'azioni annuncio' ),
	    'parent'		=> array( 'id'		=> 'annunci.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_annunci.form.tools.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['annunci.form']['etc']['tabs'] )
	);

	 // vista categorie annunci
	 $p['categorie.annunci.view'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'categorie' ),
	    'h1'		=> array( $l		=> 'categorie' ),
	    'parent'		=> array( 'id'		=> 'annunci.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_categorie.annunci.view.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'categorie.annunci.view') ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'categorie' ),
									'priority'	=> '007' ) ) )	
	);
	
    // gestione categorie annunci
	$p['categorie.annunci.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'categorie.annunci.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.annunci.form.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_categorie.annunci.form.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'categorie.annunci.form',
													'categorie.annunci.form.web',
													'categorie.annunci.form.sem',
													'categorie.annunci.form.testo',
													'categorie.annunci.form.menu',
													'categorie.annunci.form.immagini',
													'categorie.annunci.form.video',
													'categorie.annunci.form.audio',
													'categorie.annunci.form.file',
													'categorie.annunci.form.metadati'
												) )
	);

	// gestione categorie SEM/SMM
	$p['categorie.annunci.form.web'] = array(
	    'sitemap'		=> false,
		'icon'			=> '<i class="fa fa-chrome" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'web' ),
	    'h1'		=> array( $l		=> 'web' ),
	    'parent'		=> array( 'id'		=> 'categorie.annunci.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.annunci.form.web.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_categorie.annunci.form.web.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['categorie.annunci.form']['etc']['tabs'] )
	);

	// form annunci SEM/SMM
	$p['categorie.annunci.form.sem'] = array(
	    'sitemap'		=> false,
		'icon'			=> '<i class="fa fa-google" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'SEM/SMM' ),
	    'h1'		=> array( $l		=> 'SEM/SMM' ),
	    'parent'		=> array( 'id'		=> 'categorie.annunci.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.annunci.form.sem.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_categorie.annunci.form.sem.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['categorie.annunci.form']['etc']['tabs'] )
	);

	// form annunci testo
	$p['categorie.annunci.form.testo'] = array(
	    'sitemap'		=> false,
		'icon'			=> '<i class="fa fa-file-text-o" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'testo' ),
	    'h1'		=> array( $l		=> 'testo' ),
	    'parent'		=> array( 'id'		=> 'categorie.annunci.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.annunci.form.testo.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_categorie.annunci.form.testo.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['categorie.annunci.form']['etc']['tabs'] )
	);

	// form categorie annunci menu
	$p['categorie.annunci.form.menu'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-bars" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'menu' ),
	    'h1'		=> array( $l		=> 'menu' ),
	    'parent'		=> array( 'id'		=> 'categorie.annunci.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.annunci.form.menu.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_categorie.annunci.form.menu.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['categorie.annunci.form']['etc']['tabs'] )
	);

	// form categorie annunci immagini
	$p['categorie.annunci.form.immagini'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-picture-o" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'immagini' ),
		'h1'		=> array( $l		=> 'immagini' ),
		'parent'		=> array( 'id'		=> 'categorie.annunci.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.annunci.form.immagini.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_categorie.annunci.form.immagini.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['categorie.annunci.form']['etc']['tabs'] )
	);

	// form annunci video
	$p['categorie.annunci.form.video'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-video-camera" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'video' ),
		'h1'		=> array( $l		=> 'video' ),
		'parent'		=> array( 'id'		=> 'categorie.annunci.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.annunci.form.video.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_categorie.annunci.form.video.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['categorie.annunci.form']['etc']['tabs'] )
	);
	
	// form annunci file
	$p['categorie.annunci.form.file'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-folder-open-o" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'file' ),
		'h1'		=> array( $l		=> 'file' ),
		'parent'		=> array( 'id'		=> 'categorie.annunci.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.annunci.form.file.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_categorie.annunci.form.file.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['categorie.annunci.form']['etc']['tabs'] )
	);

	// form annunci audio
	$p['categorie.annunci.form.audio'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-volume-up" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'audio' ),
		'h1'		=> array( $l		=> 'audio' ),
		'parent'		=> array( 'id'		=> 'categorie.annunci.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.annunci.form.audio.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_categorie.annunci.form.audio.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['categorie.annunci.form']['etc']['tabs'] )
	);

	// form annunci metadati
	$p['categorie.annunci.form.metadati'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-code" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'metadati' ),
		'h1'		=> array( $l		=> 'metadati' ),
		'parent'		=> array( 'id'		=> 'categorie.annunci.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.annunci.form.metadati.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_categorie.annunci.form.metadati.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['categorie.annunci.form']['etc']['tabs'] )
	);
	
	// form azioni annunci
	$p['categorie.annunci.form.tools'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'azioni categoria annuncio' ),
	    'h1'		=> array( $l		=> 'azioni categoria annuncio' ),
	    'parent'		=> array( 'id'		=> 'annunci.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_categorie.annunci.form.tools.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['categorie.annunci.form']['etc']['tabs'] )
	);
	