<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_3000.contenuti/';

  	// RELAZIONI CON IL MODULO CORSI
	  if( in_array( "0920.corsi", $cf['mods']['active']['array'] ) ) {

		// form corsi SEM/SMM
		$p['discipline.form.web'] = array(
			'sitemap'		=> false,
			'icon'			=> '<i class="fa fa-chrome" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'web' ),
			'h1'		=> array( $l		=> 'web' ),
			'parent'		=> array( 'id'		=> 'discipline.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'discipline.form.web.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_discipline.form.web.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> 'discipline.form' )
		);

		// form discipline SEM/SMM
		$p['discipline.form.sem'] = array(
			'sitemap'		=> false,
			'icon'			=> '<i class="fa fa-google" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'SEM/SMM' ),
			'h1'		=> array( $l		=> 'SEM/SMM' ),
			'parent'		=> array( 'id'		=> 'discipline.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'discipline.form.sem.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_discipline.form.sem.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> 'discipline.form' )
		);

		// form discipline testo
		$p['discipline.form.testo'] = array(
			'sitemap'		=> false,
			'icon'			=> '<i class="fa fa-file-text-o" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'testo' ),
			'h1'		=> array( $l		=> 'testo' ),
			'parent'		=> array( 'id'		=> 'discipline.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'discipline.form.testo.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_discipline.form.testo.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> 'discipline.form' )
		);

		// gestione categorie menu
		$p['discipline.form.menu'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-bars" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'menu' ),
			'h1'		=> array( $l		=> 'menu' ),
			'parent'		=> array( 'id'		=> 'discipline.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'discipline.form.menu.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_discipline.form.menu.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> $p['discipline.form']['etc']['tabs'] )
		);

	}
