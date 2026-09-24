<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_4110.matricole/';

	// RELAZIONI CON IL MODULO PRODUZIONE
	if( in_array( "1000.produzione", $cf['mods']['active']['array'] ) ) {

		// gestione matricole progetti
		$p['progetti.produzione.form.matricole'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'matricole progetto' ),
			'h1'			=> array( $l		=> 'matricole' ),
			'parent'		=> array( 'id'		=> 'progetti.produzione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.produzione.form.matricole.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_progetti.produzione.form.matricole.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['progetti.produzione.form']['etc']['tabs'] )
		);

		// gestione matricole progetto
		$p['progetti.produzione.matricole.form'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'gestione matricole progetto' ),
			'h1'			=> array( $l		=> 'gestione' ),
			'parent'		=> array( 'id'		=> 'progetti.produzione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.produzione.matricole.form.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_progetti.produzione.matricole.form.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> array(	'progetti.produzione.matricole.form' ) )
		);

	}
