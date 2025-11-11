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
	$m = DIR_MOD . '_NO000.notizie/';

    // tools archivio produzione
	$p['contenuti.notizie.view'] = array(
		'sitemap'			=> false,
	    'title'				=> array( $l		=> 'contenuti notizie' ),
	    'h1'				=> array( $l		=> 'notizie' ),
	    'parent'			=> array( 'id'		=> 'contenuti' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_contenuti.notizie.view.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> array(	'contenuti.notizie.view',
                                                            'contenuti.notizie.view.archiviate',
															'contenuti.notizie.tools' ) ),
	    'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'notizie' ),
																			'priority'	=> '200' ) ) )
	);

    // tools archivio produzione
	$p['contenuti.notizie.view.archiviate'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-box-archive" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'notizie archiviate' ),
	    'h1'				=> array( $l		=> 'archiviate' ),
	    'parent'			=> array( 'id'		=> 'contenuti.notizie.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_contenuti.notizie.view.archiviate.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'contenuti.notizie.view' )
	);

    // tools archivio produzione
	$p['contenuti.notizie.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni contenuti notizie' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'contenuti.notizie.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_contenuti.notizie.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'contenuti.notizie.view' )
	);

    // tools archivio produzione
	$p['contenuti.notizie.form'] = array(
		'sitemap'			=> false,
	    'title'				=> array( $l		=> 'contenuti notizie form' ),
	    'h1'				=> array( $l		=> 'gestione' ),
	    'parent'			=> array( 'id'		=> 'contenuti.notizie.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'contenuti.notizie.form.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_contenuti.notizie.form.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> array(	'contenuti.notizie.form',
                                                            'contenuti.notizie.form.archiviazione',
															'contenuti.notizie.form.tools' ) )
	);

	// RELAZIONI CON IL MODULO CONTENUTI
    if( in_array( "CO000.contenuti", $cf['mods']['active']['array'] ) ) {
		arrayInsertBefore( 'contenuti.notizie.form.archiviazione', $p['contenuti.notizie.form']['etc']['tabs'], 'contenuti.notizie.form.web' );
		arrayInsertBefore( 'contenuti.notizie.form.archiviazione', $p['contenuti.notizie.form']['etc']['tabs'], 'contenuti.notizie.form.sem' );
		arrayInsertBefore( 'contenuti.notizie.form.archiviazione', $p['contenuti.notizie.form']['etc']['tabs'], 'contenuti.notizie.form.contenuti' );
	}

	// RELAZIONI CON IL MODULO IMMAGINI
    if( in_array( "IM000.immagini", $cf['mods']['active']['array'] ) ) {
		arrayInsertBefore( 'contenuti.notizie.form.archiviazione', $p['contenuti.notizie.form']['etc']['tabs'], 'contenuti.notizie.form.immagini' );
	}

    // tools archivio produzione
	$p['contenuti.notizie.form.archiviazione'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-box-archive" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'archiviazione contenuti notizie form' ),
	    'h1'				=> array( $l		=> 'archiviazione' ),
	    'parent'			=> array( 'id'		=> 'contenuti.notizie.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'contenuti.notizie.form.archiviazione.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_contenuti.notizie.form.archiviazione.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'contenuti.notizie.form' )
	);

    // tools archivio produzione
	$p['contenuti.notizie.form.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni contenuti notizie form' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'contenuti.notizie.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_contenuti.notizie.form.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'contenuti.notizie.form' )
	);

    // tools archivio produzione
	$p['contenuti.notizie.form.archiviazione'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-box-archive" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'archiviazione contenuti notizie form' ),
	    'h1'				=> array( $l		=> 'archiviazione' ),
	    'parent'			=> array( 'id'		=> 'contenuti.notizie.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'contenuti.notizie.form.archiviazione.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_contenuti.notizie.form.archiviazione.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'contenuti.notizie.form' )
	);

    // tools archivio produzione
	$p['contenuti.notizie.form.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni contenuti notizie form' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'contenuti.notizie.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_contenuti.notizie.form.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'contenuti.notizie.form' )
	);

    // tools archivio produzione
	$p['contenuti.categorie.notizie.view'] = array(
		'sitemap'			=> false,
	    'title'				=> array( $l		=> 'contenuti categorie notizie' ),
	    'h1'				=> array( $l		=> 'categorie' ),
	    'parent'			=> array( 'id'		=> 'contenuti.notizie.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_contenuti.categorie.notizie.view.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> array(	'contenuti.categorie.notizie.view',
                                                            'contenuti.categorie.notizie.view.archiviate',
															'contenuti.categorie.notizie.tools' ) ),
	    'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'categorie' ),
																			'priority'	=> '200' ) ) )
	);

    // tools archivio produzione
	$p['contenuti.categorie.notizie.view.archiviate'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-box-archive" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'categorie notizie archiviate' ),
	    'h1'				=> array( $l		=> 'archiviate' ),
	    'parent'			=> array( 'id'		=> 'contenuti.categorie.notizie.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_contenuti.categorie.notizie.view.archiviate.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'contenuti.categorie.notizie.view' )
	);

    // tools archivio produzione
	$p['contenuti.categorie.notizie.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni contenuti categorie notizie' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'contenuti.categorie.notizie.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_contenuti.categorie.notizie.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'contenuti.categorie.notizie.view' )
	);

    // tools archivio produzione
	$p['contenuti.categorie.notizie.form'] = array(
		'sitemap'			=> false,
	    'title'				=> array( $l		=> 'contenuti categorie notizie form' ),
	    'h1'				=> array( $l		=> 'gestione' ),
	    'parent'			=> array( 'id'		=> 'contenuti.categorie.notizie.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'contenuti.categorie.notizie.form.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_contenuti.categorie.notizie.form.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> array(	'contenuti.categorie.notizie.form',
                                                            'contenuti.categorie.notizie.form.archiviazione',
															'contenuti.categorie.notizie.form.tools' ) )
	);

	// RELAZIONI CON IL MODULO CONTENUTI
    if( in_array( "CO000.contenuti", $cf['mods']['active']['array'] ) ) {
		arrayInsertBefore( 'contenuti.categorie.notizie.form.archiviazione', $p['contenuti.categorie.notizie.form']['etc']['tabs'], 'contenuti.categorie.notizie.form.web' );
		arrayInsertBefore( 'contenuti.categorie.notizie.form.archiviazione', $p['contenuti.categorie.notizie.form']['etc']['tabs'], 'contenuti.categorie.notizie.form.menu' );
		arrayInsertBefore( 'contenuti.categorie.notizie.form.archiviazione', $p['contenuti.categorie.notizie.form']['etc']['tabs'], 'contenuti.categorie.notizie.form.sem' );
		arrayInsertBefore( 'contenuti.categorie.notizie.form.archiviazione', $p['contenuti.categorie.notizie.form']['etc']['tabs'], 'contenuti.categorie.notizie.form.contenuti' );
	}

	// RELAZIONI CON IL MODULO IMMAGINI
    if( in_array( "IM000.immagini", $cf['mods']['active']['array'] ) ) {
		arrayInsertBefore( 'contenuti.categorie.notizie.form.archiviazione', $p['contenuti.categorie.notizie.form']['etc']['tabs'], 'contenuti.categorie.notizie.form.immagini' );
	}

    // tools archivio produzione
	$p['contenuti.categorie.notizie.form.archiviazione'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-box-archive" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'archiviazione contenuti categorie notizie form' ),
	    'h1'				=> array( $l		=> 'archiviazione' ),
	    'parent'			=> array( 'id'		=> 'contenuti.categorie.notizie.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'contenuti.categorie.notizie.form.archiviazione.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_contenuti.categorie.notizie.form.archiviazione.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'contenuti.categorie.notizie.form' )
	);

    // tools archivio produzione
	$p['contenuti.categorie.notizie.form.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni contenuti categorie notizie form' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'contenuti.categorie.notizie.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_contenuti.categorie.notizie.form.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'contenuti.categorie.notizie.form' )
	);

    // tools archivio produzione
	$p['contenuti.categorie.notizie.form.archiviazione'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-box-archive" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'archiviazione contenuti categorie notizie form' ),
	    'h1'				=> array( $l		=> 'archiviazione' ),
	    'parent'			=> array( 'id'		=> 'contenuti.categorie.notizie.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'contenuti.categorie.notizie.form.archiviazione.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_contenuti.categorie.notizie.form.archiviazione.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'contenuti.categorie.notizie.form' )
	);

    // tools archivio produzione
	$p['contenuti.categorie.notizie.form.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni contenuti categorie notizie form' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'contenuti.categorie.notizie.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_contenuti.categorie.notizie.form.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'contenuti.categorie.notizie.form' )
	);
