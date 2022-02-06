<?php

	// lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_4110.matricole/';

	// RELAZIONI CON IL MODULO AMMINISTRAZIONE
	if( in_array( "6000.amministrazione", $cf['mods']['active']['array'] ) ) {

		// gestione matricole progetti
		$p['progetti.amministrazione.form.matricole'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'matricole' ),
			'h1'			=> array( $l		=> 'matricole' ),
			'parent'		=> array( 'id'		=> 'progetti.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.amministrazione.form.matricole.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_progetti.amministrazione.form.matricole.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['progetti.amministrazione.form']['etc']['tabs'] )
		);

	}
