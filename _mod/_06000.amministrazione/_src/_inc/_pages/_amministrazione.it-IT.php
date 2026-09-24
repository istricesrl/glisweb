<?php

    /**
     * pagine del modulo 06000.amministrazione
	 * 
	 * Questo file contiene la definizione delle pagine del modulo "amministrazione".
	 * 
	 * introduzione
	 * ============
	 * Il modulo amministrazione è un modulo contenitore, che fornisce una dashboard e un archivio con le 
	 * rispettive pagine tools, in modo che altri moduli possano inserirvi le proprie sotto pagine.
	 * 
	 * pagina                           | genitore                  | descrizione
	 * ---------------------------------|---------------------------|---------------------
	 * amministrazione                  | NULL                      | dashboard amministrazione
	 * amministrazione.tools            | amministrazione           | tools amministrazione
	 * amministrazione.archivio         | amministrazione           | archivio amministrazione
	 * amministrazione.archivio.tools   | amministrazione.archivio  | tools archivio amministrazione
	 * 
	 * Il modulo contiene inoltre le pagine di gestione dei reparti:
	 * 
	 * pagina                         					| genitore              					| descrizione
	 * -------------------------------------------------|-------------------------------------------|---------------------
	 * amministrazione.archivio.reparti.view 			| amministrazione.archivio      			| vista reparti
	 * amministrazione.archivio.reparti.form 			| amministrazione.archivio      			| form reparti
	 * amministrazione.archivio.reparti.form.tools 		| amministrazione.archivio     				| tools form reparti
	 * 
	 * Infine il modulo prevede le pagine per la gestione dei cicli attivo e passivo:
	 * 
	 * pagina                         					| genitore              					| descrizione
	 * -------------------------------------------------|-------------------------------------------|---------------------
	 * amministrazione.ciclo.attivo 					| amministrazione      						| dashboard ciclo attivo
	 * amministrazione.ciclo.attivo.tools 				| amministrazione.ciclo.attivo 				| tools ciclo attivo
	 * amministrazione.ciclo.passivo 					| amministrazione      						| dashboard ciclo passivo
	 * amministrazione.ciclo.passivo.tools 				| amministrazione.ciclo.passivo 			| tools ciclo passivo

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
														'amministrazione.stampe',
														'amministrazione.tools'
														 ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'amministrazione' ),
																		'priority'	=> '6000' ) ) )														
	);

    // amministrazione stampe
    $p['amministrazione.stampe'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-print" aria-hidden="true"></i>',
        'title'                => array( $l        => 'amministrazione stampe' ),
        'h1'                => array( $l        => 'stampe' ),
        'parent'            => array( 'id'        => 'amministrazione' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_amministrazione.stampe.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'amministrazione' )
    );

    // tools della dashboard amministrazione
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

	// archivio amministrazione
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

    // vista dell'archivio reparti
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

	// form di gestione reparto
	$p['amministrazione.archivio.reparti.form'] = array(
		'sitemap'			=> false,
	    'title'				=> array( $l		=> 'gestione reparto' ),
	    'h1'				=> array( $l		=> 'gestione' ),
	    'parent'			=> array( 'id'		=> 'amministrazione.archivio' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.form.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_amministrazione.archivio.reparti.form.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> array(
														'amministrazione.archivio.reparti.form'
		) )
	);

	// tools della gestione reparto
	$p['amministrazione.archivio.reparti.form.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni gestione reparto' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'amministrazione.archivio' ),
	    'template'			=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_amministrazione.archivio.reparti.form.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'amministrazione.archivio.reparti.form' )
	);

	// tools dell'archivio amministrazione
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

	// dashboard del ciclo attivo dell'amministrazione
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

    // tools del ciclo attivo dell'amministrazione
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

	// dashboard del ciclo passivo dell'amministrazione
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

    // tools del ciclo passivo dell'amministrazione
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
