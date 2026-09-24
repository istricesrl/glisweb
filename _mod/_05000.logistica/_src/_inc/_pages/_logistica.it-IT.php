<?php

    /**
     * pagine del modulo 05000.logistica
	 * 
	 * Questo file contiene la definizione delle pagine del modulo "logistica".
	 * 
	 * introduzione
	 * ============
	 * Il modulo logistica è un modulo contenitore, che fornisce una dashboard e un archivio con le 
	 * rispettive pagine tools, in modo che altri moduli possano inserirvi le proprie sotto pagine.
	 * 
	 * pagina                           | genitore                  | descrizione
	 * ---------------------------------|---------------------------|---------------------
	 * logistica                  		| NULL                      | dashboard logistica
	 * logistica.tools            		| logistica           		| tools logistica
	 * logistica.archivio         		| logistica           		| archivio logistica
	 * logistica.archivio.tools   		| logistica.archivio  		| tools archivio logistica
	 * 
	 * Il modulo contiene inoltre le pagine per la gestione dei cicli attivo e passivo:
	 * 
	 * pagina                         					| genitore              					| descrizione
	 * -------------------------------------------------|-------------------------------------------|---------------------
	 * logistica.ciclo.attivo 							| logistica      							| dashboard ciclo attivo
	 * logistica.ciclo.attivo.tools 					| logistica.ciclo.attivo 					| tools ciclo attivo
	 * logistica.ciclo.passivo 							| logistica      							| dashboard ciclo passivo
	 * logistica.ciclo.passivo.tools 					| logistica.ciclo.passivo 					| tools ciclo passivo

	 * 
     */

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_05000.logistica/';

	// dashboard logistica
	$p['logistica'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'logistica' ),
	    'h1'			=> array( $l		=> 'logistica' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'template'		=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'logistica.twig' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_logistica.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'logistica',
														'logistica.tools'
														 ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'logistica' ),
																		'priority'	=> '5000' ) ) )														
	);

    // tools della dashboard logistica
	$p['logistica.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'logistica' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_logistica.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'logistica' )
	);

	// archivio logistica
	$p['logistica.archivio'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'archivio logistica' ),
	    'h1'			=> array( $l		=> 'archivio' ),
	    'parent'		=> array( 'id'		=> 'logistica' ),
	    'template'		=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'logistica.archivio.twig' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_logistica.archivio.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'logistica.archivio',
														// 'logistica.archivio.reparti.view',
														'logistica.archivio.tools'
														 ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'archivio' ),
																		'priority'	=> '9900' ) ) )														
	);

	// tools dell'archivio logistica
	$p['logistica.archivio.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'logistica.archivio' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_logistica.archivio.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'logistica.archivio' )
	);

	// dashboard del ciclo attivo della logistica
	$p['logistica.ciclo.attivo'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'logistica ciclo attivo' ),
	    'h1'			=> array( $l		=> 'ciclo attivo' ),
	    'parent'		=> array( 'id'		=> 'logistica' ),
	    'template'		=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'logistica.ciclo.attivo.twig' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_logistica.ciclo.attivo.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'logistica.ciclo.attivo',
														'logistica.ciclo.attivo.tools'
														 ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'ciclo attivo' ),
																		'priority'	=> '1100' ) ) )														
	);

    // tools del ciclo attivo della logistica
	$p['logistica.ciclo.attivo.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni logistica ciclo attivo' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'logistica.ciclo.attivo' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_logistica.ciclo.attivo.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'logistica.ciclo.attivo' )
	);

	// dashboard del ciclo passivo della logistica
	$p['logistica.ciclo.passivo'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'logistica ciclo passivo' ),
	    'h1'			=> array( $l		=> 'ciclo passivo' ),
	    'parent'		=> array( 'id'		=> 'logistica' ),
	    'template'		=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'logistica.ciclo.passivo.twig' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_logistica.ciclo.passivo.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'logistica.ciclo.passivo',
														'logistica.ciclo.passivo.tools'
														 ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'ciclo passivo' ),
																		'priority'	=> '2100' ) ) )														
	);

    // tools del ciclo passivo della logistica
	$p['logistica.ciclo.passivo.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni logistica ciclo passivo' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'logistica.ciclo.passivo' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_logistica.ciclo.passivo.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'logistica.ciclo.passivo' )
	);
