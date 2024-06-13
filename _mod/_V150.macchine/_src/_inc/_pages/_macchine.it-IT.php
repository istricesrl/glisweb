<?php

	// lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_V150.macchine/';

	// dashboard macchine
	$p['macchine'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'macchine' ),
	    'h1'			=> array( $l		=> 'macchine' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'macchine.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_macchine.php' ),
		'etc'			=> array( 'tabs'	=> array(	'macchine' ) ),
	    'auth'			=> array( 'groups'	=> array(	'roots' ) ),
		'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'macchine' ),
														'priority'	=> '300' ) ) )
	);

	// vista macchine
	$p['macchine.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'macchine' ),
	    'h1'			=> array( $l		=> 'macchine' ),
	    'parent'		=> array( 'id'		=> 'macchine' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_macchine.view.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'			=> array( 'tabs'	=> array(	'macchine.view',
														'macchine.tools'
													) ),
		'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'macchine' ),
								'priority'	=> '090' ) ) )	
    );

	// tools macchine
	$p['macchine.tools'] = array(
	    'sitemap'		=> false,
		'icon'			=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'			=> array( $l		=> 'azioni' ),
	    'h1'			=> array( $l		=> 'azioni' ),
	    'parent'		=> array( 'id'		=> 'macchine' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_macchine.tools.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'			=> array( 'tabs'	=> $p['macchine.view']['etc']['tabs'] )
    );

	// form macchine
	$p['macchine.form'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'gestione' ),
	    'h1'			=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'macchine.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'macchine.form.html' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_macchine.form.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'			=> array( 'tabs'	=> array(	'macchine.form',
														'macchine.form.caratteristiche',
														'macchine.form.immagini',
														'macchine.form.video',
														'macchine.form.audio',
														'macchine.form.file',
														'macchine.form.metadati',
														'macchine.form.stampe',
														'macchine.form.tools'
													) )
	);

	// RELAZIONI CON IL MODULO CONTRATTI
	if( in_array( "0600.contratti", $cf['mods']['active']['array'] ) ) {
		arrayInsertSeq( 'macchine.form.caratteristiche', $p['macchine.form']['etc']['tabs'], 'macchine.form.contratti' );
	}

	// RELAZIONI CON IL MODULO VALUTAZIONI
	if( in_array( "0800.valutazioni", $cf['mods']['active']['array'] ) ) {
		arrayInsertSeq( 'macchine.form.caratteristiche', $p['macchine.form']['etc']['tabs'], 'macchine.form.valutazioni' );
	}

	// form macchine immagini
	$p['macchine.form.caratteristiche'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'caratteristiche' ),
		'h1'		=> array( $l		=> 'caratteristiche' ),
		'parent'		=> array( 'id'		=> 'macchine.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'macchine.form.caratteristiche.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_macchine.form.caratteristiche.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['macchine.form']['etc']['tabs'] )
	);

	// form macchine immagini
	$p['macchine.form.immagini'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-picture-o" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'immagini' ),
		'h1'		=> array( $l		=> 'immagini' ),
		'parent'		=> array( 'id'		=> 'macchine.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'macchine.form.immagini.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_macchine.form.immagini.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['macchine.form']['etc']['tabs'] )
	);
	/*
	// form macchine immagini
	$p['macchine.form.webapp'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-envelope-o" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'dettaglio' ),
		'h1'		=> array( $l		=> 'dettaglio' ),
		'parent'		=> array( 'id'		=> 'macchine.view' ),
		'onclick'		=> array( $l		=> 'anagrafica.form' ),
		'target'		=> '_blank',
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'macchine.form.immagini.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_macchine.form.immagini.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['macchine.form']['etc']['tabs'] )
	);
	*/

	// form macchine video
	$p['macchine.form.video'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-video-camera" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'video' ),
		'h1'		=> array( $l		=> 'video' ),
		'parent'		=> array( 'id'		=> 'macchine.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'macchine.form.video.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_macchine.form.video.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['macchine.form']['etc']['tabs'] )
	);
	
	// form macchine file
	$p['macchine.form.file'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-folder-open-o" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'file' ),
		'h1'		=> array( $l		=> 'file' ),
		'parent'		=> array( 'id'		=> 'macchine.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'macchine.form.file.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_macchine.form.file.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['macchine.form']['etc']['tabs'] )
	);

	// form macchine audio
	$p['macchine.form.audio'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-volume-up" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'audio' ),
		'h1'		=> array( $l		=> 'audio' ),
		'parent'		=> array( 'id'		=> 'macchine.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'macchine.form.audio.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_macchine.form.audio.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['macchine.form']['etc']['tabs'] )
	);

	// form macchine metadati
	$p['macchine.form.metadati'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-code" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'metadati' ),
		'h1'		=> array( $l		=> 'metadati' ),
		'parent'		=> array( 'id'		=> 'macchine.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'macchine.form.metadati.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_macchine.form.metadati.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['macchine.form']['etc']['tabs'] )
	);

	// gestione macchine stampe
	$p['macchine.form.stampe'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-print" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'stampe' ),
		'h1'		=> array( $l		=> 'stampe' ),
		'parent'		=> array( 'id'		=> 'macchine.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
		'macro'		=> array( $m.'_src/_inc/_macro/_macchine.form.stampe.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['macchine.form']['etc']['tabs'] )
	);

	// gestione macchine tools
	$p['macchine.form.tools'] = array(
		'sitemap'		=> false,
		'icon'			=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
		'title'			=> array( $l		=> 'azioni' ),
		'h1'			=> array( $l		=> 'azioni' ),
		'parent'		=> array( 'id'		=> 'macchine' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_macchine.form.tools.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots' ) ),
		'etc'			=> array( 'tabs'	=> $p['macchine.view']['etc']['tabs'] )
	);

	// vista edifici
	$p['edifici.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'edifici' ),
	    'h1'			=> array( $l		=> 'edifici' ),
	    'parent'		=> array( 'id'		=> 'macchine' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_edifici.view.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'			=> array( 'tabs'	=> array(	'edifici.view',
														'edifici.tools'
													) ),
		'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'edifici' ),
								'priority'	=> '050' ) ) )	
    );

	// tools edifici
	$p['edifici.tools'] = array(
	    'sitemap'		=> false,
		'icon'			=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'			=> array( $l		=> 'azioni' ),
	    'h1'			=> array( $l		=> 'azioni' ),
	    'parent'		=> array( 'id'		=> 'macchine' ),
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
														'edifici.form.caratteristiche',
														'edifici.form.macchine',
														'edifici.form.immagini',
														'edifici.form.video',
														'edifici.form.audio',
														'edifici.form.file',
														'edifici.form.metadati',
														'edifici.form.stampe'
													) )
	);

	// form macchine immagini
	$p['edifici.form.caratteristiche'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'caratteristiche' ),
		'h1'		=> array( $l		=> 'caratteristiche' ),
		'parent'		=> array( 'id'		=> 'edifici.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'edifici.form.caratteristiche.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_edifici.form.caratteristiche.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['edifici.form']['etc']['tabs'] )
	);

	// gestione macchine edifici
	$p['edifici.form.macchine'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'macchine' ),
		'h1'		=> array( $l		=> 'macchine' ),
		'parent'		=> array( 'id'		=> 'edifici.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'edifici.form.macchine.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_edifici.form.macchine.php' ),
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
