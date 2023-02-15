<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_3100.notizie/';

    // vista notizie
	$p['notizie.view'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'notizie' ),
	    'h1'		=> array( $l		=> 'notizie' ),
	    'parent'		=> array( 'id'		=> 'contenuti' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_notizie.view.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'notizie.view' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'notizie' ),
									'priority'	=> '090' ) ) )	
    );


    // form notizie
	$p['notizie.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'notizie.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'notizie.form.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_notizie.form.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'notizie.form',
													'notizie.form.sem',
													'notizie.form.testo',
													'notizie.form.immagini',
													'notizie.form.video',
													'notizie.form.audio',
													'notizie.form.file',
													'notizie.form.metadati',
													'notizie.form.tools'
												) )
	);

	// form notizie SEM/SMM
	$p['notizie.form.sem'] = array(
	    'sitemap'		=> false,
		'icon'			=> '<i class="fa fa-google" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'SEM/SMM' ),
	    'h1'		=> array( $l		=> 'SEM/SMM' ),
	    'parent'		=> array( 'id'		=> 'notizie.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'notizie.form.sem.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_notizie.form.sem.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['notizie.form']['etc']['tabs'] )
	);

	// form notizie testo
	$p['notizie.form.testo'] = array(
	    'sitemap'		=> false,
		'icon'			=> '<i class="fa fa-file-text-o" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'testo' ),
	    'h1'		=> array( $l		=> 'testo' ),
	    'parent'		=> array( 'id'		=> 'notizie.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'notizie.form.testo.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_notizie.form.testo.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['notizie.form']['etc']['tabs'] )
	);

	$p['notizie.form.contenuti'] = array(
	    'sitemap'		=> false,
		'icon'			=> '<i class="fa fa-file-text-o" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'testo' ),
	    'h1'		=> array( $l		=> 'testo' ),
	    'parent'		=> array( 'id'		=> 'notizie.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'notizie.form.contenuti.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_notizie.form.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> $p['notizie.form']['etc']['tabs'] )
	);

	$p['notizie.form.immagini'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-picture-o" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'immagini' ),
		'h1'		=> array( $l		=> 'immagini' ),
		'parent'		=> array( 'id'		=> 'notizie.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'notizie.form.immagini.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_notizie.form.immagini.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['notizie.form']['etc']['tabs'] )
	);

	// form notizie video
	$p['notizie.form.video'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-video-camera" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'video' ),
		'h1'		=> array( $l		=> 'video' ),
		'parent'		=> array( 'id'		=> 'notizie.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'notizie.form.video.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_notizie.form.video.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['notizie.form']['etc']['tabs'] )
	);
	
	// form notizie file
	$p['notizie.form.file'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-folder-open-o" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'file' ),
		'h1'		=> array( $l		=> 'file' ),
		'parent'		=> array( 'id'		=> 'notizie.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'notizie.form.file.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_notizie.form.file.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['notizie.form']['etc']['tabs'] )
	);

	// form notizie audio
	$p['notizie.form.audio'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-volume-up" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'audio' ),
		'h1'		=> array( $l		=> 'audio' ),
		'parent'		=> array( 'id'		=> 'notizie.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'notizie.form.audio.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_notizie.form.audio.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['notizie.form']['etc']['tabs'] )
	);

	// form notizie metadati
	$p['notizie.form.metadati'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-code" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'metadati' ),
		'h1'		=> array( $l		=> 'metadati' ),
		'parent'		=> array( 'id'		=> 'notizie.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'notizie.form.metadati.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_notizie.form.metadati.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['notizie.form']['etc']['tabs'] )
	);
	
	// form azioni notizie
	$p['notizie.form.tools'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'azioni notizia' ),
	    'h1'		=> array( $l		=> 'azioni notizia' ),
	    'parent'		=> array( 'id'		=> 'notizie.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_notizie.form.tools.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['notizie.form']['etc']['tabs'] )
	);

	 // vista categorie prodotti
	 $p['categorie.notizie.view'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'categorie' ),
	    'h1'		=> array( $l		=> 'categorie' ),
	    'parent'		=> array( 'id'		=> 'notizie.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_categorie.notizie.view.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'categorie.notizie.view') ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'categorie' ),
									'priority'	=> '007' ) ) )	
	);
	
    // gestione categorie notizie
	$p['categorie.notizie.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'categorie.notizie.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.notizie.form.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_categorie.notizie.form.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'categorie.notizie.form',
													'categorie.notizie.form.sem',
													'categorie.notizie.form.testo',
													'categorie.notizie.form.menu',
													'categorie.notizie.form.immagini',
													'categorie.notizie.form.video',
													'categorie.notizie.form.audio',
													'categorie.notizie.form.file',
													'categorie.notizie.form.metadati'
												) )
	);


	// form notizie SEM/SMM
	$p['categorie.notizie.form.sem'] = array(
	    'sitemap'		=> false,
		'icon'			=> '<i class="fa fa-google" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'SEM/SMM' ),
	    'h1'		=> array( $l		=> 'SEM/SMM' ),
	    'parent'		=> array( 'id'		=> 'categorie.notizie.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.notizie.form.sem.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_categorie.notizie.form.sem.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['categorie.notizie.form']['etc']['tabs'] )
	);

	// form notizie testo
	$p['categorie.notizie.form.testo'] = array(
	    'sitemap'		=> false,
		'icon'			=> '<i class="fa fa-file-text-o" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'testo' ),
	    'h1'		=> array( $l		=> 'testo' ),
	    'parent'		=> array( 'id'		=> 'categorie.notizie.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.notizie.form.testo.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_categorie.notizie.form.testo.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['categorie.notizie.form']['etc']['tabs'] )
	);

	// form categorie notizie menu
	$p['categorie.notizie.form.menu'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-bars" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'menu' ),
	    'h1'		=> array( $l		=> 'menu' ),
	    'parent'		=> array( 'id'		=> 'categorie.notizie.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.notizie.form.menu.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_categorie.notizie.form.menu.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['categorie.notizie.form']['etc']['tabs'] )
	);

	// form categorie notizie immagini
	$p['categorie.notizie.form.immagini'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-picture-o" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'immagini' ),
		'h1'		=> array( $l		=> 'immagini' ),
		'parent'		=> array( 'id'		=> 'categorie.notizie.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.notizie.form.immagini.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_categorie.notizie.form.immagini.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['categorie.notizie.form']['etc']['tabs'] )
	);

	// form notizie video
	$p['categorie.notizie.form.video'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-video-camera" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'video' ),
		'h1'		=> array( $l		=> 'video' ),
		'parent'		=> array( 'id'		=> 'categorie.notizie.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.notizie.form.video.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_categorie.notizie.form.video.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['categorie.notizie.form']['etc']['tabs'] )
	);
	
	// form notizie file
	$p['categorie.notizie.form.file'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-folder-open-o" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'file' ),
		'h1'		=> array( $l		=> 'file' ),
		'parent'		=> array( 'id'		=> 'categorie.notizie.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.notizie.form.file.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_categorie.notizie.form.file.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['categorie.notizie.form']['etc']['tabs'] )
	);

	// form notizie audio
	$p['categorie.notizie.form.audio'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-volume-up" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'audio' ),
		'h1'		=> array( $l		=> 'audio' ),
		'parent'		=> array( 'id'		=> 'categorie.notizie.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.notizie.form.audio.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_categorie.notizie.form.audio.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['categorie.notizie.form']['etc']['tabs'] )
	);

	// form notizie metadati
	$p['categorie.notizie.form.metadati'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-code" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'metadati' ),
		'h1'		=> array( $l		=> 'metadati' ),
		'parent'		=> array( 'id'		=> 'categorie.notizie.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.notizie.form.metadati.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_categorie.notizie.form.metadati.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['categorie.notizie.form']['etc']['tabs'] )
	);
	
	// form azioni notizie
	$p['categorie.notizie.form.tools'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'azioni categoria notizia' ),
	    'h1'		=> array( $l		=> 'azioni categoria notizia' ),
	    'parent'		=> array( 'id'		=> 'notizie.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_categorie.notizie.form.tools.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['categorie.notizie.form']['etc']['tabs'] )
	);
	