<?php

	// lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0200.attivita/';

	// RELAZIONI CON IL MODULO PROGETTI
	if( in_array( "0900.progetti", $cf['mods']['active']['array'] ) ) {

		// RELAZIONI CON IL MODULO AMMINISTRAZIONE
		if( in_array( "6000.amministrazione", $cf['mods']['active']['array'] ) ) {

			// gestione attività progetti
			$p['progetti.amministrazione.form.attivita'] = array(
				'sitemap'		=> false,
				'icon'			=> '<i class="fa fa-pencil-square-o" aria-hidden="true"></i>',
				'title'			=> array( $l		=> 'attivita' ),
				'h1'			=> array( $l		=> 'attività' ),
				'parent'		=> array( 'id'		=> 'progetti.amministrazione.view' ),
				'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.amministrazione.form.attivita.html' ),
				'macro'			=> array( $m.'_src/_inc/_macro/_progetti.amministrazione.form.attivita.php' ),
				'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
				'etc'			=> array( 'tabs'	=> 'progetti.amministrazione.form' )
			);

		}

	}
