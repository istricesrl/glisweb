<?php

    // modulo di questo file
	$m = DIR_MOD . '_0500.mastri/';
/*
    // RELAZIONI CON IL MODULO PRODUZIONE
	if( in_array( "1000.produzione", $cf['mods']['active']['array'] ) ) {

		// vista registri
		$p['registri.view'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'registri' ),
			'h1'			=> array( $l		=> 'registri' ),
			'parent'		=> array( 'id'		=> 'produzione' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
			'macro'			=> array( $m . '_src/_inc/_macro/_registri.view.php' ),
			'etc'			=> array( 'tabs'	=> array(	'registri.view' ) ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'registri' ),
															'priority'	=> '230' ) ) )
		);

		// gestione registri
		$p['registri.form'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'gestione' ),
			'h1'			=> array( $l		=> 'gestione' ),
			'parent'		=> array( 'id'		=> 'registri.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'registri.form.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_registri.form.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> array(	'registri.form', 'registri.form.giacenze', 'registri.form.movimenti', 'registri.form.stampe', 'registri.form.tools' ) )
		);

	}
*/