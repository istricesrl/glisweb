<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0100.pianificazioni/';

	// vista pianificazioni
	$p['pianificazioni.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'pianificazioni' ),
	    'h1'			=> array( $l		=> 'pianificazioni' ),
	    'parent'		=> array( 'id'		=> 'archivio' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_pianificazioni.view.php' ),
		'etc'			=> array( 'tabs'	=> array(	'pianificazioni.view' ) ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'pianificazioni' ),
														'priority'	=> '150' ) ) )																										
	);

	// gestione pianificazioni
	$p['pianificazioni.form'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'gestione' ),
	    'h1'			=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'pianificazioni.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'pianificazioni.form.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_pianificazioni.form.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'pianificazioni.form', 'pianificazioni.form.modello', 'pianificazioni.form.macro', 'pianificazioni.form.metadati', 'pianificazioni.form.tools' ) )
	);

	// gestione tools pianificazioni
	$p['pianificazioni.form.modello'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'modello' ),
	    'h1'			=> array( $l		=> 'modello' ),
	    'parent'		=> array( 'id'		=> 'pianificazioni.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'pianificazioni.form.modello.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_pianificazioni.form.modello.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> $p['pianificazioni.form']['etc']['tabs'] )
	);

	// gestione tools pianificazioni
	$p['pianificazioni.form.macro'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-caret-square-o-right" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'macro' ),
		'h1'		=> array( $l		=> 'macro' ),
		'parent'		=> array( 'id'		=> 'pianificazioni.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'pianificazioni.form.macro.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_pianificazioni.form.macro.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['pianificazioni.form']['etc']['tabs'] )
	);

	// gestione tools pianificazioni
	$p['pianificazioni.form.metadati'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-code" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'metadati' ),
		'h1'		=> array( $l		=> 'metadati' ),
		'parent'		=> array( 'id'		=> 'pianificazioni.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'pianificazioni.form.metadati.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_pianificazioni.form.metadati.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['pianificazioni.form']['etc']['tabs'] )
	);

	// gestione tools pianificazioni
	$p['pianificazioni.form.tools'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'			=> array( $l		=> 'azioni pianificazioni' ),
	    'h1'			=> array( $l		=> 'azioni pianificazioni' ),
	    'parent'		=> array( 'id'		=> 'pianificazioni.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_pianificazioni.form.tools.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> $p['pianificazioni.form']['etc']['tabs'] )
	);

