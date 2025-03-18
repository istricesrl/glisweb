<?php

	// lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0400.documenti/';

    // RELAZIONI CON IL MODULO LOGISTICA
	if( in_array( "5200.missioni", $cf['mods']['active']['array'] ) ) {

		// dashboard logistica doc. attivi
		$p['missioni.view'] = array(
			'sitemap'		=> false,
			'title'		=> array( $l		=> 'missioni' ),
			'h1'		=> array( $l		=> 'missioni' ),
			'template'	=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_missioni.view.php' ),
			'parent'	=> array( 'id'		=> 'logistica' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> array( 'missioni' ) ),
			'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'missioni' ),
			'priority'	=> '120' ) ) )	
		);

    }
