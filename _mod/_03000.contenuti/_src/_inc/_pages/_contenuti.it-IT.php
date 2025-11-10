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
	$m = DIR_MOD . '_03000.contenuti/';

	// dashboard contenuti
	$p['contenuti'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'contenuti' ),
	    'h1'			=> array( $l		=> 'contenuti' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'template'		=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'contenuti.twig' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_contenuti.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'contenuti',
														'contenuti.tools'
														 ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'contenuti' ),
																		'priority'	=> '3000' ) ) )														
	);

    // tools contenuti
	$p['contenuti.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'contenuti' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_contenuti.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'contenuti' )
	);

	// dashboard contenuti
	$p['contenuti.archivio'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'archivio contenuti' ),
	    'h1'			=> array( $l		=> 'archivio' ),
	    'parent'		=> array( 'id'		=> 'contenuti' ),
	    'template'		=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'contenuti.archivio.twig' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_contenuti.archivio.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'contenuti.archivio',
														'contenuti.archivio.tools'
														 ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'archivio' ),
																		'priority'	=> '9900' ) ) )														
	);

    // tools archivio contenuti
	$p['contenuti.archivio.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'contenuti.archivio' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_contenuti.archivio.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'contenuti.archivio' )
	);

	// dashboard contenuti
	$p['contenuti.template.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'template contenuti' ),
	    'h1'			=> array( $l		=> 'template' ),
	    'parent'		=> array( 'id'		=> 'contenuti' ),
	    'template'		=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_contenuti.template.view.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'contenuti.template.view',
														'contenuti.template.tools'
														 ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'template' ),
																		'priority'	=> '9000' ) ) )														
	);

    // tools template contenuti
	$p['contenuti.template.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'contenuti.template.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_contenuti.template.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'contenuti.template.view' )
	);

    // tools template contenuti
	$p['contenuti.template.form'] = array(
		'sitemap'			=> false,
	    'title'				=> array( $l		=> 'gestione template' ),
	    'h1'				=> array( $l		=> 'gestione' ),
	    'parent'			=> array( 'id'		=> 'contenuti.template.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'contenuti.template.form.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_contenuti.template.form.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> array( 'contenuti.template.form',
                                                            'contenuti.template.form.editor',
                                                            'contenuti.template.form.tools'
                                                        ) )
	);

    // tools template contenuti
	$p['contenuti.template.form.editor'] = array(
		'sitemap'			=> false,
	    'title'				=> array( $l		=> 'editor template' ),
	    'h1'				=> array( $l		=> 'editor' ),
	    'parent'			=> array( 'id'		=> 'contenuti.template.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'contenuti.template.form.editor.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_contenuti.template.form.editor.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'contenuti.template.form' )
	);

    // tools template contenuti
	$p['contenuti.template.form.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni template' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'contenuti.template.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_contenuti.template.form.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'contenuti.template.form' )
	);
