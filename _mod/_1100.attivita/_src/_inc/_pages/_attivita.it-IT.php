<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_1100.attivita/';

	// vista attivita
	$p['attivita.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'attivita' ),
	    'h1'			=> array( $l		=> 'attività' ),
	    'parent'		=> array( 'id'		=> 'produzione' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_attivita.view.php' ),
		'etc'			=> array( 'tabs'	=> array(	'attivita.view', 'cartellini' ) ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'menu'			=> array( 'admin'	=> array(	'label'		=> array( $l => 'attività' ),
														'priority'	=> '100' ) )
	);

	// gestione attivita
	$p['attivita.form'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'gestione' ),
	    'h1'			=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'attivita.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'attivita.form.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_attivita.form.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'attivita.form',
														'attivita.form.feedback' ) )
	);

	// gestione attivita - feedback
	$p['attivita.form.feedback'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'feedback' ),
	    'h1'			=> array( $l		=> 'feedback' ),
	    'parent'		=> array( 'id'		=> 'attivita.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'attivita.form.feedback.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_attivita.form.feedback.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> $p['attivita.form']['etc']['tabs'] )
	);



	// vista turni
	$p['turni.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'turni' ),
	    'h1'			=> array( $l		=> 'turni' ),
	    'parent'		=> array( 'id'		=> 'produzione' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_turni.view.php' ),
		'etc'			=> array( 'tabs'	=> array( 'turni.view', 'turni.tools', 'turni.schema' ) ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'menu'			=> array( 'admin'	=> array(	'label'		=> array( $l => 'turni' ),
									'priority'	=> '110' ) )
	);


	// turni tools
	$p['turni.tools'] = array(
	    'sitemap'		=> false,
		'title'			=> array( $l		=> 'pianificazione turni' ),
		'icon'			=> '<i class="fa fa-clock-o" aria-hidden="true"></i>',
	    'h1'			=> array( $l		=> 'pianificazione' ),
	    'parent'		=> array( 'id'		=> 'produzione' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'turni.tools.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_turni.tools.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> $p['turni.view']['etc']['tabs'] )
	);


	// pagina schema
	$p['turni.schema'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'schema' ),
		'h1'			=> array( $l		=> 'schema' ),
		'parent'		=> array( 'id'		=> 'produzione' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'turni.schema.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_turni.schema.php' ),
		'etc'			=> array( 'tabs'	=> $p['turni.view']['etc']['tabs'] ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) )
	);

	// gestione turni
	$p['turni.form'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'gestione' ),
	    'h1'			=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'turni.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'turni.form.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_turni.form.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'turni.form', 'turni.form.pianificazioni' ) )
	);
	
	// gestione turni pianificazioni
	$p['turni.form.pianificazioni'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'pianificazione' ),
		'icon'			=> '<i class="fa fa-clock-o" aria-hidden="true"></i>',
		'h1'			=> array( $l		=> 'pianificazione' ),
		'parent'		=> array( 'id'		=> 'turni.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'turni.form.pianificazioni.html' ),
		'macro'			=> array( $m.'_src/_inc/_macro/_turni.form.pianificazioni.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> $p['turni.form']['etc']['tabs'] )
	);

