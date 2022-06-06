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
														'priority'	=> '190' ) ) )	
    );
