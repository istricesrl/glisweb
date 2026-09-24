<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_4110.matricole/';

	// RELAZIONI CON IL MODULO COMMERCIALE
	if( in_array( "2000.commerciale", $cf['mods']['active']['array'] ) ) {

		// gestione matricole progetti
		$p['progetti.commerciale.form.matricole'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'matricole' ),
			'h1'			=> array( $l		=> 'matricole' ),
			'parent'		=> array( 'id'		=> 'progetti.commerciale.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.commerciale.form.matricole.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_progetti.commerciale.form.matricole.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['progetti.commerciale.form']['etc']['tabs'] )
		);

	}
