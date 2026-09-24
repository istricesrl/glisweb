<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_V900.software/';

	// ...
	$p['contratti.form.licenze'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'licenze' ),
		'h1'		=> array( $l		=> 'licenze' ),
		'parent'		=> array( 'id'		=> 'contratti.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'contratti.form.licenze.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_contratti.form.licenze.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['contratti.form']['etc']['tabs'] )
	);
