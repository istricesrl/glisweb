<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_1000.produzione/';

	// dashboard produzione
	$p['produzione'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'produzione' ),
	    'h1'			=> array( $l		=> 'produzione' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'produzione.html' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_produzione.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'produzione' ) ),
	    'menu'			=> array( 'admin'	=> array(	'label'		=> array( $l => 'produzione' ),
														'priority'	=> '200' ) )
	);

	// vista progetti
	$p['progetti.produzione.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'progetti' ),
	    'h1'			=> array( $l		=> 'progetti' ),
	    'parent'		=> array( 'id'		=> 'produzione' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_progetti.produzione.view.php' ),
		'etc'			=> array( 'tabs'	=> array( 'progetti.produzione.view', 'progetti.produzione.tools' ) ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'menu'			=> array( 'admin'	=> array(	'label'		=> array( $l => 'progetti' ),
								'priority'	=> '080' ) )
	);

	// gestione progetti
	$p['progetti.produzione.form'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'gestione' ),
	    'h1'			=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'progetti.produzione.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.produzione.form.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_progetti.produzione.form.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'progetti.produzione.form' ) )
	);

	

