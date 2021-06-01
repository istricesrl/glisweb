<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_6500.casse/';

    // dashboard del modulo
	$p['casse'] = array(
	    'sitemap'	=> false,
	    'title'		=> array( $l		=> 'casse' ),
	    'h1'		=> array( $l		=> 'casse' ),
	    'template'	=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'casse.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_casse.php' ),
	    'parent'	=> array( 'id'		=> NULL ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'casse', 'casse.documenti.view', 'casse.tools', 'casse.stampe' ) ),
	    'menu'		=> array( 'admin'	=> array(	'label'		=> array( $l => 'casse' ),
									'priority'	=> '650' ) )
	);

	// stampe cassa
	$p['casse.stampe'] = array(
	    'sitemap'	=> false,
		'icon'		=> '<i class="fa fa-print" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'stampe' ),
	    'h1'		=> array( $l		=> 'stampe' ),
	    'parent'	=> array( 'id'		=> 'casse' ),
	    'template'	=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_casse.stampe.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['casse']['etc']['tabs'] )
	);

    // view scontrini
	$p['casse.documenti.view'] = array(
	    'sitemap'	=> false,
	    'title'		=> array( $l		=> 'documenti' ),
	    'h1'		=> array( $l		=> 'documenti' ),
	    'template'	=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_casse.documenti.view.php' ),
	    'parent'	=> array( 'id'		=> NULL ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> $p['casse']['etc']['tabs'] )
	);

    // strumenti casse
	$p['casse.tools'] = array(
	    'sitemap'	=> false,
		'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'strumenti casse' ),
	    'h1'		=> array( $l		=> 'strumenti casse' ),
	    'template'	=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_casse.tools.php' ),
	    'parent'	=> array( 'id'		=> NULL ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> $p['casse']['etc']['tabs'] )
	);

    // terminale della casse
	$p['terminale'] = array(
	    'sitemap'	=> false,
	    'title'		=> array( $l		=> 'terminale' ),
	    'h1'		=> array( $l		=> 'terminale' ),
	    'template'	=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'terminale.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_terminale.php' ),
	    'parent'	=> array( 'id'		=> 'casse' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'sheets' => array( 'terminale' , 'assistenza' ) ), 
	    'menu'		=> array( 'admin'	=> array(	'label'		=> array( $l => 'terminale' ),
									'priority'	=> 100 ) )
	);

	// terminale della casse
	$p['anteprima.documento'] = array(
			'sitemap'	=> false,
			'title'		=> array( $l		=> 'anteprima' ),
			'h1'		=> array( $l		=> 'anteprima' ),
			'template'	=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'anteprima.documento.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_anteprima.documento.php' ),
			'parent'	=> array( 'id'		=> 'casse' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) )
		);

	// terminale della casse
	$p['assistenza'] = array(
	    'sitemap'	=> false,
	    'title'		=> array( $l		=> 'assistenza' ),
	    'h1'		=> array( $l		=> 'assistenza' ),
	    'template'	=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'assistenza.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_assistenza.php' ),
	    'parent'	=> array( 'id'		=> 'casse' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'sheets'	=>  $p['terminale']['etc']['sheets'] )
	);
	
    // debug
	// die( print_r( $p ) );
