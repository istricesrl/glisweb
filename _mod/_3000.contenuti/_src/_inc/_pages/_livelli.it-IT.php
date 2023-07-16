<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_3000.contenuti/';

  	// RELAZIONI CON IL MODULO CORSI
	  if( in_array( "0920.corsi", $cf['mods']['active']['array'] ) ) {

		// form corsi SEM/SMM
		$p['livelli.form.web'] = array(
			'sitemap'		=> false,
			'icon'			=> '<i class="fa fa-chrome" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'web' ),
			'h1'		=> array( $l		=> 'web' ),
			'parent'		=> array( 'id'		=> 'livelli.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'livelli.form.web.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_livelli.form.web.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> 'livelli.form' )
		);

		// form livelli SEM/SMM
		$p['livelli.form.sem'] = array(
			'sitemap'		=> false,
			'icon'			=> '<i class="fa fa-google" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'SEM/SMM' ),
			'h1'		=> array( $l		=> 'SEM/SMM' ),
			'parent'		=> array( 'id'		=> 'livelli.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'livelli.form.sem.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_livelli.form.sem.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> 'livelli.form' )
		);

		// form livelli testo
		$p['livelli.form.testo'] = array(
			'sitemap'		=> false,
			'icon'			=> '<i class="fa fa-file-text-o" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'testo' ),
			'h1'		=> array( $l		=> 'testo' ),
			'parent'		=> array( 'id'		=> 'livelli.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'livelli.form.testo.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_livelli.form.testo.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> 'livelli.form' )
		);

		// gestione categorie menu
		$p['livelli.form.menu'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-bars" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'menu' ),
			'h1'		=> array( $l		=> 'menu' ),
			'parent'		=> array( 'id'		=> 'livelli.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'livelli.form.menu.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_livelli.form.menu.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> $p['livelli.form']['etc']['tabs'] )
		);

	}
