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
	$m = DIR_MOD . '_01000.produzione/';

	// dashboard produzione
	$p['produzione'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'produzione' ),
	    'h1'			=> array( $l		=> 'produzione' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'template'		=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'produzione.twig' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_produzione.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'produzione',
														'produzione.tools'
														 ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'produzione' ),
																		'priority'	=> '1000' ) ) )														
	);

    // tools produzione
	$p['produzione.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'produzione' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_produzione.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'produzione' )
	);

	// dashboard produzione
	$p['produzione.archivio'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'archivio produzione' ),
	    'h1'			=> array( $l		=> 'archivio' ),
	    'parent'		=> array( 'id'		=> 'produzione' ),
	    'template'		=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'produzione.archivio.twig' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_produzione.archivio.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'produzione.archivio',
														'produzione.archivio.tools'
														 ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'archivio' ),
																		'priority'	=> '9900' ) ) )														
	);

    // tools archivio produzione
	$p['produzione.archivio.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'produzione.archivio' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_produzione.archivio.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'produzione.archivio' )
	);

