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
			$p['progetti.produzione.form.backlog'] = array(
				'sitemap'		=> false,
				'title'			=> array( $l		=> 'backlog' ),
				'h1'			=> array( $l		=> 'backlog' ),
				'parent'		=> array( 'id'		=> 'progetti.produzione.view' ),
				'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.produzione.form.backlog.html' ),
				'macro'			=> array( $m.'_src/_inc/_macro/_progetti.produzione.form.backlog.php' ),
				'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
				'etc'			=> array( 'tabs'	=> $p['progetti.produzione.form']['etc']['tabs'] )
			);

			// gestione todo progetti
			$p['progetti.produzione.form.sprint'] = array(
				'sitemap'		=> false,
				'title'			=> array( $l		=> 'sprint' ),
				'h1'			=> array( $l		=> 'sprint' ),
				'parent'		=> array( 'id'		=> 'progetti.produzione.view' ),
				'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.produzione.form.sprint.html' ),
				'macro'			=> array( $m.'_src/_inc/_macro/_progetti.produzione.form.sprint.php' ),
				'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
				'etc'			=> array( 'tabs'	=> $p['progetti.produzione.form']['etc']['tabs'] )
			);

			// gestione todo progetti
			$p['progetti.produzione.form.planned'] = array(
				'sitemap'		=> false,
				'title'			=> array( $l		=> 'planned' ),
				'h1'			=> array( $l		=> 'planned' ),
				'parent'		=> array( 'id'		=> 'progetti.produzione.view' ),
				'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.produzione.form.planned.html' ),
				'macro'			=> array( $m.'_src/_inc/_macro/_progetti.produzione.form.planned.php' ),
				'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
				'etc'			=> array( 'tabs'	=> $p['progetti.produzione.form']['etc']['tabs'] )
			);

			// gestione todo progetti
			$p['progetti.produzione.form.done'] = array(
				'sitemap'		=> false,
				'title'			=> array( $l		=> 'done' ),
				'h1'			=> array( $l		=> 'done' ),
				'parent'		=> array( 'id'		=> 'progetti.produzione.view' ),
				'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.produzione.form.done.html' ),
				'macro'			=> array( $m.'_src/_inc/_macro/_progetti.produzione.form.done.php' ),
				'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
				'etc'			=> array( 'tabs'	=> $p['progetti.produzione.form']['etc']['tabs'] )
			);

		}

	}
