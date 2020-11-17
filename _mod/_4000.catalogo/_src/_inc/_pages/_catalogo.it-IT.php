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
		'etc'		=> array( 'tabs'	=> array(	'catalogo' ) ),
	    'menu'		=> array( 'admin'	=> array(	'label'		=> array( $l => 'catalogo' ),
									'priority'	=> '650' ) )
	);

	 // vista categorie prodotti
	 $p['categorie.view'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'categorie' ),
	    'h1'		=> array( $l		=> 'categorie' ),
	    'parent'		=> array( 'id'		=> 'catalogo' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_categorie.view.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'categorie.view') ),
	    'menu'		=> array( 'admin'	=> array(	'label'		=> array( $l => 'categorie' ),
									'priority'	=> '010' ) )
	);
	
    // gestione categorie prodotti
	$p['categorie.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'categorie.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.form.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_categorie.form.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'categorie.form',
												//	'categorie.form.sem'
												'categorie.form.immagini',
												'categorie.form.video',
												'categorie.form.audio',
												'categorie.form.file',
												'categorie.form.metadati',
												'categorie.form.gruppi'
												) )
	);

    // debug
	// die( print_r( $p ) );

?>
