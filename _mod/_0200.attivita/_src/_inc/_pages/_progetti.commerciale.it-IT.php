<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0200.attivita/';

	// RELAZIONI CON IL MODULO PROGETTI
	if( in_array( "0900.progetti", $cf['mods']['active']['array'] ) ) {

		// RELAZIONI CON IL MODULO COMMERCIALE
		if( in_array( "2000.commerciale", $cf['mods']['active']['array'] ) ) {

			// gestione attivita progetti
			$p['progetti.commerciale.form.attivita'] = array(
				'sitemap'		=> false,
				'icon'			=> '<i class="fa fa-pencil-square-o" aria-hidden="true"></i>',
				'title'			=> array( $l		=> 'attivita' ),
				'h1'			=> array( $l		=> 'to-do' ),
				'parent'		=> array( 'id'		=> 'progetti.commerciale.view' ),
				'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.commerciale.form.attivita.html' ),
				'macro'			=> array( $m.'_src/_inc/_macro/_progetti.commerciale.form.attivita.php' ),
				'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
				'etc'			=> array( 'tabs'	=> 'progetti.commerciale.form' )
			);

		}

	}
