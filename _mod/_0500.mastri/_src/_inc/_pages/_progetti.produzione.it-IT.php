<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0500.mastri/';

	// RELAZIONI CON IL MODULO PROGETTI
	if( in_array( "0900.progetti", $cf['mods']['active']['array'] ) ) {

		// RELAZIONI CON IL MODULO PRODUZIONE
		if( in_array( "1000.produzione", $cf['mods']['active']['array'] ) ) {

			// gestione attività progetti
			$p['progetti.produzione.form.mastri'] = array(
				'sitemap'		=> false,
				'icon'			=> '<i class="fa fa-book" aria-hidden="true"></i>',
				'title'			=> array( $l		=> 'mastri' ),
				'h1'			=> array( $l		=> 'mastri' ),
				'parent'		=> array( 'id'		=> 'progetti.produzione.view' ),
				'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.produzione.form.mastri.html' ),
				'macro'			=> array( $m.'_src/_inc/_macro/_progetti.produzione.form.mastri.php' ),
				'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
				'etc'			=> array( 'tabs'	=> 'progetti.produzione.form' )
			);

		}

	}
