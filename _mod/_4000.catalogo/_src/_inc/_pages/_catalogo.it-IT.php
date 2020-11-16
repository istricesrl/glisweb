<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_4000.catalogo/';

    // dashboard del modulo
	$p['catalogo'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'catalogo' ),
	    'h1'		=> array( $l		=> 'catalogo' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'catalogo.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_catalogo.php' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'menu'		=> array( 'admin'	=> array(	'label'		=> array( $l => 'catalogo' ),
									'priority'	=> '650' ) )
	);

    // debug
	// die( print_r( $p ) );

?>
