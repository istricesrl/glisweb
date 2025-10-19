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
															'anagrafica.view.archiviate',
															// 'anagrafica.stats',
															// 'anagrafica.stampe',
															'anagrafica.tools' ) ),
	    'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'anagrafica' ),
																			'priority'	=> '050' ) ) )
	);

    // tools anagrafica
	$p['anagrafica.view.archiviate'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-box-archive" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'anagrafiche archiviate' ),
	    'h1'				=> array( $l		=> 'archiviate' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_anagrafica.view.archiviate.php' ),
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
															// 'anagrafica.form.immagini',
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
                                                            'anagrafica.archivio.mail.view',
                                                            'anagrafica.archivio.url.view',
                                                            'anagrafica.archivio.anagrafica.indirizzi.view',
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

    // anagrafica archivio telefoni
	$p['anagrafica.archivio.telefoni.form'] = array(
		'sitemap'			=> false,
	    'title'				=> array( $l		=> 'gestione archivio telefoni' ),
	    'h1'				=> array( $l		=> 'gestione' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.archivio.telefoni.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'anagrafica.archivio.telefoni.form.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_anagrafica.archivio.telefoni.form.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> array(	'anagrafica.archivio.telefoni.form',
															'anagrafica.archivio.telefoni.form.tools' ) ),
	);

    // gestione anagrafica form tools
	$p['anagrafica.archivio.telefoni.form.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni archivio anagrafica telefoni' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.archivio.telefoni.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_anagrafica.archivio.telefoni.form.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'anagrafica.archivio.telefoni.form' )
	);

    // anagrafica archivio email
	$p['anagrafica.archivio.mail.view'] = array(
		'sitemap'			=> false,
	    'title'				=> array( $l		=> 'archivio e-mail' ),
	    'h1'				=> array( $l		=> 'e-mail' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.archivio' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_anagrafica.archivio.mail.view.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'anagrafica.archivio' )
	);

    // anagrafica archivio mail
	$p['anagrafica.archivio.mail.form'] = array(
		'sitemap'			=> false,
	    'title'				=> array( $l		=> 'gestione archivio e-mail' ),
	    'h1'				=> array( $l		=> 'gestione' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.archivio.mail.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'anagrafica.archivio.mail.form.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_anagrafica.archivio.mail.form.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> array(	'anagrafica.archivio.mail.form',
															'anagrafica.archivio.mail.form.tools' ) ),
	);

    // gestione anagrafica form tools
	$p['anagrafica.archivio.mail.form.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni archivio anagrafica e-mail' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.archivio.mail.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_anagrafica.archivio.mail.form.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'anagrafica.archivio.mail.form' )
	);

    // anagrafica archivio indirizzi
	$p['anagrafica.archivio.anagrafica.indirizzi.view'] = array(
		'sitemap'			=> false,
	    'title'				=> array( $l		=> 'archivio anagrafica indirizzi' ),
	    'h1'				=> array( $l		=> 'indirizzi' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.archivio' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_anagrafica.archivio.anagrafica.indirizzi.view.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'anagrafica.archivio' )
	);

    // anagrafica archivio anagrafica.indirizzi
	$p['anagrafica.archivio.anagrafica.indirizzi.form'] = array(
		'sitemap'			=> false,
	    'title'				=> array( $l		=> 'gestione archivio e-anagrafica.indirizzi' ),
	    'h1'				=> array( $l		=> 'gestione' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.archivio.anagrafica.indirizzi.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'anagrafica.archivio.anagrafica.indirizzi.form.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_anagrafica.archivio.anagrafica.indirizzi.form.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> array(	'anagrafica.archivio.anagrafica.indirizzi.form',
															'anagrafica.archivio.anagrafica.indirizzi.form.tools' ) ),
	);

    // gestione anagrafica form tools
	$p['anagrafica.archivio.anagrafica.indirizzi.form.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni archivio anagrafica e-anagrafica.indirizzi' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.archivio.anagrafica.indirizzi.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_anagrafica.archivio.anagrafica.indirizzi.form.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'anagrafica.archivio.anagrafica.indirizzi.form' )
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

    // anagrafica archivio url
	$p['anagrafica.archivio.url.form'] = array(
		'sitemap'			=> false,
	    'title'				=> array( $l		=> 'gestione archivio e-url' ),
	    'h1'				=> array( $l		=> 'gestione' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.archivio.url.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'anagrafica.archivio.url.form.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_anagrafica.archivio.url.form.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> array(	'anagrafica.archivio.url.form',
															'anagrafica.archivio.url.form.tools' ) ),
	);

    // gestione anagrafica form tools
	$p['anagrafica.archivio.url.form.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni archivio anagrafica e-url' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.archivio.url.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_anagrafica.archivio.url.form.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'anagrafica.archivio.url.form' )
	);

    // anagrafica archivio tipologie
    $p['anagrafica.archivio.tipologie.anagrafica.view'] = array(
		'sitemap'			=> false,
	    'title'				=> array( $l		=> 'archivio tipologie anagrafica' ),
	    'h1'				=> array( $l		=> 'tipologie anagrafica' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.archivio' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_anagrafica.archivio.tipologie.anagrafica.view.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'anagrafica.archivio' )
	);

    // anagrafica archivio tipologie.anagrafica
	$p['anagrafica.archivio.tipologie.anagrafica.form'] = array(
		'sitemap'			=> false,
	    'title'				=> array( $l		=> 'gestione archivio e-tipologie.anagrafica' ),
	    'h1'				=> array( $l		=> 'gestione' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.archivio.tipologie.anagrafica.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'anagrafica.archivio.tipologie.anagrafica.form.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_anagrafica.archivio.tipologie.anagrafica.form.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> array(	'anagrafica.archivio.tipologie.anagrafica.form',
															'anagrafica.archivio.tipologie.anagrafica.form.tools' ) ),
	);

    // gestione anagrafica form tools
	$p['anagrafica.archivio.tipologie.anagrafica.form.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni archivio anagrafica e-tipologie.anagrafica' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.archivio.tipologie.anagrafica.view' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_anagrafica.archivio.tipologie.anagrafica.form.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'anagrafica.archivio.tipologie.anagrafica.form' )
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

