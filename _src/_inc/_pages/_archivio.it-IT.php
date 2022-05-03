<?php

    // lingua di questo file
	$l = 'it-IT';

    // pagina dell'archivio
	$p['archivio'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'archivio' ),
	    'h1'		=> array( $l		=> 'archivio' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'archivio.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_archivio.php' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'auth'		=> array( 'groups'	=> array(	'roots','staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'archivio' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'archivio' ),
		'priority'	=> '930' ) ) )
	);

	// vista indirizzi
	$p['indirizzi.view'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'indirizzi' ),
		'h1'		=> array( $l		=> 'indirizzi' ),
		'parent'		=> array( 'id'		=> 'archivio' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'		=> array( '_src/_inc/_macro/_indirizzi.view.php' ),
		'etc'		=> array( 'tabs'	=> array( 'indirizzi.view' ) ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'indirizzi' ),
		'priority'	=> '050' ) ) )
	);

	// gestione indirizzi
	$p['indirizzi.form'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'gestione' ),
		'h1'		=> array( $l		=> 'gestione' ),
		'parent'		=> array( 'id'		=> 'indirizzi.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'indirizzi.form.html' ),
		'macro'		=> array( '_src/_inc/_macro/_indirizzi.form.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff'  ) ),
		'etc'		=> array( 'tabs'	=> array( 'indirizzi.form',
												'indirizzi.form.associazioni',
												'indirizzi.form.mappa',
												'indirizzi.form.tools' ) )
		
	);

	// gestione associazione indirizzi
	$p['indirizzi.form.associazioni'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'associazioni' ),
		'h1'		=> array( $l		=> 'associazioni' ),
		'parent'		=> array( 'id'		=> 'indirizzi.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'indirizzi.form.associazioni.html' ),
		'macro'		=> array( '_src/_inc/_macro/_indirizzi.form.associazioni.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff'  ) ),
		'etc'		=> array( 'tabs'	=> $p['indirizzi.form']['etc']['tabs'] )
	);

	// gestione mappa indirizzi
	$p['indirizzi.form.mappa'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'mappa' ),
		'h1'		=> array( $l		=> 'mappa' ),
		'parent'		=> array( 'id'		=> 'indirizzi.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'indirizzi.form.mappa.html' ),
		'macro'		=> array( '_src/_inc/_macro/_indirizzi.form.mappa.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff'  ) ),
		'etc'		=> array( 'tabs'	=> $p['indirizzi.form']['etc']['tabs'] )
	);

	// gestione indirizzi strumenti
	$p['indirizzi.form.tools'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'azioni indirizzo' ),
	    'h1'		=> array( $l		=> 'azioni indirizzo' ),
	    'parent'		=> array( 'id'		=> 'indirizzi.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_indirizzi.form.tools.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['indirizzi.form']['etc']['tabs'] )
	);

	// vista luoghi
	$p['luoghi.view'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'luoghi' ),
		'h1'		=> array( $l		=> 'luoghi' ),
		'parent'		=> array( 'id'		=> 'indirizzi.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'		=> array( '_src/_inc/_macro/_luoghi.view.php' ),
		'etc'		=> array( 'tabs'	=> array( 'luoghi.view' ) ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'luoghi' ),
																				'priority'	=> '050' ) ) )
	);

	// gestione luoghi
	$p['luoghi.form'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'gestione' ),
		'h1'		=> array( $l		=> 'gestione' ),
		'parent'		=> array( 'id'		=> 'luoghi.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'luoghi.form.html' ),
		'macro'		=> array( '_src/_inc/_macro/_luoghi.form.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff'  ) ),
		'etc'		=> array( 'tabs'	=> array( 'luoghi.form') )
		
	);

	// vista immagini
	$p['immagini.view'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'immagini' ),
		'h1'		=> array( $l		=> 'immagini' ),
		'parent'		=> array( 'id'		=> 'archivio' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'		=> array( '_src/_inc/_macro/_immagini.view.php' ),
		'etc'		=> array( 'tabs'	=> array( 'immagini.view' ) ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'immagini' ),
		'priority'	=> '020' ) ) )
	);

	// gestione immagini
	$p['immagini.form'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'gestione' ),
		'h1'		=> array( $l		=> 'gestione' ),
		'parent'		=> array( 'id'		=> 'immagini.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'immagini.form.html' ),
		'macro'		=> array( '_src/_inc/_macro/_immagini.form.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff'  ) ),
		'etc'		=> array( 'tabs'	=> array( 
												'immagini.form',
												'immagini.form.associazioni',
												'immagini.form.anagrafica',
												'immagini.form.sem',
												'immagini.form.testo',
												'immagini.form.metadati',
												'immagini.form.tools'
												 ) )	
	);

	// gestione immagini associazioni
	$p['immagini.form.associazioni'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'associazioni' ),
		'h1'		=> array( $l		=> 'associazioni' ),
		'parent'		=> array( 'id'		=> 'immagini.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'immagini.form.associazioni.html' ),
		'macro'		=> array( '_src/_inc/_macro/_immagini.form.associazioni.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff'  ) ),
		'etc'		=> array( 'tabs'	=> $p['immagini.form']['etc']['tabs'] )
	);

	// gestione immagini anagrafica
	$p['immagini.form.anagrafica'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'anagrafica' ),
		'h1'		=> array( $l		=> 'anagrafica' ),
		'parent'		=> array( 'id'		=> 'immagini.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'immagini.form.anagrafica.html' ),
		'macro'		=> array( '_src/_inc/_macro/_immagini.form.anagrafica.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff'  ) ),
		'etc'		=> array( 'tabs'	=> $p['immagini.form']['etc']['tabs'] )
	);

	// gestione immagini SEM
	$p['immagini.form.sem'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'SEM/SMM' ),
	    'h1'		=> array( $l		=> 'SEM/SMM' ),
	    'parent'		=> array( 'id'		=> 'immagini.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'immagini.form.sem.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_immagini.form.sem.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['immagini.form']['etc']['tabs'] )
	);

	// gestione immagini testo
	$p['immagini.form.testo'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'testo' ),
	    'h1'		=> array( $l		=> 'testo' ),
	    'parent'		=> array( 'id'		=> 'immagini.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'immagini.form.testo.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_immagini.form.testo.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['immagini.form']['etc']['tabs'] )
	);

	// gestione immagini metadati
	$p['immagini.form.metadati'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-code" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'metadati' ),
		'h1'		=> array( $l		=> 'metadati' ),
		'parent'		=> array( 'id'		=> 'immagini.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'immagini.form.metadati.html' ),
		'macro'		=> array( '_src/_inc/_macro/_immagini.form.metadati.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['immagini.form']['etc']['tabs'] )
	);

	// gestione immagini strumenti
	$p['immagini.form.tools'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'azioni immagine' ),
	    'h1'		=> array( $l		=> 'azioni immagine' ),
	    'parent'		=> array( 'id'		=> 'immagini.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_immagini.form.tools.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['immagini.form']['etc']['tabs'] )
	);

	// vista video
	$p['video.view'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'video' ),
		'h1'		=> array( $l		=> 'video' ),
		'parent'		=> array( 'id'		=> 'archivio' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'		=> array( '_src/_inc/_macro/_video.view.php' ),
		'etc'		=> array( 'tabs'	=> array( 'video.view' ) ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'video' ),
		'priority'	=> '030' ) ) )
	);

	// gestione video
	$p['video.form'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'gestione' ),
		'h1'		=> array( $l		=> 'gestione' ),
		'parent'		=> array( 'id'		=> 'video.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'video.form.html' ),
		'macro'		=> array( '_src/_inc/_macro/_video.form.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff'  ) ),
		'etc'		=> array( 'tabs'	=> array( 
												'video.form',
												'video.form.associazioni',
												'video.form.testo'
												 ) )	
	);

	// gestione video testo
	$p['video.form.testo'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'testo' ),
		'h1'		=> array( $l		=> 'testo' ),
		'parent'		=> array( 'id'		=> 'video.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'video.form.testo.html' ),
		'macro'		=> array( '_src/_inc/_macro/_video.form.testo.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> $p['video.form']['etc']['tabs'] )
	);

	// gestione video associazioni
	$p['video.form.associazioni'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'associazioni' ),
		'h1'		=> array( $l		=> 'associazioni' ),
		'parent'		=> array( 'id'		=> 'video.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'video.form.associazioni.html' ),
		'macro'		=> array( '_src/_inc/_macro/_video.form.associazioni.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff'  ) ),
		'etc'		=> array( 'tabs'	=> $p['video.form']['etc']['tabs'] )
	);

	// vista valutazioni
	$p['valutazioni.view'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'valutazioni' ),
		'h1'		=> array( $l		=> 'valutazioni' ),
		'parent'		=> array( 'id'		=> 'archivio' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'		=> array( '_src/_inc/_macro/_valutazioni.view.php' ),
		'etc'		=> array( 'tabs'	=> array( 'valutazioni.view' ) ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'valutazioni' ),
		'priority'	=> '300' ) ) )
	);

	// gestione video
	$p['valutazioni.form'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'gestione' ),
		'h1'		=> array( $l		=> 'gestione' ),
		'parent'		=> array( 'id'		=> 'video.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'valutazioni.form.html' ),
		'macro'		=> array( '_src/_inc/_macro/_valutazioni.form.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff'  ) ),
		'etc'		=> array( 'tabs'	=> array( 
												'valutazioni.form'
												 ) )	
	);