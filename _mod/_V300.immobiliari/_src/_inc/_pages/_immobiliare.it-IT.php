<?php

	// lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_V300.immobiliari/';

	// dashboard immobiliare
	$p['immobiliari'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'immobiliari' ),
	    'h1'			=> array( $l		=> 'immobiliari' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'immobiliari.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_immobiliari.php' ),
		'etc'			=> array( 'tabs'	=> array(	'immobiliari' ) ),
	    'auth'			=> array( 'groups'	=> array(	'roots' ) ),
		'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'immobiliari' ),
														'priority'	=> '300' ) ) )
	);

	// vista immobili
	$p['immobili.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'immobili' ),
	    'h1'			=> array( $l		=> 'immobili' ),
	    'parent'		=> array( 'id'		=> 'immobiliari' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_immobili.view.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'			=> array( 'tabs'	=> array(	'immobili.view',
														'immobili.tools'
													) ),
		'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'immobili' ),
								'priority'	=> '010' ) ) )	
    );

	// tools immobili
	$p['immobili.tools'] = array(
	    'sitemap'		=> false,
		'icon'			=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'			=> array( $l		=> 'azioni' ),
	    'h1'			=> array( $l		=> 'azioni' ),
	    'parent'		=> array( 'id'		=> 'immobiliare' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_immobili.tools.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'			=> array( 'tabs'	=> $p['immobili.view']['etc']['tabs'] )
    );

	// form immobili
	$p['immobili.form'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'gestione' ),
	    'h1'			=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'immobili.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'immobili.form.html' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_immobili.form.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'			=> array( 'tabs'	=> array(	'immobili.form',
														'immobili.form.immagini',
														'immobili.form.video',
														'immobili.form.audio',
														'immobili.form.file',
														'immobili.form.metadati',
														'immobili.form.stampe'
													) )
	);

	// form immobili immagini
	$p['immobili.form.immagini'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-picture-o" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'immagini' ),
		'h1'		=> array( $l		=> 'immagini' ),
		'parent'		=> array( 'id'		=> 'immobili.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'immobili.form.immagini.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_immobili.form.immagini.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['immobili.form']['etc']['tabs'] )
	);

	// form immobili video
	$p['immobili.form.video'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-video-camera" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'video' ),
		'h1'		=> array( $l		=> 'video' ),
		'parent'		=> array( 'id'		=> 'immobili.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'immobili.form.video.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_immobili.form.video.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['immobili.form']['etc']['tabs'] )
	);
	
	// form immobili file
	$p['immobili.form.file'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-folder-open-o" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'file' ),
		'h1'		=> array( $l		=> 'file' ),
		'parent'		=> array( 'id'		=> 'immobili.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'immobili.form.file.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_immobili.form.file.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['immobili.form']['etc']['tabs'] )
	);

	// form immobili audio
	$p['immobili.form.audio'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-volume-up" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'audio' ),
		'h1'		=> array( $l		=> 'audio' ),
		'parent'		=> array( 'id'		=> 'immobili.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'immobili.form.audio.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_immobili.form.audio.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['immobili.form']['etc']['tabs'] )
	);

	// form immobili metadati
	$p['immobili.form.metadati'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-code" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'metadati' ),
		'h1'		=> array( $l		=> 'metadati' ),
		'parent'		=> array( 'id'		=> 'immobili.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'immobili.form.metadati.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_immobili.form.metadati.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['immobili.form']['etc']['tabs'] )
	);

	// gestione immobili stampe
	$p['immobili.form.stampe'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-print" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'stampe' ),
		'h1'		=> array( $l		=> 'stampe' ),
		'parent'		=> array( 'id'		=> 'immobili.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
		'macro'		=> array( $m.'_src/_inc/_macro/_immobili.form.stampe.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['immobili.form']['etc']['tabs'] )
	);

	// vista edifici
	$p['edifici.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'edifici' ),
	    'h1'			=> array( $l		=> 'edifici' ),
	    'parent'		=> array( 'id'		=> 'immobiliari' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_edifici.view.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'			=> array( 'tabs'	=> array(	'edifici.view',
														'edifici.tools'
													) ),
		'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'edifici' ),
								'priority'	=> '020' ) ) )	
    );

	// tools edifici
	$p['edifici.tools'] = array(
	    'sitemap'		=> false,
		'icon'			=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'			=> array( $l		=> 'azioni' ),
	    'h1'			=> array( $l		=> 'azioni' ),
	    'parent'		=> array( 'id'		=> 'immobiliare' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_edifici.tools.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'			=> array( 'tabs'	=> $p['edifici.view']['etc']['tabs'] )
    );

	// form edifici
	$p['edifici.form'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'gestione' ),
	    'h1'			=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'edifici.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'edifici.form.html' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_edifici.form.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'			=> array( 'tabs'	=> array(	'edifici.form',
														'edifici.contratti.form.contratti',
														'edifici.form.immagini',
														'edifici.form.video',
														'edifici.form.audio',
														'edifici.form.file',
														'edifici.form.metadati',
														'edifici.form.stampe'
													) )
	);

	// gestione contratti edifici
	$p['edifici.contratti.form.contratti'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'contratti' ),
		'h1'		=> array( $l		=> 'contratti' ),
		'parent'		=> array( 'id'		=> 'edifici.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'edifici.contratti.form.contratti.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_edifici.contratti.form.contratti.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['edifici.form']['etc']['tabs'] )
	);

	// form edifici immagini
	$p['edifici.form.immagini'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-picture-o" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'immagini' ),
		'h1'		=> array( $l		=> 'immagini' ),
		'parent'		=> array( 'id'		=> 'edifici.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'edifici.form.immagini.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_edifici.form.immagini.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['edifici.form']['etc']['tabs'] )
	);

	// form edifici video
	$p['edifici.form.video'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-video-camera" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'video' ),
		'h1'		=> array( $l		=> 'video' ),
		'parent'		=> array( 'id'		=> 'edifici.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'edifici.form.video.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_edifici.form.video.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['edifici.form']['etc']['tabs'] )
	);
	
	// form edifici file
	$p['edifici.form.file'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-folder-open-o" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'file' ),
		'h1'		=> array( $l		=> 'file' ),
		'parent'		=> array( 'id'		=> 'edifici.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'edifici.form.file.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_edifici.form.file.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['edifici.form']['etc']['tabs'] )
	);

	// form edifici audio
	$p['edifici.form.audio'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-volume-up" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'audio' ),
		'h1'		=> array( $l		=> 'audio' ),
		'parent'		=> array( 'id'		=> 'edifici.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'edifici.form.audio.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_edifici.form.audio.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['edifici.form']['etc']['tabs'] )
	);

	// form edifici metadati
	$p['edifici.form.metadati'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-code" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'metadati' ),
		'h1'		=> array( $l		=> 'metadati' ),
		'parent'		=> array( 'id'		=> 'edifici.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'edifici.form.metadati.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_edifici.form.metadati.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['edifici.form']['etc']['tabs'] )
	);

	// gestione edifici stampe
	$p['edifici.form.stampe'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-print" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'stampe' ),
		'h1'		=> array( $l		=> 'stampe' ),
		'parent'		=> array( 'id'		=> 'edifici.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
		'macro'		=> array( $m.'_src/_inc/_macro/_edifici.form.stampe.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['edifici.form']['etc']['tabs'] )
	);

	// vista inidirzzi
	$p['inidirzzi.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'inidirzzi' ),
	    'h1'			=> array( $l		=> 'inidirzzi' ),
	    'parent'		=> array( 'id'		=> 'immobiliari' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_inidirzzi.view.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'			=> array( 'tabs'	=> array(	'inidirzzi.view'
													) ),
		'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'inidirzzi' ),
								'priority'	=> '030' ) ) )	
    );

	// form inidirzzi
	$p['inidirzzi.form'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'gestione' ),
	    'h1'			=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'inidirzzi.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'inidirzzi.form.html' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_inidirzzi.form.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'			=> array( 'tabs'	=> array(	'inidirzzi.form'
													) )
	);