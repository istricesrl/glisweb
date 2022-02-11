<?php

    // lingua di questo file
	$l = 'it-IT';

    // pagina principale
	$p['app'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'app' ),
	    'h1'		=> array( $l		=> 'app' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_minerva/', 'schema' => 'app.html' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'macro'		=> array( '_src/_inc/_macro/_app.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'app' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'app' ),
																	'priority'	=> '010' ) ) )
	);
