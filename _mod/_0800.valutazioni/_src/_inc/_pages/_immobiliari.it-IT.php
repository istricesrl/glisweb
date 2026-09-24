<?php
/*
	// lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0800.valutazioni/';

	// RELAZIONI CON IL MODULO IMMOBILIARI
	if( in_array( "V300.immobiliari", $cf['mods']['active']['array'] ) ) {

		// gestione valutazioni
		$p['immobili.form.valutazioni'] = array(
			'sitemap'		=> false,
			'title'		=> array( $l		=> 'valutazioni' ),
			'h1'		=> array( $l		=> 'valutazioni' ),
			'parent'		=> array( 'id'		=> 'immobili.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'immobili.form.valutazioni.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_immobili.form.valutazioni.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> 'immobili.form' )
		);

		// vista immobili
		$p['immobili.valutazioni.view'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'valutazioni' ),
			'h1'			=> array( $l		=> 'valutazioni' ),
			'parent'		=> array( 'id'		=> 'immobiliari' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
			'macro'			=> array( $m . '_src/_inc/_macro/_immobili.valutazioni.view.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots' ) ),
			'etc'			=> array( 'tabs'	=>  'immobili.view' )
    	);

	}
*/