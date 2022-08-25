<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_1200.todo/';

	// RELAZIONI CON IL MODULO PROGETTI
	if( in_array( "0900.progetti", $cf['mods']['active']['array'] ) ) {

		// RELAZIONI CON IL MODULO PRODUZIONE
		if( in_array( "1000.produzione", $cf['mods']['active']['array'] ) ) {

			// gestione todo progetti
			$p['progetti.produzione.form.todo'] = array(
				'sitemap'		=> false,
				'title'			=> array( $l		=> 'todo' ),
				'h1'			=> array( $l		=> 'to-do' ),
				'parent'		=> array( 'id'		=> 'progetti.produzione.view' ),
				'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.produzione.form.todo.html' ),
				'macro'			=> array( $m.'_src/_inc/_macro/_progetti.produzione.form.todo.php' ),
				'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
				'etc'			=> array( 'tabs'	=> $p['progetti.produzione.form']['etc']['tabs'] )
			);

		}

	}
