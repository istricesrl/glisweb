<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0630.iscrizioni/';

	// pagina principale
	$p['app.storico.iscrizioni'] = array(
	    'sitemap'		=> false,
	    'cacheable'		=> false,
	    'title'		    => array( $l => 'storico iscrizioni' ),
	    'h1'		    => array( $l => 'le mie iscrizioni' ),
	    'template'		=> array( 'path' => '_src/_tpl/_minerva/', 'schema' => 'app.twig' ),
	    'parent'		=> array( 'id' => NULL ),
	    'macro'		    => array( $m . '_src/_inc/_macro/_account.php' ),
	    'auth'		    => array( 'groups' => array( 'roots', 'staff', 'users' ) ),
		'menu'			=> array( 'main'	=> array(	'' => 	array(	'label'		=> array( $l => 'iscrizioni' ),
																				'priority'	=> '020' ) ) )
	);

    // debug
    // die( print_r( $p['app.storico.iscrizioni'], true ) );
