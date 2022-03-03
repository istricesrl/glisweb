<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_3500.risorse/';

	// vista risorse
	$p['risorse.view'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'risorse' ),
	    'h1'		=> array( $l		=> 'risorse' ),
	    'parent'		=> array( 'id'		=> 'contenuti' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_risorse.view.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'risorse.view',
									'risorse.tools' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'risorse' ),
									'priority'	=> '025' ) ) )				
	    );

    // gestione risorse
	$p['risorse.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'risorse.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'risorse.form.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_risorse.form.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> array(	'risorse.form',
													'risorse.form.tools') )
	);

