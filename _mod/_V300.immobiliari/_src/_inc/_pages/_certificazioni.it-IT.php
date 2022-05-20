<?php

	// lingua di questo file
	$l = 'it-IT';

	// modulo di questo file
	$m = DIR_MOD . '_V300.immobiliari/';
	$m_v = DIR_MOD . '_6700.certificazioni/';

	// RELAZIONI CON IL MODULO IMMOBILIARI
	if( in_array( "6700.certificazioni", $cf['mods']['active']['array'] ) ) {

	    // form valutazioni immagini
		$p['valutazioni.immobiliari.form.certificazioni'] = array(
			'sitemap'		=> false,
			'title'		=> array( $l		=> 'certificazioni' ),
			'h1'		=> array( $l		=> 'certificazioni' ),
			'parent'		=> array( 'id'		=> 'valutazioni.immobiliari.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'valutazioni.form.certificazioni.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_valutazioni.immobiliari.form.certificazioni.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> 'valutazioni.immobiliari.form' )
		);
		

	
	}


