<?php

	// lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0400.documenti/';

	// RELAZIONI CON IL MODULO AMMINISTRAZIONE
	if( in_array( "6000.amministrazione", $cf['mods']['active']['array'] ) ) {

		// dashboard amministrazione doc. attivi
		$p['amministrazione.documenti.attivi'] = array(
			'sitemap'		=> false,
			'title'		=> array( $l		=> 'ciclo attivo' ),
			'h1'		=> array( $l		=> 'ciclo attivo' ),
			'template'	=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'amministrazione.documenti.attivi.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_amministrazione.documenti.attivi.php' ),
			'parent'	=> array( 'id'		=> 'amministrazione' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> array( 'amministrazione.documenti.attivi' ) ),
			'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'ciclo attivo' ),
			'priority'	=> '020' ) ) )	
		);

		// dashboard amministrazione doc. passivi
		$p['amministrazione.documenti.passivi'] = array(
			'sitemap'		=> false,
			'title'		=> array( $l		=> 'ciclo passivo' ),
			'h1'		=> array( $l		=> 'ciclo passivo' ),
			'template'	=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'amministrazione.documenti.passivi.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_amministrazione.documenti.passivi.php' ),
			'parent'	=> array( 'id'		=> 'amministrazione' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> array( 'amministrazione.documenti.passivi' ) ),
			'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'ciclo passivo' ),
			'priority'	=> '030' ) ) )	
		);

	}
