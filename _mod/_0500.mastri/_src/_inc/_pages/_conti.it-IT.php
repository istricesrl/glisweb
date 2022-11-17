<?php

    // modulo di questo file
	$m = DIR_MOD . '_0500.mastri/';

    // RELAZIONI CON IL MODULO PRODUZIONE
	if( in_array( "6000.amministrazione", $cf['mods']['active']['array'] ) ) {

		// vista conti
		$p['conti.view'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'conti' ),
			'h1'			=> array( $l		=> 'conti' ),
			'parent'		=> array( 'id'		=> 'amministrazione' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
			'macro'			=> array( $m . '_src/_inc/_macro/_conti.view.php' ),
			'etc'			=> array( 'tabs'	=> array(	'conti.view' ) ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
#			'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'conti' ),
#															'priority'	=> '230' ) ) )
		);

		// gestione conti
		$p['conti.form'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'gestione' ),
			'h1'			=> array( $l		=> 'gestione' ),
			'parent'		=> array( 'id'		=> 'conti.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'conti.form.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_conti.form.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> array(	'conti.form', 'conti.form.giacenze', 'conti.form.movimenti', 'conti.form.stampe', 'conti.form.tools' ) )
		);

	}
