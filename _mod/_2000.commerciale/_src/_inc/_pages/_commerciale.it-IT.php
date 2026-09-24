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
		'etc'		=> array( 'tabs'	=> array(	'commerciale', 'commerciale.gestiti', 'commerciale.stampe', 'commerciale.tools' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'commerciale' ),
														'priority'	=> '190' ) ) )	
    );

	// dashboard commerciale
	$p['commerciale.gestiti'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestiti' ),
	    'h1'		=> array( $l		=> 'gestiti' ),
	    'template'	=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'commerciale.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_commerciale.gestiti.php' ),
	    'parent'	=> array( 'id'		=> 'commerciale' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> $p['commerciale']['etc']['tabs'] )
    );

    // tools produzione
	$p['commerciale.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'commerciale' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_commerciale.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['commerciale']['etc']['tabs'] )
	);

    // tools produzione
	$p['commerciale.stampe'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-print" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'stampe' ),
	    'h1'				=> array( $l		=> 'stampe' ),
	    'parent'			=> array( 'id'		=> 'commerciale' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_commerciale.stampe.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['commerciale']['etc']['tabs'] )
	);
