<?php

    // lingua di questo file
	$l = 'it-IT';

    // pagina degli strumenti
	$p['strumenti'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'strumenti' ),
	    'h1'		=> array( $l		=> 'strumenti' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'strumenti.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_strumenti.php' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'strumenti' ) ),
	    'menu'		=> array( 'admin'	=> array(	'label'		=> array( $l => 'strumenti' ),
									'priority'	=> '950' ) )
	);
