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
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff', 'users' ) ),
		'menu'				=> array( 'app'	=> array(	'' => 	array(	'label'		=> array( $l => 'home' ),
																	'priority'	=> '010' ) ) )
	);

	// pagina principale
	$p['app.account'] = array(
	    'sitemap'		=> false,
	    'cacheable'		=> false,
	    'title'		=> array( $l		=> 'account' ),
	    'h1'		=> array( $l		=> 'il tuo account' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_minerva/', 'schema' => 'account.html' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'macro'		=> array( '_src/_inc/_macro/_account.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff', 'users' ) ),
		'menu'			=> array( 'app-icons'	=> array(	'' => 	array(	'label'		=> array( $l => '<i class="fa fa-user" aria-hidden="true"></i>' ), 'priority'	=> '900', 'visualizza' => SHOW_ALWAYS ) ) )
	);

