<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_4130.distinte/';

	// RELAZIONI CON IL MODULO PRODOTTI
	if( in_array( "4100.prodotti", $cf['mods']['active']['array'] ) ){

		// inserimento della tab 'distinta' nelle pagine di form articoli
		arrayInsertSeq( 'articoli.form.relazioni', $p['articoli.form']['etc']['tabs'], 'articoli.form.distinta' );

		foreach( $p['articoli.form']['etc']['tabs'] as $t ){
			$p[ $t ]['etc']['tabs'] = $p['articoli.form']['etc']['tabs'];
		}

		// gestione distinta base articoli
		$p['articoli.form.distinta'] = array(
			'sitemap'		=> false,
			'title'		=> array( $l		=> 'distinta base' ),
			'h1'		=> array( $l		=> 'distinta base' ),
			'parent'		=> array( 'id'		=> 'articoli.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'articoli.form.distinta.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_articoli.form.distinta.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> $p['articoli.form']['etc']['tabs'] )
		);

	}
