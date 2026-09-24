<?php

    // lingua di questo file
	$l = 'it-IT';
	$m = '_mod/_4170.ecommerce/';

	// vista pagamenti
	$p['ecommerce.scadenziario.carrelli'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'scadenziario carrelli' ),
		'h1'			=> array( $l		=> 'scadenziario carrelli' ),
		'parent'		=> array( 'id'		=> 'amministrazione' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_ecommerce.scadenziario.carrelli.php' ),
		'etc'			=> array( 'tabs'	=> 'pagamenti.amministrazione.view' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) )
	);
