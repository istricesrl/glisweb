<?php

    /**
     * 
     * 
     * 
     * 
     * TODO documentare
     * 
     * 
     */

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_06000.amministrazione/';

	// dashboard amministrazione
	$p['amministrazione'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'amministrazione' ),
	    'h1'			=> array( $l		=> 'amministrazione' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'template'		=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'amministrazione.twig' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_amministrazione.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'amministrazione',
														'amministrazione.tools'
														 ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'amministrazione' ),
																		'priority'	=> '6000' ) ) )														
	);

    // tools amministrazione
	$p['amministrazione.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'amministrazione' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_amministrazione.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'amministrazione' )
	);

	// dashboard amministrazione
	$p['amministrazione.archivio'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'archivio amministrazione' ),
	    'h1'			=> array( $l		=> 'archivio' ),
	    'parent'		=> array( 'id'		=> 'amministrazione' ),
	    'template'		=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'amministrazione.archivio.twig' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_amministrazione.archivio.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'amministrazione.archivio',
														'amministrazione.archivio.reparti.view',
														'amministrazione.archivio.tools'
														 ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'archivio' ),
																		'priority'	=> '9900' ) ) )														
	);

    // tools archivio amministrazione
	$p['amministrazione.archivio.reparti.view'] = array(
		'sitemap'			=> false,
	    'title'				=> array( $l		=> 'reparti' ),
	    'h1'				=> array( $l		=> 'reparti' ),
	    'parent'			=> array( 'id'		=> 'amministrazione.archivio' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_amministrazione.archivio.reparti.view.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'amministrazione.archivio' )
	);

    // tools archivio amministrazione
	$p['amministrazione.archivio.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'amministrazione.archivio' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_amministrazione.archivio.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'amministrazione.archivio' )
	);

	// dashboard amministrazione
	$p['amministrazione.ciclo.attivo'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'amministrazione ciclo attivo' ),
	    'h1'			=> array( $l		=> 'ciclo attivo' ),
	    'parent'		=> array( 'id'		=> 'amministrazione' ),
	    'template'		=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'amministrazione.ciclo.attivo.twig' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_amministrazione.ciclo.attivo.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'amministrazione.ciclo.attivo',
														'amministrazione.ciclo.attivo.tools'
														 ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'ciclo attivo' ),
																		'priority'	=> '1100' ) ) )														
	);

    // tools archivio amministrazione
	$p['amministrazione.ciclo.attivo.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni amministrazione ciclo attivo' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'amministrazione.ciclo.attivo' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_amministrazione.ciclo.attivo.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'amministrazione.ciclo.attivo' )
	);

	// dashboard amministrazione
	$p['amministrazione.ciclo.passivo'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'amministrazione ciclo passivo' ),
	    'h1'			=> array( $l		=> 'ciclo passivo' ),
	    'parent'		=> array( 'id'		=> 'amministrazione' ),
	    'template'		=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'amministrazione.ciclo.passivo.twig' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_amministrazione.ciclo.passivo.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'amministrazione.ciclo.passivo',
														'amministrazione.ciclo.passivo.tools'
														 ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'ciclo passivo' ),
																		'priority'	=> '2100' ) ) )														
	);

    // tools archivio amministrazione
	$p['amministrazione.ciclo.passivo.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni amministrazione ciclo passivo' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'amministrazione.ciclo.passivo' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_amministrazione.ciclo.passivo.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'amministrazione.ciclo.passivo' )
	);
