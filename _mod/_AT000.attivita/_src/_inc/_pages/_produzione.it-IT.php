<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_AT000.attivita/';

	// RELAZIONI CON IL MODULO PRODUZIONE
	if( in_array( "01000.produzione", $cf['mods']['active']['array'] ) ) {
		arrayInsertSeq( 'produzione.archivio', $p['produzione.archivio']['etc']['tabs'], 'produzione.archivio.attivita' );
	}

    // tools archivio produzione
	$p['produzione.archivio.attivita'] = array(
		'sitemap'			=> false,
	    'title'				=> array( $l		=> 'produzione archivio attivita' ),
	    'h1'				=> array( $l		=> 'attivita' ),
	    'parent'			=> array( 'id'		=> 'produzione.archivio' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_produzione.archivio.attivita.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'produzione.archivio' )
	);

    // tools archivio produzione
	$p['produzione.archivio.attivita.form'] = array(
		'sitemap'			=> false,
	    'title'				=> array( $l		=> 'produzione archivio attivita form' ),
	    'h1'				=> array( $l		=> 'gestione' ),
	    'parent'			=> array( 'id'		=> 'produzione.archivio.attivita' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'produzione.archivio.attivita.form.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_produzione.archivio.attivita.form.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> array(	'produzione.archivio.attivita.form',
															'produzione.archivio.attivita.form.tools' ) )
	);

    // tools archivio produzione
	$p['produzione.archivio.attivita.form.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni produzione archivio attivita form' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'produzione.archivio.attivita' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_produzione.archivio.attivita.form.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> array(	'produzione.archivio.attivita.form',
															'produzione.archivio.attivita.form.tools' ) )
	);
