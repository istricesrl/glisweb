<?php

    // modulo di questo file
	$m = DIR_MOD . '_6900.questionari/';

	// vista questionari
	$p['questionari.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'questionari' ),
	    'h1'			=> array( $l		=> 'questionari' ),
	    'parent'		=> array( 'id'		=> 'archivio' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_questionari.view.php' ),
		'etc'			=> array( 'tabs'	=> array(	'questionari.view' ) ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'questionari' ),
														'priority'	=> '100' ) ) )
	);

	// gestione questionari
	$p['questionari.form'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'gestione' ),
	    'h1'			=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'questionari.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'questionari.form.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_questionari.form.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'questionari.form', 
														'questionari.form.domande', 
														'questionari.form.stampe',
														'questionari.form.tools' ) )
	);

	// gestione tools questionari
	$p['questionari.form.domande'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'domande' ),
	    'h1'			=> array( $l		=> 'domande' ),
	    'parent'		=> array( 'id'		=> 'questionari.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'questionari.form.domande.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_questionari.form.domande.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> $p['questionari.form']['etc']['tabs'] )
	);

	// gestione tools questionari
	$p['questionari.form.tools'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'			=> array( $l		=> 'azioni questionari' ),
	    'h1'			=> array( $l		=> 'azioni questionari' ),
	    'parent'		=> array( 'id'		=> 'questionari.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_questionari.form.tools.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> $p['questionari.form']['etc']['tabs'] )
	);

	// gestione anagrafica stampe
	$p['questionari.form.stampe'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-print" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'stampe' ),
	    'h1'		=> array( $l		=> 'stampe' ),
	    'parent'		=> array( 'id'		=> 'questionari.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'		=> array( $m.'_src/_inc/_macro/_questionari.form.stampe.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['questionari.form']['etc']['tabs'] )
	);

	// vista questionari_articoli (righe)
	$p['questionari.domande.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'righe' ),
	    'h1'			=> array( $l		=> 'righe' ),
	    'parent'		=> array( 'id'		=> 'questionari.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_questionari.domande.view.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> $p['questionari.view']['etc']['tabs'] )
	);

	// gestione questionari_articoli
	$p['questionari.domande.form'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'gestione' ),
	    'h1'			=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'questionari.domande.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'questionari.domande.form.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_questionari.domande.form.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'questionari.domande.form') )
	);


