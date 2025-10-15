<?php

    /**
     * definizione delle pagine per la gestione dell'anagrafica
     * 
     * 
     * 
     * 
     * 
     * TODO documentare
	 * TODO finire di mettere tutte le schede dell'anagrafica
     * 
     */

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
    $m = DIR_MOD . '_AN000.anagrafica/';

    // vista anagrafica
	$p['anagrafica.view']	= array(
	    'sitemap'			=> false,
	    'title'				=> array( $l		=> 'anagrafica' ),
	    'h1'				=> array( $l		=> 'anagrafica' ),
	    'parent'			=> array( 'id'		=> NULL ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_anagrafica.view.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> array(	'anagrafica.view',
															'anagrafica.archiviati.view',
															// 'anagrafica.stats',
															// 'anagrafica.stampe',
															'anagrafica.tools' ) ),
	    'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'anagrafica' ),
																			'priority'	=> '050' ) ) )
	);

    // tools anagrafica
	$p['anagrafica.archiviati.view'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-box-archive" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'anagrafica archiviati' ),
	    'h1'				=> array( $l		=> 'archiviati' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_anagrafica.archiviati.view.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'anagrafica.view' )
	);

    // tools anagrafica
	$p['anagrafica.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_anagrafica.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'anagrafica.view' )
	);

    // gestione anagrafica
	$p['anagrafica.form'] = array(
	    'sitemap'			=> false,
	    'title'				=> array( $l		=> 'gestione' ),
	    'h1'				=> array( $l		=> 'gestione' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'anagrafica.form.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_anagrafica.form.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> array(	'anagrafica.form',
															// 'anagrafica.form.informazioni',
															// 'anagrafica.form.relazioni',
															// 'anagrafica.form.amministrazione',
															// 'anagrafica.form.cliente',
															// 'anagrafica.form.fornitore',
															// 'anagrafica.form.collaboratore',
															// 'anagrafica.form.attivita',
															'anagrafica.form.immagini',
															// 'anagrafica.form.video',
															// 'anagrafica.form.audio',
															// 'anagrafica.form.file',
															// 'anagrafica.form.metadati',
															'anagrafica.form.archiviazione',
															// 'anagrafica.form.stats',
															// 'anagrafica.form.stampe',
															'anagrafica.form.tools' ) )
	);

    // gestione anagrafica form tools
	$p['anagrafica.form.archiviazione'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-box-archive" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'archiviazione form anagrafica' ),
	    'h1'				=> array( $l		=> 'archiviazione' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'anagrafica.form.archiviazione.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_anagrafica.form.archiviazione.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'anagrafica.form' )
	);

    // gestione anagrafica form tools
	$p['anagrafica.form.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni form anagrafica' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_anagrafica.form.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'anagrafica.form' )
	);

	// gestione anagrafica form immagini
	$p['anagrafica.form.immagini'] = array(
	    'sitemap'			=> false,
	    'icon'				=> '<i class="fa fa-image" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'immagini' ),
	    'h1'				=> array( $l		=> 'immagini' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'anagrafica.form.immagini.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_anagrafica.form.immagini.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'anagrafica.form' )
	);

    // anagrafica archivio
	$p['anagrafica.archivio'] = array(
	    'sitemap'			=> false,
	    'title'				=> array( $l		=> 'archivio anagrafica' ),
	    'h1'				=> array( $l		=> 'archivio' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_anagrafica.archivio.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'				=> array( 'tabs'	=> array(	'anagrafica.archivio',
                                                            'anagrafica.archivio.telefoni.view',
                                                            'anagrafica.archivio.email.view',
                                                            'anagrafica.archivio.url.view',
                                                            'anagrafica.archivio.indirizzi.view',
                                                            'anagrafica.archivio.tipologie.anagrafica.view',
															'anagrafica.archivio.tools' ) ),
	    'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'archivio' ),
																			'priority'	=> '900' ) ) )
	);

    // anagrafica archivio telefoni
	$p['anagrafica.archivio.telefoni.view'] = array(
		'sitemap'			=> false,
	    'title'				=> array( $l		=> 'archivio telefoni' ),
	    'h1'				=> array( $l		=> 'telefoni' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.archivio' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_anagrafica.archivio.telefoni.view.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'anagrafica.archivio' )
	);

    // anagrafica archivio email
	$p['anagrafica.archivio.email.view'] = array(
		'sitemap'			=> false,
	    'title'				=> array( $l		=> 'archivio email' ),
	    'h1'				=> array( $l		=> 'email' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.archivio' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_anagrafica.archivio.email.view.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'anagrafica.archivio' )
	);

    // anagrafica archivio indirizzi
	$p['anagrafica.archivio.indirizzi.view'] = array(
		'sitemap'			=> false,
	    'title'				=> array( $l		=> 'archivio indirizzi' ),
	    'h1'				=> array( $l		=> 'indirizzi' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.archivio' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_anagrafica.archivio.indirizzi.view.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'anagrafica.archivio' )
	);

    // anagrafica archivio url
	$p['anagrafica.archivio.url.view'] = array(
		'sitemap'			=> false,
	    'title'				=> array( $l		=> 'archivio url' ),
	    'h1'				=> array( $l		=> 'url' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.archivio' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_anagrafica.archivio.url.view.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'anagrafica.archivio' )
	);

    // anagrafica archivio tipologie
    $p['anagrafica.archivio.tipologie.anagrafica.view'] = array(
		'sitemap'			=> false,
	    'title'				=> array( $l		=> 'archivio tipologie anagrafica' ),
	    'h1'				=> array( $l		=> 'tipologie' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.archivio' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_anagrafica.archivio.tipologie.anagrafica.view.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'anagrafica.archivio' )
	);

    // tools anagrafica
	$p['anagrafica.archivio.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni archivio anagrafica' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.archivio' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_anagrafica.archivio.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'anagrafica.archivio' )
	);

    // vista categorie anagrafica
	$p['categorie.anagrafica.view'] = array(
	    'sitemap'			=> false,
	    'title'				=> array( $l		=> 'categorie anagrafica' ),
	    'h1'				=> array( $l		=> 'categorie' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_categorie.anagrafica.view.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'				=> array( 'tabs'	=> array(	'categorie.anagrafica.view',
															'categorie.anagrafica.tools' ) ),
	    'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'categorie' ),
																			'priority'	=> '000' ) ) )
	);

    // tools account
	$p['categorie.anagrafica.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni categorie anagrafica' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'categorie.anagrafica.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_categorie.anagrafica.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'categorie.anagrafica.view' )
	);

    // gestione categorie anagrafica
	$p['categorie.anagrafica.form'] = array(
	    'sitemap'			=> false,
	    'title'				=> array( $l		=> 'categorie anagrafica gestione' ),
	    'h1'				=> array( $l		=> 'gestione' ),
	    'parent'			=> array( 'id'		=> 'categorie.anagrafica.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'categorie.anagrafica.form.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_categorie.anagrafica.form.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> array(	'categorie.anagrafica.form',
															'categorie.anagrafica.form.tools' ) )
	);

    // tools account
	$p['categorie.anagrafica.form.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni categoria anagrafica' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'categorie.anagrafica.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_categorie.anagrafica.form.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'categorie.anagrafica.form' )
	);

