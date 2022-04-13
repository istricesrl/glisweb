<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0920.corsi/';

	// dashboard corsi
	$p['corsi.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'corsi' ),
	    'h1'			=> array( $l		=> 'corsi' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_corsi.view.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'corsi.view',
														'corsi.archivio.view',
														'corsi.stampe',
														'corsi.tools' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'corsi' ),
																		'priority'	=> '210' ) ) )														
	);

    // vista archivio corsi
	$p['corsi.archivio.view'] = array(
	    'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-archive" aria-hidden="true"></i>',
		'title'				=> array( $l		=> 'archivio' ),
	    'h1'				=> array( $l		=> 'archivio' ),
	    'parent'			=> array( 'id'		=> 'corsi.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'				=> array( '_src/_inc/_macro/_corsi.archivio.view.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['corsi.view']['etc']['tabs'] )
	);

	// stampe corsi
	$p['corsi.stampe'] = array(
	    'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-print" aria-hidden="true"></i>',
		'title'				=> array( $l		=> 'stampe' ),
	    'h1'				=> array( $l		=> 'stampe' ),
	    'parent'			=> array( 'id'		=> 'corsi.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_corsi.stampe.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['corsi.view']['etc']['tabs'] )
	);

    // tools corsi
	$p['corsi.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'corsi.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_corsi.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['corsi.view']['etc']['tabs'] )
	);

	// gestione progetti
	$p['corsi.form'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'gestione' ),
		'h1'			=> array( $l		=> 'gestione' ),
		'parent'		=> array( 'id'		=> 'corsi.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'corsi.form.html' ),
		'macro'			=> array( $m.'_src/_inc/_macro/_corsi.form.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'corsi.form', 
														'corsi.form.iscritti',
														'corsi.form.calendario',
# NOTA queste due voci vanno nel modulo contenuti
													/*	'corsi.form.sem',
														'corsi.form.testo', */
													/*	'progetti.produzione.form.mastri',*/
#														'progetti.produzione.form.todo',
# NOTA questa va nel modulo pianificazioni
#														'progetti.produzione.form.pause',
														'corsi.form.archiviazione',
# NOTA questa va nel modulo pianificazioni
#														'progetti.produzione.form.pianificazioni',
														'corsi.form.stampe',
														'corsi.form.tools' ) )
	);

	// RELAZIONI CON IL MODULO CONTENUTI
	if( in_array( "3000.contenuti", $cf['mods']['active']['array'] ) ) {
		arrayInsertSeq( 'corsi.form.calendario', $p['corsi.form']['etc']['tabs'], 'corsi.form.sem' );
		arrayInsertSeq( 'corsi.form.sem', $p['corsi.form']['etc']['tabs'], 'corsi.form.testo' );
	}

	// iscritti corsi
	$p['corsi.form.iscritti'] = array(
	    'sitemap'			=> false,
		'title'				=> array( $l		=> 'iscritti' ),
	    'h1'				=> array( $l		=> 'iscritti' ),
	    'parent'			=> array( 'id'		=> 'corsi.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'corsi.form.iscritti.html' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_corsi.form.iscritti.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['corsi.form']['etc']['tabs'] )
	);

	// calendario corsi
	$p['corsi.form.calendario'] = array(
	    'sitemap'			=> false,
		'title'				=> array( $l		=> 'calendario' ),
	    'h1'				=> array( $l		=> 'calendario' ),
	    'parent'			=> array( 'id'		=> 'corsi.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'corsi.form.calendario.html' ),
	    'macro'				=> array( '_src/_inc/_macro/_corsi.form.calendario.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['corsi.form']['etc']['tabs'] )
	);

	// stampe corsi
	$p['corsi.form.stampe'] = array(
	    'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-print" aria-hidden="true"></i>',
		'title'				=> array( $l		=> 'stampe corso' ),
	    'h1'				=> array( $l		=> 'stampe' ),
	    'parent'			=> array( 'id'		=> 'corsi.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'				=> array( '_src/_inc/_macro/_corsi.stampe.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['corsi.form']['etc']['tabs'] )
	);

    // tools corsi
	$p['corsi.form.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni corso' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'corsi.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'				=> array( '_src/_inc/_macro/_corsi.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['corsi.form']['etc']['tabs'] )
	);
