<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_6700.certificazioni/';

	// vista certificazioni
	$p['certificazioni.view'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'certificazioni' ),
	    'h1'		=> array( $l		=> 'certificazioni' ),
	    'parent'		=> array( 'id'		=> 'anagrafica.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'		=> array(  $m . '_src/_inc/_macro/_certificazioni.view.php' ),
	    'etc'		=> array( 'tabs'	=> array( 'certificazioni.view', 'certificazioni.archivio.view' ) ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'certificazioni' ),
									'priority'	=> '210' ) ) )						
	);

	// vista archivio certificazioni
	$p['certificazioni.archivio.view'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-archive" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'archivio' ),
	    'h1'		=> array( $l		=> 'archivio' ),
	    'parent'		=> array( 'id'		=> 'certificazioni.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_certificazioni.archivio.view.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['certificazioni.view']['etc']['tabs'] )
	);

    // gestione certificazioni
	$p['certificazioni.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'certificazioni.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'certificazioni.form.html' ),
	    'macro'		=> array(  $m . '_src/_inc/_macro/_certificazioni.form.php' ),
		'etc'		=> array( 'tabs'	=> array( 'certificazioni.form', 'certificazioni.form.file', 'certificazioni.form.tools' ) ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) )
	);

	// form pagina file
	$p['certificazioni.form.file'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-folder-open-o" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'file' ),
		'h1'		=> array( $l		=> 'file' ),
		'parent'		=> array( 'id'		=> 'certificazioni.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'certificazioni.form.file.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_certificazioni.form.file.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['certificazioni.form']['etc']['tabs'] )
	);
	
	// gestione certificazioni tools
	$p['certificazioni.form.tools'] = array(
	    'sitemap'		=> false,
		'title'		=> array( $l		=> 'strumenti certificazioni' ),
		'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'h1'		=> array( $l		=> 'strumenti' ),
	    'parent'		=> array( 'id'		=> 'certificazioni.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'		=> array(  $m . '_src/_inc/_macro/_certificazioni.form.tools.php' ),
	    'etc'		=> array( 'tabs'	=>$p['certificazioni.form']['etc']['tabs'] ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) )
	);


	// vista tipologie certificazioni
	$p['tipologie.certificazioni.view'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'tipologie' ),
		'h1'		=> array( $l		=> 'tipologie' ),
		'parent'		=> array( 'id'		=> 'certificazioni.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'		=> array(  $m . '_src/_inc/_macro/_tipologie.certificazioni.view.php' ),
		'etc'		=> array( 'tabs'	=> array( 'tipologie.certificazioni.view' ) ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'menu'		=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'tipologie' ),
									'priority'	=> '120' ) ) )
	);

	// gestione tipologie certificazioni
	$p['tipologie.certificazioni.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'tipologie.certificazioni.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'tipologie.certificazioni.form.html' ),
		'macro'		=> array(  $m . '_src/_inc/_macro/_tipologie.certificazioni.form.php' ),
		'etc'		=> array( 'tabs'	=> array( 'tipologie.certificazioni.form' ) ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) )		
	);
