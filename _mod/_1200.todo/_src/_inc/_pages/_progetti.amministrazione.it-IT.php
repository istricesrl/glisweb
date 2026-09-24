<?php

	// lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_1200.todo/';

	// RELAZIONI CON IL MODULO PROGETTI
	if( in_array( "0900.progetti", $cf['mods']['active']['array'] ) ) {

		// RELAZIONI CON IL MODULO AMMINISTRAZIONE
		if( in_array( "6000.amministrazione", $cf['mods']['active']['array'] ) ) {

			// gestione todo progetti
			$p['progetti.amministrazione.form.todo'] = array(
				'sitemap'		=> false,
				'icon'			=> '<i class="fa fa-tasks" aria-hidden="true"></i>',
				'title'			=> array( $l		=> 'todo progetto amministrativo' ),
				'h1'			=> array( $l		=> 'to-do' ),
				'parent'		=> array( 'id'		=> 'progetti.amministrazione.view' ),
				'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.amministrazione.form.todo.html' ),
				'macro'			=> array( $m.'_src/_inc/_macro/_progetti.amministrazione.form.todo.php' ),
				'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
				'etc'			=> array( 'tabs'	=> $p['progetti.amministrazione.form']['etc']['tabs'] )
			);

		}

	}
