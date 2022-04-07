<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_3000.contenuti/';

  	// RELAZIONI CON IL MODULO CORSI
	  if( in_array( "0920.corsi", $cf['mods']['active']['array'] ) ) {

		// form corsi SEM/SMM
		$p['corsi.form.sem'] = array(
			'sitemap'		=> false,
			'title'		=> array( $l		=> 'SEM/SMM' ),
			'h1'		=> array( $l		=> 'SEM/SMM' ),
			'parent'		=> array( 'id'		=> 'corsi.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'corsi.form.sem.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_corsi.form.sem.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> $p['corsi.form']['etc']['tabs'] )
		);

		// form corsi testo
		$p['corsi.form.testo'] = array(
			'sitemap'		=> false,
			'title'		=> array( $l		=> 'testo' ),
			'h1'		=> array( $l		=> 'testo' ),
			'parent'		=> array( 'id'		=> 'corsi.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'corsi.form.testo.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_corsi.form.testo.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> $p['corsi.form']['etc']['tabs'] )
		);

	}
