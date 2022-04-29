<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0600.contratti/';

	// vista contratti
	$p['contratti.view'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'contratti' ),
	    'h1'		=> array( $l		=> 'contratti' ),
	    'parent'		=> array( 'id'		=> 'archivio' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'		=> array(  $m . '_src/_inc/_macro/_contratti.view.php' ),
	    'etc'		=> array( 'tabs'	=> array(	'contratti.view',
													'rinnovi.contratti.view' ,
													'contratti.archivio.view') ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'contratti' ),
									'priority'	=> '200' ) ) )						
	);
