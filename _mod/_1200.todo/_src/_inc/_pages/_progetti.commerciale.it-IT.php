<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_1200.todo/';

	// RELAZIONI CON IL MODULO PROGETTI
	if( in_array( "0900.progetti", $cf['mods']['active']['array'] ) ) {

		// RELAZIONI CON IL MODULO COMMERCIALE
		if( in_array( "2000.commerciale", $cf['mods']['active']['array'] ) ) {

			// gestione todo progetti
			$p['progetti.commerciale.form.todo'] = array(
				'sitemap'		=> false,
				'title'			=> array( $l		=> 'todo' ),
				'h1'			=> array( $l		=> 'to-do' ),
				'parent'		=> array( 'id'		=> 'progetti.commerciale.view' ),
				'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.commerciale.form.todo.html' ),
				'macro'			=> array( $m.'_src/_inc/_macro/_progetti.commerciale.form.todo.php' ),
				'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
				'etc'			=> array( 'tabs'	=> $p['progetti.commerciale.form']['etc']['tabs'] )
			);

		}

	}
