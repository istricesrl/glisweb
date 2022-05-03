<?php

	// lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0600.contratti/';

	// RELAZIONI CON IL MODULO IMMOBILIARI
	if( in_array( "V300.immobiliari", $cf['mods']['active']['array'] ) ) {

		// gestione contratti
		$p['immobili.form.contratti'] = array(
			'sitemap'		=> false,
			'title'		=> array( $l		=> 'contratti' ),
			'h1'		=> array( $l		=> 'contratti' ),
			'parent'		=> array( 'id'		=> 'immobili.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'immobili.form.contratti.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_immobili.form.contratti.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> 'immobili.form' )
		);

	}
