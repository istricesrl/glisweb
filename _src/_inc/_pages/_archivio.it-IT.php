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

    // pagina dell'archivio
	$p['archivio.logistica'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'archivio logistica' ),
	    'h1'		=> array( $l		=> 'archivio logistica' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'archivio.logistica.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_archivio.logistica.php' ),
	    'parent'		=> array( 'id'		=> 'archivio' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'archivio.logistica' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'logistica' ),
		'priority'	=> '910' ) ) )
	);

	// vista mail
	$p['mail.view'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'mail' ),
		'h1'		=> array( $l		=> 'mail' ),
		'parent'		=> array( 'id'		=> 'archivio.logistica' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'		=> array( '_src/_inc/_macro/_mail.view.php' ),
		'etc'		=> array( 'tabs'	=> array( 'mail.view' ) ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'mail' ),
		'priority'	=> '050' ) ) )
	);

	// gestione mail
	$p['mail.form'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'gestione' ),
		'h1'		=> array( $l		=> 'gestione' ),
		'parent'		=> array( 'id'		=> 'mail.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'mail.form.html' ),
		'macro'		=> array( '_src/_inc/_macro/_mail.form.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff'  ) ),
		'etc'		=> array( 'tabs'	=> array( 'mail.form',
												'mail.form.tools' ) )
		
	);

	// gestione mail strumenti
	$p['mail.form.tools'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'azioni mail' ),
	    'h1'		=> array( $l		=> 'azioni mail' ),
	    'parent'		=> array( 'id'		=> 'mail.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'		=> array( '_src/_inc/_macro/mail.form.tools.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['mail.form']['etc']['tabs'] )
	);

	// vista indirizzi
	$p['indirizzi.view'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'indirizzi' ),
		'h1'		=> array( $l		=> 'indirizzi' ),
		'parent'		=> array( 'id'		=> 'archivio.logistica' ),
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
		'parent'		=> array( 'id'		=> 'archivio.logistica' ),
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

	// vista tipologie luoghi
	$p['tipologie.luoghi.view'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'tipologie' ),
		'h1'		=> array( $l		=> 'tipologie' ),
		'parent'		=> array( 'id'		=> 'luoghi.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'		=> array( '_src/_inc/_macro/_tipologie.luoghi.view.php' ),
		'etc'		=> array( 'tabs'	=> array( 'tipologie.luoghi.view' ) ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'tipologie' ),
																				'priority'	=> '060' ) ) )
	);

	// gestione luoghi
	$p['tipologie.luoghi.form'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'gestione' ),
		'h1'		=> array( $l		=> 'gestione' ),
		'parent'		=> array( 'id'		=> 'tipologie.luoghi.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'tipologie.luoghi.form.html' ),
		'macro'		=> array( '_src/_inc/_macro/_tipologie.luoghi.form.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff'  ) ),
		'etc'		=> array( 'tabs'	=> array( 'tipologie.luoghi.form') )
		
	);

	// vista zone
	$p['zone.view'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'zone' ),
		'h1'		=> array( $l		=> 'zone' ),
		'parent'		=> array( 'id'		=> 'archivio.logistica' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'		=> array( '_src/_inc/_macro/_zone.view.php' ),
		'etc'		=> array( 'tabs'	=> array( 'zone.view' ) ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'zone' ),
																				'priority'	=> '050' ) ) )
	);

	// gestione zone
	$p['zone.form'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'gestione' ),
		'h1'		=> array( $l		=> 'gestione' ),
		'parent'		=> array( 'id'		=> 'zone.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'zone.form.html' ),
		'macro'		=> array( '_src/_inc/_macro/_zone.form.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff'  ) ),
		'etc'		=> array( 'tabs'	=> array( 'zone.form') )
		
	);
	
	// vista tipologie zone
	$p['tipologie.zone.view'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'tipologie' ),
		'h1'		=> array( $l		=> 'tipologie' ),
		'parent'		=> array( 'id'		=> 'zone.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'		=> array( '_src/_inc/_macro/_tipologie.zone.view.php' ),
		'etc'		=> array( 'tabs'	=> array( 'tipologie.zone.view' ) ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'tipologie' ),
																				'priority'	=> '060' ) ) )
	);

	// gestione zone
	$p['tipologie.zone.form'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'gestione' ),
		'h1'		=> array( $l		=> 'gestione' ),
		'parent'		=> array( 'id'		=> 'tipologie.zone.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'tipologie.zone.form.html' ),
		'macro'		=> array( '_src/_inc/_macro/_tipologie.zone.form.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff'  ) ),
		'etc'		=> array( 'tabs'	=> array( 'tipologie.zone.form') )
		
	);

    // pagina dell'archivio
	$p['archivio.media'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'archivio media' ),
	    'h1'		=> array( $l		=> 'archivio media' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'archivio.media.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_archivio.media.php' ),
	    'parent'		=> array( 'id'		=> 'archivio' ),
	    'auth'		=> array( 'groups'	=> array(	'roots','staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'archivio.media' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'media' ),
		'priority'	=> '070' ) ) )
	);

	// vista immagini
	$p['immagini.view'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'immagini' ),
		'h1'		=> array( $l		=> 'immagini' ),
		'parent'		=> array( 'id'		=> 'archivio.media' ),
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
		'icon'			=> '<i class="fa fa-google" aria-hidden="true"></i>',
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
		'icon'			=> '<i class="fa fa-file-text-o" aria-hidden="true"></i>',
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
		'parent'		=> array( 'id'		=> 'archivio.media' ),
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
		'icon'			=> '<i class="fa fa-file-text-o" aria-hidden="true"></i>',
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
/*
	// vista valutazioni
	// TODO ma questa dovrebbe stare qui? non fa parte di un modulo?
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
*/
	// vista periodi
	$p['periodi.view'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'periodi' ),
		'h1'		=> array( $l		=> 'periodi' ),
		'parent'		=> array( 'id'		=> 'archivio.amministrazione' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'		=> array( '_src/_inc/_macro/_periodi.view.php' ),
		'etc'		=> array( 'tabs'	=> array( 'periodi.view' ) ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'periodi' ),
																				'priority'	=> '060' ) ) )
	);

	// gestione periodi
	$p['periodi.form'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'gestione' ),
		'h1'		=> array( $l		=> 'gestione' ),
		'parent'		=> array( 'id'		=> 'periodi.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'periodi.form.html' ),
		'macro'		=> array( '_src/_inc/_macro/_periodi.form.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff'  ) ),
		'etc'		=> array( 'tabs'	=> array( 'periodi.form') )
		
	);

	// vista tipologie periodi
	$p['tipologie.periodi.view'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'tipologie' ),
		'h1'		=> array( $l		=> 'tipologie' ),
		'parent'		=> array( 'id'		=> 'periodi.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'		=> array( '_src/_inc/_macro/_tipologie.periodi.view.php' ),
		'etc'		=> array( 'tabs'	=> array( 'tipologie.periodi.view' ) ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'tipologie' ),
																				'priority'	=> '060' ) ) )
	);

	// gestione periodi
	$p['tipologie.periodi.form'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'gestione' ),
		'h1'		=> array( $l		=> 'gestione' ),
		'parent'		=> array( 'id'		=> 'tipologie.periodi.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'tipologie.periodi.form.html' ),
		'macro'		=> array( '_src/_inc/_macro/_tipologie.periodi.form.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff'  ) ),
		'etc'		=> array( 'tabs'	=> array( 'tipologie.periodi.form') )
		
	);

