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
	    'parent'		=> array( 'id'		=> 'produzione' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_task.view.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'task.view' ) ),
	    'menu'			=> array( 'admin'	=> array(	'label'		=> array( $l => 'task' ),
														'priority'	=> '090' ) )
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
		'etc'			=> array( 'tabs'	=> array(	'task.form', 
														'task.form.attivita',
														'task.form.pianificazioni' ) )
	);

	$p['task.form.attivita'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'attivita' ),
	    'h1'			=> array( $l		=> 'attivita' ),
	    'parent'		=> array( 'id'		=> 'task.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'task.form.attivita.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_task.form.attivita.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> $p['task.form']['etc']['tabs'] )
	);

	// gestione task pianificazioni
	$p['task.form.pianificazioni'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'pianificazione' ),
		'icon'			=> '<i class="fa fa-clock-o" aria-hidden="true"></i>',
		'h1'			=> array( $l		=> 'pianificazione' ),
		'parent'		=> array( 'id'		=> 'task.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'task.form.pianificazioni.html' ),
		'macro'			=> array( $m.'_src/_inc/_macro/_task.form.pianificazioni.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> $p['task.form']['etc']['tabs'] )
	);
