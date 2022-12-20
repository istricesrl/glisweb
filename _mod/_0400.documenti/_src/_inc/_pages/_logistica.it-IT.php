<?php

	// lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0400.documenti/';

	// dashboard logistica doc. attivi
	$p['logistica.documenti.attivi'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'ciclo attivo' ),
	    'h1'		=> array( $l		=> 'ciclo attivo' ),
	    'template'	=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'logistica.documenti.attivi.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_logistica.documenti.attivi.php' ),
	    'parent'	=> array( 'id'		=> 'logistica' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> array( 'logistica.documenti.attivi' ) ),
		'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'ciclo attivo' ),
		'priority'	=> '020' ) ) )	
	);

	// dashboard logistica doc. passivi
	$p['logistica.documenti.passivi'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'ciclo passivo' ),
	    'h1'		=> array( $l		=> 'ciclo passivo' ),
	    'template'	=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'logistica.documenti.passivi.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_logistica.documenti.passivi.php' ),
	    'parent'	=> array( 'id'		=> 'logistica' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> array( 'logistica.documenti.passivi' ) ),
		'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'ciclo passivo' ),
		'priority'	=> '030' ) ) )	
	);
