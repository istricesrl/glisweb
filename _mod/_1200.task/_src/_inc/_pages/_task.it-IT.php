<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_1200.task/';

	// vista task
	$p['task.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'task' ),
	    'h1'			=> array( $l		=> 'task' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_task.view.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'menu'			=> array( 'admin'	=> array(	'label'		=> array( $l => 'task' ),
														'priority'	=> '100' ) )
	);

	// gestione task
	$p['task.form'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'gestione' ),
	    'h1'			=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'task.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'task.form.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_task.form.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'			=> array( 'tabs'	=> array(	'task.form' ) )
	);

