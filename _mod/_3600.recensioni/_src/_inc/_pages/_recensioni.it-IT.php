<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_3600.recensioni/';

    if ( in_array( "3000.contenuti", $cf['mods']['active']['array'] ) ) {

		// vista recensioni
		$p['recensioni.view'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'recensioni' ),
			'h1'			=> array( $l		=> 'recensioni' ),
			'parent'		=> array( 'id'		=> 'contenuti' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
			'macro'			=> array( $m . '_src/_inc/_macro/_recensioni.view.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> array(	'recensioni.view' ) ),
			'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'recensioni' ),
															'priority'	=> '010' ) ) )	
		);

		// form recensioni
		$p['recensioni.form'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'gestione' ),
			'h1'			=> array( $l		=> 'gestione' ),
			'parent'		=> array( 'id'		=> 'recensioni.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'recensioni.form.html' ),
			'macro'			=> array( $m . '_src/_inc/_macro/_recensioni.form.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> array(	'recensioni.form' ) )
		);
		
	}
