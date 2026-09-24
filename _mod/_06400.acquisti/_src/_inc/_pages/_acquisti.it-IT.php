<?php

    /**
     * pagine del modulo 06400.acquisti
	 * 
	 * Questo file contiene la definizione delle pagine del modulo "acquisti".
	 * 
	 * introduzione
	 * ============
	 * Il modulo acquisti è un modulo contenitore, che fornisce una dashboard e un archivio con le 
	 * rispettive pagine tools, in modo che altri moduli possano inserirvi le proprie sotto pagine.
	 * 
	 * pagina                           | genitore                  | descrizione
	 * ---------------------------------|---------------------------|---------------------
	 * acquisti                  		| NULL                      | dashboard acquisti
	 * acquisti.tools            		| acquisti           		| tools acquisti
	 * acquisti.archivio         		| acquisti           		| archivio acquisti
	 * acquisti.archivio.tools   		| acquisti.archivio  		| tools archivio acquisti
	 * 
     */

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_06400.acquisti/';

	// dashboard acquisti
	$p['acquisti'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'acquisti' ),
	    'h1'			=> array( $l		=> 'acquisti' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'template'		=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'acquisti.twig' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_acquisti.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'acquisti',
														'acquisti.tools'
														 ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'acquisti' ),
																		'priority'	=> '6400' ) ) )														
	);

    // tools della dashboard acquisti
	$p['acquisti.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'acquisti' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_acquisti.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'acquisti' )
	);

	// archivio acquisti
	$p['acquisti.archivio'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'archivio acquisti' ),
	    'h1'			=> array( $l		=> 'archivio' ),
	    'parent'		=> array( 'id'		=> 'acquisti' ),
	    'template'		=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'acquisti.archivio.twig' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_acquisti.archivio.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'acquisti.archivio',
														// 'acquisti.archivio.reparti.view',
														'acquisti.archivio.tools'
														 ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'archivio' ),
																		'priority'	=> '9900' ) ) )														
	);

	// tools dell'archivio acquisti
	$p['acquisti.archivio.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'acquisti.archivio' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_acquisti.archivio.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'acquisti.archivio' )
	);
