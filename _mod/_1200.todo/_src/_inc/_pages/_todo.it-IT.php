<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_1200.todo/';

	// vista todo
	$p['todo.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'todo' ),
	    'h1'			=> array( $l		=> 'to-do' ),
	    'parent'		=> array( 'id'		=> 'produzione' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_todo.view.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'todo.view' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'to-do' ),
														'priority'	=> '090' ) ) )	
	);

	// gestione todo
	$p['todo.form'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'gestione' ),
	    'h1'			=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'todo.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'todo.form.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_todo.form.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'todo.form', 
														'todo.form.attivita',
														'todo.form.documenti',
														'todo.form.pianificazioni' ) )
	);

	$p['todo.form.attivita'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'attivita' ),
	    'h1'			=> array( $l		=> 'attivita' ),
	    'parent'		=> array( 'id'		=> 'todo.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'todo.form.attivita.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_todo.form.attivita.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> $p['todo.form']['etc']['tabs'] )
	);

	$p['todo.form.documenti'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'documenti' ),
	    'h1'			=> array( $l		=> 'documenti' ),
	    'parent'		=> array( 'id'		=> 'todo.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'todo.form.documenti.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_todo.form.documenti.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> $p['todo.form']['etc']['tabs'] )
	);

	// gestione todo pianificazioni
	$p['todo.form.pianificazioni'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'pianificazione' ),
		'icon'			=> '<i class="fa fa-clock-o" aria-hidden="true"></i>',
		'h1'			=> array( $l		=> 'pianificazione' ),
		'parent'		=> array( 'id'		=> 'todo.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'todo.form.pianificazioni.html' ),
		'macro'			=> array( $m.'_src/_inc/_macro/_todo.form.pianificazioni.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> $p['todo.form']['etc']['tabs'] )
	);
