<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_3000.contenuti/';

  	// RELAZIONI CON IL MODULO CORSI
	  if( in_array( "0920.corsi", $cf['mods']['active']['array'] ) ) {

		// form corsi SEM/SMM
		$p['fasce.form.web'] = array(
			'sitemap'		=> false,
			'icon'			=> '<i class="fa fa-chrome" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'web' ),
			'h1'		=> array( $l		=> 'web' ),
			'parent'		=> array( 'id'		=> 'fasce.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'fasce.form.web.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_fasce.form.web.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> 'fasce.form' )
		);

		// form fasce SEM/SMM
		$p['fasce.form.sem'] = array(
			'sitemap'		=> false,
			'icon'			=> '<i class="fa fa-google" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'SEM/SMM' ),
			'h1'		=> array( $l		=> 'SEM/SMM' ),
			'parent'		=> array( 'id'		=> 'fasce.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'fasce.form.sem.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_fasce.form.sem.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> 'fasce.form' )
		);

		// form fasce testo
		$p['fasce.form.testo'] = array(
			'sitemap'		=> false,
			'icon'			=> '<i class="fa fa-file-text-o" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'testo' ),
			'h1'		=> array( $l		=> 'testo' ),
			'parent'		=> array( 'id'		=> 'fasce.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'fasce.form.testo.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_fasce.form.testo.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> 'fasce.form' )
		);

		// gestione categorie menu
		$p['fasce.form.menu'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-bars" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'menu' ),
			'h1'		=> array( $l		=> 'menu' ),
			'parent'		=> array( 'id'		=> 'fasce.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'fasce.form.menu.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_fasce.form.menu.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> $p['fasce.form']['etc']['tabs'] )
		);

	}
