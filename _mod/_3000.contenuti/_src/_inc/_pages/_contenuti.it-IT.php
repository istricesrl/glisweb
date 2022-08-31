<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_3000.contenuti/';

    // dashboard contenuti
	$p['contenuti'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'contenuti' ),
	    'h1'		=> array( $l		=> 'contenuti' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'contenuti.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_contenuti.php' ),
	    'parent'		=> array( 'id'		=> NULL ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> array(	'contenuti' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'contenuti' ),
									'priority'	=> '800' ) ) )	
	);

    // vista pagine
	$p['pagine.view'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'pagine' ),
	    'h1'		=> array( $l		=> 'pagine' ),
	    'parent'		=> array( 'id'		=> 'contenuti' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_pagine.view.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'pagine.view',
									'pagine.tools' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'pagine' ),
									'priority'	=> '010' ) ) )	
    );

    // tools pagine
	$p['pagine.tools'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'azioni' ),
	    'h1'		=> array( $l		=> 'azioni' ),
	    'parent'		=> array( 'id'		=> 'contenuti' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_pagine.tools.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['pagine.view']['etc']['tabs'] )
    );

    // form pagine
	$p['pagine.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'pagine.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'pagine.form.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_pagine.form.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'pagine.form',
													'pagine.form.sem',
													'pagine.form.testo',
													'pagine.form.menu',
													'pagine.form.immagini',
													'pagine.form.video',
													'pagine.form.audio',
													'pagine.form.file',
													'pagine.form.macro',
													'pagine.form.metadati',
													'pagine.form.gruppi',
													'pagine.form.tools'
												) )
	);

	// form pagine SEM/SMM
/*	$p['pagine.form.sem'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'SEM/SMM' ),
	    'h1'		=> array( $l		=> 'SEM/SMM' ),
	    'parent'		=> array( 'id'		=> 'pagine.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'pagine.form.sem.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_pagine.form.sem.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['pagine.form']['etc']['tabs'] )
	);*/



	// form pagine menu
	$p['pagine.form.menu'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'menu' ),
	    'h1'		=> array( $l		=> 'menu' ),
	    'parent'		=> array( 'id'		=> 'pagine.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'pagine.form.menu.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_pagine.form.menu.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['pagine.form']['etc']['tabs'] )
	);

	$p['pagine.form.sem'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'SEM/SMM' ),
	    'h1'		=> array( $l		=> 'SEM/SMM' ),
	    'parent'		=> array( 'id'		=> 'contenuti' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'pagine.form.sem.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_pagine.form.php', $m . '_src/_inc/_macro/_pagine.form.sem.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> $p['pagine.form']['etc']['tabs'] )
	);
	
	// form pagine testo
	$p['pagine.form.testo'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'testo' ),
	    'h1'		=> array( $l		=> 'testo' ),
	    'parent'		=> array( 'id'		=> 'pagine.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'pagine.form.testo.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_pagine.form.testo.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['pagine.form']['etc']['tabs'] )
	);

	$p['pagine.form.macro'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'macro' ),
		'h1'		=> array( $l		=> 'macro' ),
		'parent'		=> array( 'id'		=> 'pagine.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'pagine.form.macro.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_pagine.form.macro.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['pagine.form']['etc']['tabs'] )
	);

	$p['pagine.form.immagini'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-picture-o" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'immagini' ),
		'h1'		=> array( $l		=> 'immagini' ),
		'parent'		=> array( 'id'		=> 'pagine.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'pagine.form.immagini.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_pagine.form.immagini.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['pagine.form']['etc']['tabs'] )
	);

	// form pagine video
	$p['pagine.form.video'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-video-camera" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'video' ),
		'h1'		=> array( $l		=> 'video' ),
		'parent'		=> array( 'id'		=> 'pagine.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'pagine.form.video.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_pagine.form.video.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['pagine.form']['etc']['tabs'] )
	);
	
	// form pagina file
	$p['pagine.form.file'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-folder-open-o" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'file' ),
		'h1'		=> array( $l		=> 'file' ),
		'parent'		=> array( 'id'		=> 'pagine.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'pagine.form.file.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_pagine.form.file.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['pagine.form']['etc']['tabs'] )
	);

	// form pagine audio
	$p['pagine.form.audio'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-volume-up" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'audio' ),
		'h1'		=> array( $l		=> 'audio' ),
		'parent'		=> array( 'id'		=> 'pagine.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'pagine.form.audio.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_pagine.form.audio.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['pagine.form']['etc']['tabs'] )
	);

	// form pagine metadati
	$p['pagine.form.metadati'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-code" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'metadati' ),
		'h1'		=> array( $l		=> 'metadati' ),
		'parent'		=> array( 'id'		=> 'pagine.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'pagine.form.metadati.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_pagine.form.metadati.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['pagine.form']['etc']['tabs'] )
	);
	
	// form pagine gruppi
	$p['pagine.form.gruppi'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-users" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'gruppi' ),
		'h1'		=> array( $l		=> 'gruppi' ),
		'parent'		=> array( 'id'		=> 'pagine.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'pagine.form.gruppi.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_pagine.form.gruppi.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['pagine.form']['etc']['tabs'] )
	);
	
	// form azioni pagine
	$p['pagine.form.tools'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'azioni pagina' ),
	    'h1'		=> array( $l		=> 'azioni pagina' ),
	    'parent'		=> array( 'id'		=> 'pagine.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_pagine.form.tools.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['pagine.form']['etc']['tabs'] )
	);
