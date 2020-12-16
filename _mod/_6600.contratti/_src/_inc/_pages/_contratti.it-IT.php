<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_6600.contratti/';

	// vista contratti
	$p['contratti.view'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'contratti' ),
	    'h1'		=> array( $l		=> 'contratti' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'		=> array(  $m . '_src/_inc/_macro/_contratti.view.php' ),
	    'etc'		=> array( 'tabs'	=> array( 'contratti.view' ) ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'menu'		=> array( 'admin'	=> array(	'label'		=> array( $l => 'contratti' ),
									'priority'	=> '200' ) )
	);

    // gestione contratti
	$p['contratti.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'contratti.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'contratti.form.html' ),
	    'macro'		=> array(  $m . '_src/_inc/_macro/_contratti.form.php' ),
	    'etc'		=> array( 'tabs'	=> array( 'contratti.form', 'contratti.form.orari', 'contratti.form.tools' ) ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) )
	);

	// gestione contratti orari
	$p['contratti.form.orari'] = array(
	    'sitemap'		=> false,
		'title'		=> array( $l		=> 'orari contratti' ),
	    'h1'		=> array( $l		=> 'orari' ),
	    'parent'		=> array( 'id'		=> 'contratti.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'contratti.form.orari.html' ),
	    'macro'		=> array(  $m . '_src/_inc/_macro/_contratti.form.orari.php' ),
	    'etc'		=> array( 'tabs'	=>$p['contratti.form']['etc']['tabs'] ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) )
	);

	// gestione contratti tools
	$p['contratti.form.tools'] = array(
	    'sitemap'		=> false,
		'title'		=> array( $l		=> 'strumenti contratti' ),
		'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'h1'		=> array( $l		=> 'strumenti' ),
	    'parent'		=> array( 'id'		=> 'contratti.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'		=> array(  $m . '_src/_inc/_macro/_contratti.form.tools.php' ),
	    'etc'		=> array( 'tabs'	=>$p['contratti.form']['etc']['tabs'] ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) )
	);



// vista tipologie contratti
$p['tipologie.contratti.view'] = array(
	'sitemap'		=> false,
	'title'		=> array( $l		=> 'tipologie contratti' ),
	'h1'		=> array( $l		=> 'tipologie contratti' ),
	'parent'		=> array( 'id'		=> 'contratti.view' ),
	'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	'macro'		=> array(  $m . '_src/_inc/_macro/_tipologie.contratti.view.php' ),
	'etc'		=> array( 'tabs'	=> array( 'tipologie.contratti.view' ) ),
	'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	'menu'		=> array( 'admin'	=> array(	'label'		=> array( $l => 'tipologie contratti' ),
								'priority'	=> '120' ) )
);


// gestione tipologie contratti
	$p['tipologie.contratti.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'tipologie.contratti.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'tipologie.contratti.form.html' ),
		'macro'		=> array(  $m . '_src/_inc/_macro/_tipologie.contratti.form.php' ),
		'etc'		=> array( 'tabs'	=> array( 'tipologie.contratti.form' ) ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) )		
	);


	// vista tipologie costi contratti
	$p['tipologie.costi.contratti.view'] = array(
	'sitemap'		=> false,
	'title'		=> array( $l		=> 'tipologie costi' ),
	'h1'		=> array( $l		=> 'tipologie costi' ),
	'parent'		=> array( 'id'		=> 'contratti.view' ),
	'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	'macro'		=> array(  $m . '_src/_inc/_macro/_tipologie.costi.contratti.view.php' ),
	'etc'		=> array( 'tabs'	=> array( 'tipologie.costi.contratti.view' ) ),
	'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	'menu'		=> array( 'admin'	=> array(	'label'		=> array( $l => 'tipologie costi' ),
								'priority'	=> '130' ) )
	);


// gestione tipologie costi contratti
	$p['tipologie.costi.contratti.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'tipologie.costi.contratti.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'tipologie.costi.contratti.form.html' ),
		'macro'		=> array(  $m . '_src/_inc/_macro/_tipologie.costi.contratti.form.php' ),
		'etc'		=> array( 'tabs'	=> array( 'tipologie.costi.contratti.form' ) ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) )		
	);
