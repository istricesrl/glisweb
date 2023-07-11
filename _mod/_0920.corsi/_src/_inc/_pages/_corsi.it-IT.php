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
																		'priority'	=> '220' ) ) )														
	);

    // vista archivio corsi
	$p['corsi.archivio.view'] = array(
	    'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-archive" aria-hidden="true"></i>',
		'title'				=> array( $l		=> 'archivio' ),
	    'h1'				=> array( $l		=> 'archivio' ),
	    'parent'			=> array( 'id'		=> 'corsi.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_corsi.archivio.view.php' ),
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
														'corsi.form.relazioni',
														'corsi.form.acquisto',
														'corsi.form.iscritti',
# relazione con il modulo TODO
#														'corsi.form.calendario',
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
														'corsi.form.metadati',
														'corsi.form.stampe',
														'corsi.form.tools' ) )
	);

	// RELAZIONI CON IL MODULO TODO
	if( in_array( "1200.todo", $cf['mods']['active']['array'] ) ) {
		arrayInsertSeq( 'corsi.form.iscritti', $p['corsi.form']['etc']['tabs'], 'corsi.form.calendario' );
	}

	// RELAZIONI CON IL MODULO CONTENUTI
	if( in_array( "3000.contenuti", $cf['mods']['active']['array'] ) ) {
		arrayInsertSeq( 'corsi.form.iscritti', $p['corsi.form']['etc']['tabs'], 'corsi.form.web' );
		arrayInsertSeq( 'corsi.form.web', $p['corsi.form']['etc']['tabs'], 'corsi.form.sem' );
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

	// iscritti relazioni
	$p['corsi.form.relazioni'] = array(
	    'sitemap'			=> false,
		'title'				=> array( $l		=> 'relazioni' ),
	    'h1'				=> array( $l		=> 'relazioni' ),
	    'parent'			=> array( 'id'		=> 'corsi.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'corsi.form.relazioni.html' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_corsi.form.relazioni.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['corsi.form']['etc']['tabs'] )
	);

	// iscritti corsi
	$p['corsi.form.acquisto'] = array(
	    'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-shopping-cart" aria-hidden="true"></i>',
		'title'				=> array( $l		=> 'acquisto' ),
	    'h1'				=> array( $l		=> 'acquisto' ),
	    'parent'			=> array( 'id'		=> 'corsi.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'corsi.form.acquisto.html' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_corsi.form.acquisto.php' ),
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
	    'macro'				=> array( $m . '_src/_inc/_macro/_corsi.form.calendario.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['corsi.form']['etc']['tabs'] )
	);

	// calendario corsi
	$p['corsi.form.metadati'] = array(
	    'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-code" aria-hidden="true"></i>',
		'title'				=> array( $l		=> 'metadati' ),
		'h1'				=> array( $l		=> 'metadati' ),
	    'parent'			=> array( 'id'		=> 'corsi.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'corsi.form.metadati.html' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_corsi.form.metadati.php' ),
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
	    'macro'				=> array( $m . '_src/_inc/_macro/_corsi.form.stampe.php' ),
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
	    'macro'				=> array( $m . '_src/_inc/_macro/_corsi.form.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['corsi.form']['etc']['tabs'] )
	);

	$p['corsi.form.archiviazione'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-archive" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'archiviazione' ),
	    'h1'		=> array( $l		=> 'archiviazione' ),
	    'parent'		=> array( 'id'		=> 'corsi.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'corsi.form.archiviazione.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_corsi.form.archiviazione.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['corsi.form']['etc']['tabs'] )
	);

	if( in_array( "0620.tesseramenti", $cf['mods']['active']['array'] ) ||  in_array( "0630.iscrizioni", $cf['mods']['active']['array'] ) ||  in_array( "0640.abbonamenti", $cf['mods']['active']['array'] )) {
		
		// dashboard produzione
		$p['segreteria'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'segreteria' ),
			'h1'			=> array( $l		=> 'segreteria' ),
			'parent'		=> array( 'id'		=> NULL ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'segreteria.html' ),
			'macro'			=> array( $m . '_src/_inc/_macro/_segreteria.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> array(	'segreteria' ) ),
			'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'segreteria' ),
																			'priority'	=> '050' ) ) )														
		);
		
	}