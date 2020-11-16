<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_6500.casse/';

    // dashboard del modulo
	$p['cassa'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'cassa' ),
	    'h1'		=> array( $l		=> 'cassa' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'casse.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_casse.php' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'menu'		=> array( 'admin'	=> array(	'label'		=> array( $l => 'cassa' ),
									'priority'	=> '650' ) )
	);

    // debug
	// die( print_r( $p ) );

?>
