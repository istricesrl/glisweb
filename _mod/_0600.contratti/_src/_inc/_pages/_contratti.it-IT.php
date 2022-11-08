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

	// vista archivio contratti
	$p['contratti.archivio.view'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-archive" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'archivio' ),
	    'h1'		=> array( $l		=> 'archivio' ),
	    'parent'		=> array( 'id'		=> 'contratti.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_contratti.archivio.view.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['contratti.view']['etc']['tabs'] )
	);

/*	// vista scadenze contratti
	$p['contratti.scadenze.view'] = array(
	    'sitemap'		=> false,
		'title'		=> array( $l		=> 'scadenze' ),
	    'h1'		=> array( $l		=> 'scadenze' ),
	    'parent'		=> array( 'id'		=> 'contratti.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_contratti.scadenze.view.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['contratti.view']['etc']['tabs'] )
	);
*/
    // gestione contratti
	$p['contratti.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'contratti.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'contratti.form.html' ),
	    'macro'		=> array(  $m . '_src/_inc/_macro/_contratti.form.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> array(
													'contratti.form',
													'contratti.form.rinnovi',
													'contratti.form.pianificazioni',	// TODO in sinergia con il modulo pianificazioni, spostare sotto dentro a un if()
													'contratti.form.immagini',
													'contratti.form.file',
													'contratti.form.metadati',
													'contratti.form.tools' ) )
	);

	// form contratti pianificazioni
	// TODO spostare nel modulo pianificazioni
	$p['contratti.form.pianificazioni'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-clock-o" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'pianificazioni' ),
		'h1'		=> array( $l		=> 'pianificazioni' ),
		'parent'		=> array( 'id'		=> 'contratti.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'contratti.form.pianificazioni.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_contratti.form.pianificazioni.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['contratti.form']['etc']['tabs'] )
	);

	// form contratti immagini
	$p['contratti.form.immagini'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-picture-o" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'immagini' ),
		'h1'		=> array( $l		=> 'immagini' ),
		'parent'		=> array( 'id'		=> 'contratti.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'contratti.form.immagini.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_contratti.form.immagini.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['contratti.form']['etc']['tabs'] )
	);
	
	// form contratti file
	$p['contratti.form.file'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-folder-open-o" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'file' ),
		'h1'		=> array( $l		=> 'file' ),
		'parent'		=> array( 'id'		=> 'contratti.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'contratti.form.file.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_contratti.form.file.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['contratti.form']['etc']['tabs'] )
	);



	// form contratti metadati
	$p['contratti.form.metadati'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-code" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'metadati' ),
		'h1'		=> array( $l		=> 'metadati' ),
		'parent'		=> array( 'id'		=> 'contratti.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'contratti.form.metadati.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_contratti.form.metadati.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['contratti.form']['etc']['tabs'] )
	);
/*
	foreach( range( 1, 9 ) as $i ) {
		$p['contratti.form']['etc']['tabs'][] = 'contratti.form.orari.'.  $i ;
	}

	$p['contratti.form']['etc']['tabs'][] = 'contratti.form.disponibilita';
	$p['contratti.form']['etc']['tabs'][] = 'contratti.form.tools';


	foreach( range( 1, 9 ) as $i ) {
		$p['contratti.form.orari.' . $i ] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'orari turno ' . $i ),
			'h1'			=> array( $l		=> 'turno ' . $i ),
			'parent'		=> array( 'id'		=> 'contratti.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'contratti.form.orari.html' ),
			'macro'			=> array(  $m . '_src/_inc/_macro/_contratti.form.orari.php' ),
			'etc'			=> array( 'tabs'	=>$p['contratti.form']['etc']['tabs'] ),
			'auth'			=> array( 'groups'	=> array(	'roots' ) ),
			'turno'			=> $i	// setto il numero del turno per ciascuna pagina
		);
	}

	// disponibilita
	$p['contratti.form.disponibilita' ] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'disponibilita' ),
		'h1'			=> array( $l		=> 'disponibilità' ),
		'parent'		=> array( 'id'		=> 'contratti.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'contratti.form.disponibilita.html' ),
		'macro'			=> array(  $m . '_src/_inc/_macro/_contratti.form.disponibilita.php' ),
		'etc'			=> array( 'tabs'	=>$p['contratti.form']['etc']['tabs'] ),
		'auth'			=> array( 'groups'	=> array(	'roots' ) )
	);
*/
	// rinnovi contratti
	$p['contratti.form.rinnovi' ] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'rinnovi' ),
		'h1'			=> array( $l		=> 'rinnovi' ),
		'parent'		=> array( 'id'		=> 'contratti.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'contratti.form.rinnovi.html' ),
		'macro'			=> array(  $m . '_src/_inc/_macro/_contratti.form.rinnovi.php' ),
		'etc'			=> array( 'tabs'	=>$p['contratti.form']['etc']['tabs'] ),
		'auth'			=> array( 'groups'	=> array(	'roots' ) )
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
		'title'		=> array( $l		=> 'tipologie' ),
		'h1'		=> array( $l		=> 'tipologie' ),
		'parent'		=> array( 'id'		=> 'contratti.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'		=> array(  $m . '_src/_inc/_macro/_tipologie.contratti.view.php' ),
		'etc'		=> array( 'tabs'	=> array( 'tipologie.contratti.view' ) ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'menu'		=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'tipologie' ),
									'priority'	=> '120' ) ) )
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


	// vista rinnovi contratti
	$p['rinnovi.contratti.view'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'rinnovi contratti' ),
		'h1'		=> array( $l		=> 'rinnovi' ),
		'parent'		=> array( 'id'		=> 'archivio' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'		=> array(  $m . '_src/_inc/_macro/_rinnovi.contratti.view.php' ),
		'etc'		=> array( 'tabs'	=> $p['contratti.view']['etc']['tabs'] ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) )
	);

	// gestione tipologie contratti
	$p['rinnovi.contratti.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'rinnovi.contratti.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'rinnovi.contratti.form.html' ),
		'macro'		=> array(  $m . '_src/_inc/_macro/_rinnovi.contratti.form.php' ),
		'etc'		=> array( 'tabs'	=> array(   'rinnovi.contratti.form',
													'rinnovi.contratti.form.immagini',
													'rinnovi.contratti.form.file',
													'rinnovi.contratti.form.metadati' ) ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) )		
	);

		// form contratti immagini
	$p['rinnovi.contratti.form.immagini'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-picture-o" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'immagini' ),
		'h1'		=> array( $l		=> 'immagini' ),
		'parent'		=> array( 'id'		=> 'rinnovi.contratti.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'rinnovi.contratti.form.immagini.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_rinnovi.contratti.form.immagini.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['rinnovi.contratti.form']['etc']['tabs'] )
	);
	
	// form contratti file
	$p['rinnovi.contratti.form.file'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-folder-open-o" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'file' ),
		'h1'		=> array( $l		=> 'file' ),
		'parent'		=> array( 'id'		=> 'rinnovi.contratti.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'rinnovi.contratti.form.file.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_rinnovi.contratti.form.file.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['rinnovi.contratti.form']['etc']['tabs'] )
	);


	// form contratti metadati
	$p['rinnovi.contratti.form.metadati'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-code" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'metadati' ),
		'h1'		=> array( $l		=> 'metadati' ),
		'parent'		=> array( 'id'		=> 'rinnovi.contratti.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'rinnovi.contratti.form.metadati.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_rinnovi.contratti.form.metadati.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['rinnovi.contratti.form']['etc']['tabs'] )
	);

