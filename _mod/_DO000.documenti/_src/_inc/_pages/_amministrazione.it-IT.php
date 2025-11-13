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
	$m = DIR_MOD . '_DO000.documenti/';

    // tools archivio amministrazione
	$p['amministrazione.documenti.view'] = array(
		'sitemap'			=> false,
	    'title'				=> array( $l		=> 'amministrazione documenti' ),
	    'h1'				=> array( $l		=> 'documenti' ),
	    'parent'			=> array( 'id'		=> 'amministrazione' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_amministrazione.documenti.view.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> array(	'amministrazione.documenti.view',
                                                            'amministrazione.documenti.articoli.view',
                                                            'amministrazione.pagamenti.view',
                                                            'amministrazione.documenti.view.archiviati',
															'amministrazione.documenti.tools' ) ),
	    'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'documenti' ),
																			'priority'	=> '600' ) ) )
	);

    // tools archivio amministrazione
	$p['amministrazione.documenti.articoli.view'] = array(
		'sitemap'			=> false,
	    'title'				=> array( $l		=> 'documenti articoli' ),
	    'h1'				=> array( $l		=> 'righe' ),
	    'parent'			=> array( 'id'		=> 'amministrazione.documenti.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_amministrazione.documenti.articoli.view.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'amministrazione.documenti.view' )
	);

    // tools archivio amministrazione
	$p['amministrazione.pagamenti.view'] = array(
		'sitemap'			=> false,
	    'title'				=> array( $l		=> 'pagamenti' ),
	    'h1'				=> array( $l		=> 'pagamenti' ),
	    'parent'			=> array( 'id'		=> 'amministrazione.documenti.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_amministrazione.pagamenti.view.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'amministrazione.documenti.view' )
	);

    // tools archivio amministrazione
	$p['amministrazione.documenti.view.archiviati'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-box-archive" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'documenti archiviate' ),
	    'h1'				=> array( $l		=> 'archiviate' ),
	    'parent'			=> array( 'id'		=> 'amministrazione.documenti.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_amministrazione.documenti.view.archiviati.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'amministrazione.documenti.view' )
	);

    // tools archivio amministrazione
	$p['amministrazione.documenti.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni amministrazione documenti' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'amministrazione.documenti.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_amministrazione.documenti.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'amministrazione.documenti.view' )
	);

    // tools archivio amministrazione
	$p['amministrazione.documenti.form'] = array(
		'sitemap'			=> false,
	    'title'				=> array( $l		=> 'amministrazione documenti form' ),
	    'h1'				=> array( $l		=> 'gestione' ),
	    'parent'			=> array( 'id'		=> 'amministrazione.documenti.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'amministrazione.documenti.form.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_amministrazione.documenti.form.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> array(	'amministrazione.documenti.form',
                                                            'amministrazione.documenti.form.relazioni',
                                                            'amministrazione.documenti.form.righe',
                                                            'amministrazione.documenti.form.pagamenti',
                                                            'amministrazione.documenti.form.archiviazione',
                                                            'amministrazione.documenti.form.stampe',
															'amministrazione.documenti.form.tools' ) )
	);

    // tools archivio amministrazione
	$p['amministrazione.documenti.form.relazioni'] = array(
		'sitemap'			=> false,
	    'title'				=> array( $l		=> 'amministrazione documenti form relazioni' ),
	    'h1'				=> array( $l		=> 'relazioni' ),
	    'parent'			=> array( 'id'		=> 'amministrazione.documenti.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'amministrazione.documenti.form.relazioni.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_amministrazione.documenti.form.relazioni.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'amministrazione.documenti.form' )
	);

    // tools archivio amministrazione
	$p['amministrazione.documenti.form.righe'] = array(
		'sitemap'			=> false,
	    'title'				=> array( $l		=> 'amministrazione documenti form righe' ),
	    'h1'				=> array( $l		=> 'righe' ),
	    'parent'			=> array( 'id'		=> 'amministrazione.documenti.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'amministrazione.documenti.form.righe.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_amministrazione.documenti.form.righe.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'amministrazione.documenti.form' )
	);

    // tools archivio amministrazione
	$p['amministrazione.documenti.form.pagamenti'] = array(
		'sitemap'			=> false,
	    'title'				=> array( $l		=> 'amministrazione documenti form pagamenti' ),
	    'h1'				=> array( $l		=> 'pagamenti' ),
	    'parent'			=> array( 'id'		=> 'amministrazione.documenti.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'amministrazione.documenti.form.pagamenti.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_amministrazione.documenti.form.pagamenti.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'amministrazione.documenti.form' )
	);

    // tools archivio amministrazione
	$p['amministrazione.documenti.form.archiviazione'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-box-archive" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'archiviazione amministrazione documenti form' ),
	    'h1'				=> array( $l		=> 'archiviazione' ),
	    'parent'			=> array( 'id'		=> 'amministrazione.documenti.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'amministrazione.documenti.form.archiviazione.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_amministrazione.documenti.form.archiviazione.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'amministrazione.documenti.form' )
	);

    // tools archivio amministrazione
	$p['amministrazione.documenti.form.stampe'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-print" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'amministrazione documenti form stampe' ),
	    'h1'				=> array( $l		=> 'stampe' ),
	    'parent'			=> array( 'id'		=> 'amministrazione.documenti.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_amministrazione.documenti.form.stampe.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'amministrazione.documenti.form' )
	);

    // tools archivio amministrazione
	$p['amministrazione.documenti.form.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni amministrazione documenti form' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'amministrazione.documenti.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_amministrazione.documenti.form.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'amministrazione.documenti.form' )
	);

    // tools archivio amministrazione
	$p['amministrazione.documenti.articoli.form'] = array(
		'sitemap'			=> false,
	    'title'				=> array( $l		=> 'amministrazione documenti articoli form' ),
	    'h1'				=> array( $l		=> 'gestione' ),
	    'parent'			=> array( 'id'		=> 'amministrazione.documenti.articoli.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'amministrazione.documenti.articoli.form.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_amministrazione.documenti.articoli.form.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> array(	'amministrazione.documenti.articoli.form',
															'amministrazione.documenti.articoli.form.tools' ) )
	);

    // tools archivio amministrazione
	$p['amministrazione.documenti.articoli.form.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni amministrazione documenti articoli form' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'amministrazione.documenti.articoli.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_amministrazione.documenti.articoli.form.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'amministrazione.documenti.articoli.form' )
	);

    // tools archivio amministrazione
	$p['amministrazione.pagamenti.form'] = array(
		'sitemap'			=> false,
	    'title'				=> array( $l		=> 'amministrazione pagamenti form' ),
	    'h1'				=> array( $l		=> 'gestione' ),
	    'parent'			=> array( 'id'		=> 'amministrazione.pagamenti.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'amministrazione.pagamenti.form.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_amministrazione.pagamenti.form.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> array(	'amministrazione.pagamenti.form',
                                                            'amministrazione.pagamenti.form.stampe',
															'amministrazione.pagamenti.form.tools' ) )
	);

    // tools archivio amministrazione
	$p['amministrazione.pagamenti.form.stampe'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-print" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'amministrazione pagamenti form stampe' ),
	    'h1'				=> array( $l		=> 'stampe' ),
	    'parent'			=> array( 'id'		=> 'amministrazione.pagamenti.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_amministrazione.pagamenti.form.stampe.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'amministrazione.pagamenti.form' )
	);

    // tools archivio amministrazione
	$p['amministrazione.pagamenti.form.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni amministrazione pagamenti form' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'amministrazione.pagamenti.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_amministrazione.pagamenti.form.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'amministrazione.pagamenti.form' )
	);

