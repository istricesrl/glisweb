<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_6500.casse/';

    // pagina degli strumenti
	$p['cassa'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'cassa' ),
	    'h1'		=> array( $l		=> 'cassa' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'cassa.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_cassa.php' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'cassa' ) ),
	    'menu'		=> array( 'admin'	=> array(	'label'		=> array( $l => 'cassa' ),
									'priority'	=> 650 ) )
	);

    // terminale della cassa
	$p['terminale'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'terminale' ),
	    'h1'		=> array( $l		=> 'terminale' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'terminale.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_terminale.php' ),
	    'parent'		=> array( 'id'		=> 'cassa' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'menu'		=> array( 'admin'	=> array(	'label'		=> array( $l => 'terminale' ),
									'priority'	=> 100 ) )
	);

    // debug
	// die( print_r( $p ) );

?>
