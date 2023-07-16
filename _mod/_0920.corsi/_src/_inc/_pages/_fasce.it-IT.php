<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0920.corsi/';

	// dashboard fasce
	$p['fasce.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'fasce di età' ),
	    'h1'			=> array( $l		=> 'fasce di età' ),
	    'parent'		=> array( 'id'		=> 'corsi.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_fasce.view.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'fasce.view',
														'fasce.tools' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'fasce di età' ),
																		'priority'	=> '310' ) ) )														
	);

    // tools fasce
	$p['fasce.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'fasce.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_fasce.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['fasce.view']['etc']['tabs'] )
	);

	// gestione progetti
	$p['fasce.form'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'gestione' ),
		'h1'			=> array( $l		=> 'gestione' ),
		'parent'		=> array( 'id'		=> 'fasce.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'fasce.form.html' ),
		'macro'			=> array( $m.'_src/_inc/_macro/_discipline.form.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'fasce.form', 
														'fasce.form.tools' ) )
	);

	// RELAZIONI CON IL MODULO CONTENUTI
	if( in_array( "3000.contenuti", $cf['mods']['active']['array'] ) ) {
		arrayInsertSeq( 'fasce.form', $p['fasce.form']['etc']['tabs'], 'fasce.form.web' );
		arrayInsertSeq( 'fasce.form.web', $p['fasce.form']['etc']['tabs'], 'fasce.form.sem' );
		arrayInsertSeq( 'fasce.form.sem', $p['fasce.form']['etc']['tabs'], 'fasce.form.testo' );
	}

    // tools fasce
	$p['fasce.form.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni corso' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'fasce.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_fasce.form.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['fasce.form']['etc']['tabs'] )
	);
