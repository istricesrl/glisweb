<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
    $m = DIR_MOD . '_2000.commerciale/';
    
    // dashboard commerciale
	$p['commerciale'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'commerciale' ),
	    'h1'		=> array( $l		=> 'commerciale' ),
	    'template'	=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'commerciale.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_commerciale.php' ),
	    'parent'	=> array( 'id'		=> NULL ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> array(	'commerciale' ) ),
	    'menu'		=> array( 'admin'	=> array(	'label'		=> array( $l => 'commerciale' ),
									'priority'	=> '310' ) )
    );
    
    // vista progetti
	$p['progetti.view'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'progetti' ),
	    'h1'		=> array( $l		=> 'progetti' ),
	    'parent'		=> array( 'id'		=> 'commerciale' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_progetti.view.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'progetti.view' ) ),
	    'menu'		=> array( 'admin'	=> array(	'label'		=> array( $l => 'progetti' ),
									'priority'	=> '010' ) )
    );

    // form progetti
	$p['progetti.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'progetti.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.form.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_progetti.form.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'progetti.form'	) )
	);