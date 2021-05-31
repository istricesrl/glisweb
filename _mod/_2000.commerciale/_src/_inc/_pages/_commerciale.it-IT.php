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
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'commerciale' ),
														'priority'	=> '310' ) ) )	
    );
    
   // vista progetti
	$p['progetti.commerciale.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'progetti' ),
	    'h1'			=> array( $l		=> 'progetti' ),
	    'parent'		=> array( 'id'		=> 'commerciale' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_progetti.commerciale.view.php' ),
		'etc'			=> array( 'tabs'	=> array( 'progetti.commerciale.view' ) ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'progetti' ),
														'priority'	=> '080' ) ) )	
	);

	// gestione progetti
	$p['progetti.commerciale.form'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'gestione' ),
		'h1'			=> array( $l		=> 'gestione' ),
		'parent'		=> array( 'id'		=> 'progetti.commerciale.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.commerciale.form.html' ),
		'macro'			=> array( $m.'_src/_inc/_macro/_progetti.commerciale.form.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'progetti.commerciale.form', 'progetti.commerciale.form.todo' ) )
	);

	// gestione todo progetti
	$p['progetti.commerciale.form.todo'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'todo' ),
	    'h1'			=> array( $l		=> 'to-do' ),
	    'parent'		=> array( 'id'		=> 'progetti.commerciale.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.commerciale.form.todo.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_progetti.commerciale.form.todo.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> $p['progetti.commerciale.form']['etc']['tabs'] )
	);
