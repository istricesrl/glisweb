<?php

	// lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_6000.amministrazione/';

	// dashboard amministrazione
	$p['amministrazione'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'amministrazione' ),
	    'h1'			=> array( $l		=> 'amministrazione' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'amministrazione.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_amministrazione.php' ),
		'etc'			=> array( 'tabs'	=> array(	'amministrazione' ) ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'amministrazione' ),
														'priority'	=> '320' ) ) )
	);

   // vista proforma
   $p['proforma.amministrazione.view'] = array(
	'sitemap'		=> false,
	'title'			=> array( $l		=> 'proforma' ),
	'h1'			=> array( $l		=> 'proforma' ),
	'parent'		=> array( 'id'		=> 'amministrazione' ),
	'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	'macro'			=> array( $m . '_src/_inc/_macro/_proforma.amministrazione.view.php' ),
	'etc'			=> array( 'tabs'	=> array(   'proforma.amministrazione.view' ) ),
	'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'proforma' ),
													'priority'	=> '010' ) ) )	
	);

	// gestione proforma
	$p['proforma.amministrazione.form'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'gestione' ),
		'h1'			=> array( $l		=> 'gestione' ),
		'parent'		=> array( 'id'		=> 'proforma.amministrazione.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'proforma.amministrazione.form.html' ),
		'macro'			=> array( $m.'_src/_inc/_macro/_proforma.amministrazione.form.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'proforma.amministrazione.form' ) )
	);

	// vista fatture
	$p['fatture.amministrazione.view'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'fatture' ),
		'h1'			=> array( $l		=> 'fatture' ),
		'parent'		=> array( 'id'		=> 'amministrazione' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_fatture.amministrazione.view.php' ),
		'etc'			=> array( 'tabs'	=> array(   'fatture.amministrazione.view' ) ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'fatture' ),
														'priority'	=> '020' ) ) )	
	);

	// gestione fatture
	$p['fatture.amministrazione.form'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'gestione' ),
		'h1'			=> array( $l		=> 'gestione' ),
		'parent'		=> array( 'id'		=> 'fatture.amministrazione.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'fatture.amministrazione.form.html' ),
		'macro'			=> array( $m.'_src/_inc/_macro/_fatture.amministrazione.form.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'fatture.amministrazione.form' ) )
	);