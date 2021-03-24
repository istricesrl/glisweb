<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_1140.variazioni/';

	// vista variazioni
	$p['variazioni.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'variazioni' ),
	    'h1'			=> array( $l		=> 'variazioni' ),
	    'parent'		=> array( 'id'		=> 'produzione' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_variazioni.view.php' ),
		'etc'			=> array( 'tabs'	=> array(	'variazioni.view' ) ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'menu'			=> array( 'admin'	=> array(	'label'		=> array( $l => 'variazioni' ),
														'priority'	=> '115' ) )
	);

    
	// gestione variazioni
	$p['variazioni.form'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'gestione' ),
	    'h1'			=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'variazioni.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'variazioni.form.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_variazioni.form.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'variazioni.form' ) )
	);
    

	