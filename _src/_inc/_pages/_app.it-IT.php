<?php

    // lingua di questo file
	$l = 'it-IT';

    // pagina principale
	$p['app'] = array(
	    'sitemap'		=> false,
	    'cacheable'		=> false,
	    'title'		=> array( $l		=> 'app' ),
	    'h1'		=> array( $l		=> 'home' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_minerva/', 'schema' => 'app.html' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'macro'		=> array( '_src/_inc/_macro/_app.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'menu'				=> array( 'app'	=> array(	'' => 	array(	'label'		=> array( $l => 'home' ),
																	'priority'	=> '010' ) ) )
	);

	// pagina principale
	$p['account'] = array(
	    'sitemap'		=> false,
	    'cacheable'		=> false,
	    'title'		=> array( $l		=> 'account' ),
	    'h1'		=> array( $l		=> 'i tuoi dati' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_minerva/', 'schema' => 'account.html' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_account.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) )
	);

