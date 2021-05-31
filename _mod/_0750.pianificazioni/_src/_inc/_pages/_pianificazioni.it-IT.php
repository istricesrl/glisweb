<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0750.pianificazioni/';

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
		'etc'			=> array( 'tabs'	=> array(	'pianificazioni.form', 'pianificazioni.form.tools' ) )
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

