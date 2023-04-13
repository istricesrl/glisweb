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
	    'parent'		=> array( 'id'		=> 'archivio.amministrazione' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'		=> array(  $m . '_src/_inc/_macro/_certificazioni.view.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> array(
											'certificazioni.view',
											'anagrafica.certificazioni.view' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'certificazioni' ),
									'priority'	=> '210' ) ) )						
	);

    // gestione certificazioni
	$p['certificazioni.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'certificazioni.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'certificazioni.form.html' ),
	    'macro'		=> array(  $m . '_src/_inc/_macro/_certificazioni.form.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> array( 
											'certificazioni.form',
#											'certificazioni.form.anagrafica',
#											'certificazioni.form.progetti',
											'certificazioni.form.tools'
											) )
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

	// vista scadenze certificazioni
	$p['anagrafica.certificazioni.view'] = array(
	    'sitemap'		=> false,
		'title'		=> array( $l		=> 'scadenze anagrafica' ),
	    'h1'		=> array( $l		=> 'scadenze anagrafica' ),
	    'parent'		=> array( 'id'		=> 'certificazioni.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_anagrafica.certificazioni.view.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['certificazioni.view']['etc']['tabs'] )
	);

	// gestione anagrafica.certificazioni
	$p['anagrafica.certificazioni.form'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'gestione' ),
		'h1'		=> array( $l		=> 'gestione' ),
		'parent'		=> array( 'id'		=> 'anagrafica.certificazioni.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'anagrafica.certificazioni.form.html' ),
		'macro'		=> array(  $m . '_src/_inc/_macro/_anagrafica.certificazioni.form.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff'  ) ),
		'etc'		=> array( 'tabs'	=> array( 
												'anagrafica.certificazioni.form',
#												'anagrafica.certificazioni.form.immagini',
												'anagrafica.certificazioni.form.file'
												 ) )	
	);

	$p['anagrafica.certificazioni.form.file'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-folder-open-o" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'file' ),
		'h1'		=> array( $l		=> 'file' ),
		'parent'		=> array( 'id'		=> 'anagrafica.certificazioni.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'anagrafica.certificazioni.form.file.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_anagrafica.certificazioni.form.file.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['anagrafica.certificazioni.form']['etc']['tabs'] )
	);


/*
	// vista certificazioni
	$p['certificazioni.view'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'certificazioni' ),
	    'h1'		=> array( $l		=> 'certificazioni' ),
	    'parent'		=> array( 'id'		=> 'anagrafica.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'		=> array(  $m . '_src/_inc/_macro/_certificazioni.view.php' ),
	    'etc'		=> array( 'tabs'	=> array( 'certificazioni.view', 'certificazioni.scadenze.view' ) ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'certificazioni' ),
									'priority'	=> '210' ) ) )						
	);

	// vista scadenze certificazioni
	$p['certificazioni.scadenze.view'] = array(
	    'sitemap'		=> false,
		'title'		=> array( $l		=> 'scadenze' ),
	    'h1'		=> array( $l		=> 'scadenze' ),
	    'parent'		=> array( 'id'		=> 'certificazioni.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_certificazioni.scadenze.view.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['certificazioni.view']['etc']['tabs'] )
	);


	$p['certificazioni.form.anagrafica'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'anagrafica' ),
		'h1'		=> array( $l		=> 'anagrafica' ),
		'parent'		=> array( 'id'		=> 'certificazioni.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'certificazioni.form.anagrafica.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_certificazioni.form.anagrafica.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['certificazioni.form']['etc']['tabs'] )
	);

	$p['certificazioni.form.progetti'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'progetti' ),
		'h1'		=> array( $l		=> 'progetti' ),
		'parent'		=> array( 'id'		=> 'certificazioni.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'certificazioni.form.progetti.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_certificazioni.form.progetti.php' ),
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

	if( in_array( "1000.produzione", $cf['mods']['active']['array'] ) ){
		// inserimento della tab 'progetti.produzione.form.certificazioni' nelle pagine di form produzione
		arrayInsertSeq( 'progetti.produzione.form.pause', $p['progetti.produzione.form']['etc']['tabs'], 'progetti.produzione.form.certificazioni' );
		
		foreach( $p['progetti.produzione.form']['etc']['tabs'] as $t ){
			$p[ $t ]['etc']['tabs'] = $p['progetti.produzione.form']['etc']['tabs'];
		}
		
		// gestione certificazioni progetti
		$p['progetti.produzione.form.certificazioni'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'certificazioni' ),
			'h1'			=> array( $l		=> 'certificazioni' ),
			'parent'		=> array( 'id'		=> 'progetti.produzione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.produzione.form.certificazioni.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_progetti.produzione.form.certificazioni.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['progetti.produzione.form']['etc']['tabs'] )
		);
	}
*/
/*
	// inserimento della tab 'anagrafica.form.certificazioni' nelle pagine di form anagrafica
	arrayInsertSeq( 'anagrafica.form.informazioni', $p['anagrafica.form']['etc']['tabs'], 'anagrafica.form.certificazioni' );
	
	foreach( $p['anagrafica.form']['etc']['tabs'] as $t ){
		$p[ $t ]['etc']['tabs'] = $p['anagrafica.form']['etc']['tabs'];
	}
*/	
	// gestione anagrafica certificazioni
	$p['anagrafica.form.certificazioni'] = array(
	    'sitemap'			=> false,
	    'title'				=> array( $l		=> 'certificazioni anagrafica' ),
	    'h1'				=> array( $l		=> 'certificazioni' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'anagrafica.form.certificazioni.html' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_anagrafica.form.certificazioni.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['anagrafica.form']['etc']['tabs'] )
	);
/*
	// vista anagrafica_certificazioni in archivio
	$p['anagrafica.certificazioni.view'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'anagrafica certificazioni' ),
		'h1'		=> array( $l		=> 'certificazioni anagrafica' ),
		'parent'		=> array( 'id'		=> 'archivio' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_anagrafica.certificazioni.view.php' ),
		'etc'		=> array( 'tabs'	=> array( 'anagrafica.certificazioni.view' ) ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'certificazioni' ),
		'priority'	=> '110' ) ) )
	);

	// gestione anagrafica.certificazioni
	$p['anagrafica.certificazioni.form'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'gestione' ),
		'h1'		=> array( $l		=> 'gestione' ),
		'parent'		=> array( 'id'		=> 'anagrafica.certificazioni.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'anagrafica.certificazioni.form.html' ),
		'macro'		=> array(  $m . '_src/_inc/_macro/_anagrafica.certificazioni.form.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff'  ) ),
		'etc'		=> array( 'tabs'	=> array( 
												'anagrafica.certificazioni.form',
												'anagrafica.certificazioni.form.immagini',
												'anagrafica.certificazioni.form.file'
												 ) )	
	);

	$p['anagrafica.certificazioni.form.immagini'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-picture-o" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'immagini' ),
		'h1'		=> array( $l		=> 'immagini' ),
		'parent'		=> array( 'id'		=> 'anagrafica.certificazioni.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'anagrafica.certificazioni.form.immagini.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_anagrafica.certificazioni.form.immagini.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['anagrafica.certificazioni.form']['etc']['tabs'] )
	);

	$p['anagrafica.certificazioni.form.file'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-folder-open-o" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'file' ),
		'h1'		=> array( $l		=> 'file' ),
		'parent'		=> array( 'id'		=> 'anagrafica.certificazioni.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'anagrafica.certificazioni.form.file.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_anagrafica.certificazioni.form.file.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['anagrafica.certificazioni.form']['etc']['tabs'] )
	);
*/
	