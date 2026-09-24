<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_1200.todo/';

	// RELAZIONI CON IL MODULO PROGETTI
	if( in_array( "0900.progetti", $cf['mods']['active']['array'] ) ) {

		// RELAZIONI CON IL MODULO PRODUZIONE
		if( in_array( "1000.produzione", $cf['mods']['active']['array'] ) ) {

			// debug
			// print_r( $p['produzione']['etc']['tabs'] );

			// gestione todo progetti
			$p['produzione.backlog'] = array(
				'sitemap'		=> false,
				'title'			=> array( $l		=> 'backlog' ),
				'h1'			=> array( $l		=> 'backlog' ),
				'parent'		=> array( 'id'		=> 'produzione' ),
				'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'produzione.backlog.html' ),
				'macro'			=> array( $m.'_src/_inc/_macro/_produzione.backlog.php' ),
				'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
				'etc'			=> array( 'tabs'	=> $p['produzione']['etc']['tabs'] )
			);

			// gestione todo progetti
			$p['produzione.sprint'] = array(
				'sitemap'		=> false,
				'title'			=> array( $l		=> 'sprint' ),
				'h1'			=> array( $l		=> 'sprint' ),
				'parent'		=> array( 'id'		=> 'produzione' ),
				'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'produzione.sprint.html' ),
				'macro'			=> array( $m.'_src/_inc/_macro/_produzione.sprint.php' ),
				'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
				'etc'			=> array( 'tabs'	=> $p['produzione']['etc']['tabs'] )
			);

			// gestione todo progetti
			$p['produzione.planned'] = array(
				'sitemap'		=> false,
				'title'			=> array( $l		=> 'planned' ),
				'h1'			=> array( $l		=> 'planned' ),
				'parent'		=> array( 'id'		=> 'produzione' ),
				'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'produzione.planned.html' ),
				'macro'			=> array( $m.'_src/_inc/_macro/_produzione.planned.php' ),
				'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
				'etc'			=> array( 'tabs'	=> $p['produzione']['etc']['tabs'] )
			);

			// gestione todo progetti
			$p['produzione.done'] = array(
				'sitemap'		=> false,
				'title'			=> array( $l		=> 'done' ),
				'h1'			=> array( $l		=> 'done' ),
				'parent'		=> array( 'id'		=> 'produzione' ),
				'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'produzione.done.html' ),
				'macro'			=> array( $m.'_src/_inc/_macro/_produzione.done.php' ),
				'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
				'etc'			=> array( 'tabs'	=> $p['produzione']['etc']['tabs'] )
			);

		}

	}
