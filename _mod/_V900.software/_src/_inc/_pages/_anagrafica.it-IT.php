<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_V900.software/';

	// ...
	$p['anagrafica.form.licenze'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'licenze' ),
		'h1'		=> array( $l		=> 'licenze' ),
		'parent'		=> array( 'id'		=> 'anagrafica.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'anagrafica.form.licenze.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_anagrafica.form.licenze.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['anagrafica.form']['etc']['tabs'] )
	);
