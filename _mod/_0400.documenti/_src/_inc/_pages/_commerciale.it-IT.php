<?php

	// lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0400.documenti/';

	// RELAZIONI CON IL MODULO COMMERCIALE
	if( in_array( "2000.commerciale", $cf['mods']['active']['array'] ) ) {

		// dashboard commerciale doc. attivi
		$p['commerciale.documenti.attivi'] = array(
			'sitemap'		=> false,
			'title'		=> array( $l		=> 'ciclo attivo' ),
			'h1'		=> array( $l		=> 'ciclo attivo' ),
			'template'	=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'commerciale.documenti.attivi.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_commerciale.documenti.attivi.php' ),
			'parent'	=> array( 'id'		=> 'commerciale' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> array( 'commerciale.documenti.attivi' ) ),
			'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'ciclo attivo' ),
			'priority'	=> '020' ) ) )	
		);

		// dashboard commerciale doc. passivi
		$p['commerciale.documenti.passivi'] = array(
			'sitemap'		=> false,
			'title'		=> array( $l		=> 'ciclo passivo' ),
			'h1'		=> array( $l		=> 'ciclo passivo' ),
			'template'	=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'commerciale.documenti.passivi.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_commerciale.documenti.passivi.php' ),
			'parent'	=> array( 'id'		=> 'commerciale' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> array( 'commerciale.documenti.passivi' ) ),
			'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'ciclo passivo' ),
			'priority'	=> '030' ) ) )	
		);

	}
