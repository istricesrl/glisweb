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
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> array(	'contenuti' ) ),
	    'menu'		=> array( 'admin'	=> array(	'label'		=> array( $l => 'contenuti' ),
									'priority'	=> '300' ) )
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
	    'menu'		=> array( 'admin'	=> array(	'label'		=> array( $l => 'pagine' ),
									'priority'	=> '010' ) )
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

    // gestione pagine
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
//													'pagine.form.contenuti',
													'pagine.form.immagini',
													'pagine.form.video',
													'pagine.form.audio',
													'pagine.form.file',
//													'pagine.form.menu',
//													'pagine.form.macro',
													'pagine.form.metadati',
													'pagine.form.gruppi',
													'pagine.form.tools'
												) )
	);

	// gestione pagine SEM/SMM
	$p['pagine.form.sem'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'SEM/SMM' ),
	    'h1'		=> array( $l		=> 'SEM/SMM' ),
	    'parent'		=> array( 'id'		=> 'pagine.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'pagine.form.sem.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_pagine.form.sem.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['pagine.form']['etc']['tabs'] )
	);

	// gestione pagine testo
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

	// gestione pagine immagini
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

	// gestione pagine video
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
	
	// gestione pagina file
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

	// gestione pagine audio
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

	// gestione pagine metadati
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
	
	// gestione pagine gruppi
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
	
	// gestione azioni pagine
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

/*
    // azioni sulle pagine
	$p['contenuti_azioni'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'contenuti_azioni' ),
	    'h1'		=> array( $l		=> 'azioni' ),
	    'parent'		=> array( 'id'		=> 'contenuti' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'metro.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_pagine.azioni.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> $p['contenuti']['etc']['tabs'] )
	);

    // gestione pagine
	$p['pagine_gestione'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'contenuti' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'pagine.gestione.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_pagine.gestione.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'pagine_gestione',
									'pagine.form.sem',
									'pagine.form.contenuti',
									'pagine.form.immagini',
									'pagine.form.video',
									'pagine.form.audio',
									'pagine.form.file',
									'pagine.form.menu',
									'pagine.form.macro',
									'pagine.form.metadati',
#									'pagine.form.informazioni',
									'pagine.form.azioni' ) )
	);

	$p['pagine.form.sem'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'SEM/SMM' ),
	    'h1'		=> array( $l		=> 'SEM/SMM' ),
	    'parent'		=> array( 'id'		=> 'contenuti' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'pagine.gestione.sem.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_pagine.gestione.php', $m . '_src/_inc/_macro/_pagine.gestione.sem.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> $p['pagine_gestione']['etc']['tabs'] )
	);

	$p['pagine.form.contenuti'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'testo' ),
	    'h1'		=> array( $l		=> 'testo' ),
	    'parent'		=> array( 'id'		=> 'contenuti' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'pagine.gestione.contenuti.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_pagine.gestione.php', $m . '_src/_inc/_macro/_pagine.gestione.contenuti.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> $p['pagine_gestione']['etc']['tabs'] )
	);

	$p['pagine.form.immagini'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'immagini' ),
	    'h1'		=> array( $l		=> 'immagini' ),
	    'parent'		=> array( 'id'		=> 'contenuti' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'pagine.gestione.immagini.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_pagine.gestione.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> $p['pagine_gestione']['etc']['tabs'] )
	);

	$p['pagine.form.video'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'video' ),
	    'h1'		=> array( $l		=> 'video' ),
	    'parent'		=> array( 'id'		=> 'contenuti' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'pagine.gestione.video.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_pagine.gestione.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> $p['pagine_gestione']['etc']['tabs'] )
	);

	$p['pagine.form.audio'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'audio' ),
	    'h1'		=> array( $l		=> 'audio' ),
	    'parent'		=> array( 'id'		=> 'contenuti' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'pagine.gestione.audio.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_pagine.gestione.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> $p['pagine_gestione']['etc']['tabs'] )
	);

	$p['pagine.form.file'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'allegati' ),
	    'h1'		=> array( $l		=> 'allegati' ),
	    'parent'		=> array( 'id'		=> 'contenuti' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'pagine.gestione.file.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_pagine.gestione.php', $m . '_src/_inc/_macro/_pagine.gestione.file.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> $p['pagine_gestione']['etc']['tabs'] )
	);

	$p['pagine.form.menu'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'menu' ),
	    'h1'		=> array( $l		=> 'menu' ),
	    'parent'		=> array( 'id'		=> 'contenuti' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'pagine.gestione.menu.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_pagine.gestione.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> $p['pagine_gestione']['etc']['tabs'] )
	);

	$p['pagine.form.macro'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'macro' ),
	    'h1'		=> array( $l		=> 'macro' ),
	    'parent'		=> array( 'id'		=> 'contenuti' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'pagine.gestione.macro.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_pagine.gestione.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> $p['pagine_gestione']['etc']['tabs'] )
	);

	$p['pagine.form.metadati'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'metadati' ),
	    'h1'		=> array( $l		=> 'metadati' ),
	    'parent'		=> array( 'id'		=> 'contenuti' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'pagine.gestione.metadati.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_pagine.gestione.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> $p['pagine_gestione']['etc']['tabs'] )
    );
*/
/*
	$p['pagine.form.informazioni'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'informazioni' ),
	    'h1'		=> array( $l		=> 'informazioni' ),
	    'parent'		=> array( 'id'		=> 'contenuti' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'pagine.gestione.informazioni.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_pagine.gestione.php', $m . '_src/_inc/_macro/_pagine.gestione.informazioni.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> $p['pagine_gestione']['etc']['tabs'] )
	);
*/
/*
	// SDF
	// azioni sulle pagine
	$p['pagine.form.azioni'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'azioni' ),
	    'h1'		=> array( $l		=> 'azioni' ),
	    'parent'		=> array( 'id'		=> 'contenuti' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'metro.html' ),
	    'macro'		=> array(  $m . '_src/_inc/_macro/_pagine.gestione.php', $m . '_src/_inc/_macro/_pagine.gestione.azioni.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> $p['pagine_gestione']['etc']['tabs'] )
	);



    // redirect
	$p['redirect'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'redirect' ),
	    'h1'		=> array( $l		=> 'redirect' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'view.html' ),
	    'parent'		=> array( 'id'		=> 'contenuti' ),
	    'macro'		=> array( '_src/_inc/_macro/_redirect.view.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'menu'		=> array( 'admin'	=> array(	'label'		=> array( $l => 'redirect' ),
									'priority'	=> 800 ) )
	);

    // gestione redirect
	$p['redirect_gestione'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione redirect' ),
	    'h1'		=> array( $l		=> 'gestione redirect' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'redirect.gestione.html' ),
	    'parent'		=> array( 'id'		=> 'redirect' ),
	    'macro'		=> array( '_src/_inc/_macro/_redirect.gestione.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	);
*/
?>
