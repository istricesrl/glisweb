<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0920.corsi/';

	// dashboard discipline
	$p['discipline.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'discipline' ),
	    'h1'			=> array( $l		=> 'discipline' ),
	    'parent'		=> array( 'id'		=> 'corsi.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_discipline.view.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'discipline.view',
														'discipline.tools' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'discipline' ),
																		'priority'	=> '310' ) ) )														
	);

    // tools discipline
	$p['discipline.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'discipline.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_discipline.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['discipline.view']['etc']['tabs'] )
	);

	// gestione progetti
	$p['discipline.form'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'gestione' ),
		'h1'			=> array( $l		=> 'gestione' ),
		'parent'		=> array( 'id'		=> 'discipline.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'discipline.form.html' ),
		'macro'			=> array( $m.'_src/_inc/_macro/_discipline.form.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'discipline.form', 
														'discipline.form.metadati',
														'discipline.form.tools' ) )
	);

	// RELAZIONI CON IL MODULO CONTENUTI
	if( in_array( "3000.contenuti", $cf['mods']['active']['array'] ) ) {
		arrayInsertSeq( 'discipline.form', $p['discipline.form']['etc']['tabs'], 'discipline.form.menu' );
		arrayInsertSeq( 'discipline.form', $p['discipline.form']['etc']['tabs'], 'discipline.form.testo' );
		arrayInsertSeq( 'discipline.form', $p['discipline.form']['etc']['tabs'], 'discipline.form.sem' );
		arrayInsertSeq( 'discipline.form', $p['discipline.form']['etc']['tabs'], 'discipline.form.web' );
	}

	$p['discipline.form.metadati'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-code" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'metadati' ),
		'h1'		=> array( $l		=> 'metadati' ),
		'parent'		=> array( 'id'		=> 'discipline.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'discipline.form.metadati.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_discipline.form.metadati.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['discipline.form']['etc']['tabs'] )
	);

    // tools discipline
	$p['discipline.form.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni corso' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'discipline.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_discipline.form.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['discipline.form']['etc']['tabs'] )
	);
