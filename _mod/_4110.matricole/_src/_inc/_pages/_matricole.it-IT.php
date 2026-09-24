<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_4110.matricole/';

	// vista matricole
	$p['matricole.view'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'matricole' ),
	    'h1'		=> array( $l		=> 'matricole' ),
	    'parent'		=> array( 'id'		=> 'catalogo' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_matricole.view.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'matricole.view', 'matricole.stampe') ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'matricole' ),
									'priority'	=> '025' ) ) )	
	);

	// gestione stampe matricole
	$p['matricole.stampe'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-print" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'stampe' ),
	    'h1'		=> array( $l		=> 'stampe' ),
	    'parent'		=> array( 'id'		=> 'matricole.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_matricole.stampe.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['matricole.view']['etc']['tabs'] )
	);

    // gestione matricole
	$p['matricole.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'matricole.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'matricole.form.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_matricole.form.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'matricole.form',
													'matricole.form.stampe',
													'matricole.form.metadati'
												) )
	);

	// gestione stampe matricole
	$p['matricole.form.stampe'] = array(
	    'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-print" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'stampe matricola' ),
	    'h1'				=> array( $l		=> 'stampe matricola' ),
	    'parent'			=> array( 'id'		=> 'matricole.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_matricole.form.stampe.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['matricole.form']['etc']['tabs'] )
	);

	// gestione metadati matricole
	$p['matricole.form.metadati'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-code" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'metadati' ),
		'h1'		=> array( $l		=> 'metadati' ),
		'parent'		=> array( 'id'		=> 'matricole.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'matricole.form.metadati.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_matricole.form.metadati.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> $p['matricole.form']['etc']['tabs'] )
	);