/* TODO se non è attivo il modulo contenuti, i redirect dovrebbero comunque trovarsi in archivio

	// vista redirect
	$p['redirect.view'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'redirect' ),
	    'h1'		=> array( $l		=> 'redirect' ),
	    'parent'		=> array( 'id'		=> 'archivio' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_redirect.view.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'redirect.view',
									'redirect.stats' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'redirect' ),
									'priority'	=> '070' ) ) )										
    );

	// statistiche redirect
	$p['redirect.stats'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-bar-chart" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'statistiche' ),
	    'h1'		=> array( $l		=> 'statistiche' ),
	    'parent'		=> array( 'id'		=> 'archivio' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.stats.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_redirect.stats.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['redirect.view']['etc']['tabs'] )
    );

    // form redirect
	$p['redirect.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'redirect.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'redirect.form.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_redirect.form.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> array(	'redirect.form',
													'redirect.form.stats') )
	);

	// statistiche form redirect
	$p['redirect.form.stats'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-bar-chart" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'statistiche redirect' ),
	    'h1'		=> array( $l		=> 'statistiche redirect' ),
	    'parent'		=> array( 'id'		=> 'archivio' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.stats.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_redirect.form.stats.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['redirect.form']['etc']['tabs'] )
    );

*/

    // pagina dell'archivio
	$p['archivio.produzione'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'archivio produzione' ),
	    'h1'		=> array( $l		=> 'archivio produzione' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'archivio.produzione.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_archivio.produzione.php' ),
	    'parent'		=> array( 'id'		=> 'archivio' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'archivio.produzione' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'produzione' ),
		'priority'	=> '910' ) ) )
	);

    // pagina dell'archivio
	$p['archivio.amministrazione'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'archivio amministrazione' ),
	    'h1'		=> array( $l		=> 'archivio amministrazione' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'archivio.amministrazione.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_archivio.amministrazione.php' ),
	    'parent'		=> array( 'id'		=> 'archivio' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'archivio.amministrazione' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'amministrazione' ),
		'priority'	=> '930' ) ) )
	);

	// vista listini
	$p['listini.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'listini' ),
	    'h1'			=> array( $l		=> 'listini' ),
	    'parent'		=> array( 'id'		=> 'archivio.amministrazione' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( '_src/_inc/_macro/_listini.view.php' ),
		'etc'			=> array( 'tabs'	=> array( 'listini.view' ) ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'listini' ),
								'priority'	=> '035' ) ) )
	);

	// gestione listini
	$p['listini.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'listini.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'listini.form.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_listini.form.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'listini.form'	, 'listini.form.gruppi'	) )
	);

	// gestione listini gruppi
	$p['listini.form.gruppi'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-users" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'gruppi' ),
		'h1'		=> array( $l		=> 'gruppi' ),
		'parent'		=> array( 'id'		=> 'listini.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'listini.form.gruppi.html' ),
		'macro'		=> array( '_src/_inc/_macro/_listini.form.gruppi.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['listini.form']['etc']['tabs'] )
	);

	// vista tipologie periodi
	$p['reparti.view'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'reparti' ),
		'h1'		=> array( $l		=> 'reparti' ),
		'parent'		=> array( 'id'		=> 'archivio.amministrazione' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'		=> array( '_src/_inc/_macro/_reparti.view.php' ),
		'etc'		=> array( 'tabs'	=> array( 'reparti.view' ) ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'reparti' ),
																				'priority'	=> '265' ) ) )
	);

	// gestione periodi
	$p['reparti.form'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'gestione' ),
		'h1'		=> array( $l		=> 'gestione' ),
		'parent'		=> array( 'id'		=> 'reparti.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'reparti.form.html' ),
		'macro'		=> array( '_src/_inc/_macro/_reparti.form.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots'  ) ),
		'etc'		=> array( 'tabs'	=> array( 'reparti.form') )
		
	);

    // pagina dell'archivio
	$p['archivio.commerciale'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'archivio commerciale' ),
	    'h1'		=> array( $l		=> 'archivio commerciale' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'archivio.commerciale.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_archivio.commerciale.php' ),
	    'parent'		=> array( 'id'		=> 'archivio' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'archivio.commerciale' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'commerciale' ),
		'priority'	=> '940' ) ) )
	);
