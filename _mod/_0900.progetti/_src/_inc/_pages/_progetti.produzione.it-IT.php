<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0900.progetti/';

	// RELAZIONI CON IL MODULO PRODUZIONE
	if( in_array( "1000.produzione", $cf['mods']['active']['array'] ) ) {

		// vista progetti
		$p['progetti.produzione.view'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'progetti' ),
			'h1'			=> array( $l		=> 'progetti' ),
			'parent'		=> array( 'id'		=> 'produzione' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
			'macro'			=> array( $m . '_src/_inc/_macro/_progetti.produzione.view.php' ),
			'etc'			=> array( 'tabs'	=> array( 'progetti.produzione.view', 'progetti.produzione.archivio.view', 'progetti.produzione.tools' ) ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'progetti' ),
																			'priority'	=> '080' ) ) )									
		);

		// vista progetti 
		$p['progetti.produzione.archivio.view'] = array(
			'sitemap'		=> false,
			'icon'			=> '<i class="fa fa-archive" aria-hidden="true"></i>',
			'title'			=> array( $l		=> 'archivio' ),
			'h1'			=> array( $l		=> 'archivio' ),
			'parent'		=> array( 'id'		=> 'produzione' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
			'macro'			=> array( $m . '_src/_inc/_macro/_progetti.produzione.archivio.view.php' ),
			'etc'			=> array( 'tabs'	=> $p['progetti.produzione.view']['etc']['tabs'] ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) )
		);

		// progetti tools
		$p['progetti.produzione.tools'] = array(
			'sitemap'		=> false,
			'icon'			=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
			'title'			=> array( $l		=> 'azioni' ),
			'h1'			=> array( $l		=> 'azioni' ),
			'parent'		=> array( 'id'		=> 'produzione' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
			'macro'			=> array( $m . '_src/_inc/_macro/_progetti.produzione.tools.php' ),
			'etc'			=> array( 'tabs'	=> $p['progetti.produzione.view']['etc']['tabs'] ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) )
		);

		// gestione progetti
		$p['progetti.produzione.form'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'gestione' ),
			'h1'			=> array( $l		=> 'gestione' ),
			'parent'		=> array( 'id'		=> 'progetti.produzione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.produzione.form.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_progetti.produzione.form.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> array(	'progetti.produzione.form', 
														/*	'progetti.produzione.form.mastri',*/
	#														'progetti.produzione.form.todo',
	# NOTA questa va nel modulo pianificazioni
	#														'progetti.produzione.form.pause',
															'progetti.produzione.form.archiviazione',
	# NOTA questa va nel modulo pianificazioni
	#														'progetti.produzione.form.pianificazioni',
															
															'progetti.produzione.form.tools' ) )
		);

		// RELAZIONI CON IL MODULO MATRICOLE
		if( in_array( "4110.matricole", $cf['mods']['active']['array'] ) ) {
			arrayInsertSeq( 'progetti.produzione.form', $p['progetti.produzione.form']['etc']['tabs'], 'progetti.produzione.form.matricole' );
		}

		// RELAZIONI CON IL MODULO ATTIVITA
		if( in_array( "0200.attivita", $cf['mods']['active']['array'] ) ) {
			arrayInsertSeq( 'progetti.produzione.form', $p['progetti.produzione.form']['etc']['tabs'], 'progetti.produzione.form.attivita' );
		}

		// RELAZIONI CON IL MODULO TODO
		if( in_array( "1200.todo", $cf['mods']['active']['array'] ) ) {
			arrayInsertSeq( 'progetti.produzione.form', $p['progetti.produzione.form']['etc']['tabs'], 'progetti.produzione.form.done' );
			arrayInsertSeq( 'progetti.produzione.form', $p['progetti.produzione.form']['etc']['tabs'], 'progetti.produzione.form.planned' );
			arrayInsertSeq( 'progetti.produzione.form', $p['progetti.produzione.form']['etc']['tabs'], 'progetti.produzione.form.sprint' );
			arrayInsertSeq( 'progetti.produzione.form', $p['progetti.produzione.form']['etc']['tabs'], 'progetti.produzione.form.backlog' );
		}

		// RELAZIONI CON IL MODULO COMMERCIALE
		if( in_array( "2000.commerciale", $cf['mods']['active']['array'] ) ) {
			arrayInsertSeq( 'progetti.produzione.form', $p['progetti.produzione.form']['etc']['tabs'], 'progetti.produzione.form.accettazione' );
		}

		// RELAZIONI CON IL MODULO AMMINISTRAZIONE
		if( in_array( "6000.amministrazione", $cf['mods']['active']['array'] ) ) {
			arrayInsertBefore( 'progetti.produzione.form.archiviazione', $p['progetti.produzione.form']['etc']['tabs'], 'progetti.produzione.form.chiusura' );
		}

		// RELAZIONI CON IL MODULO contenuti
		if( in_array( "3000.contenuti", $cf['mods']['active']['array'] ) ) {
			arrayInsertBefore( 'progetti.produzione.form.archiviazione', $p['progetti.produzione.form']['etc']['tabs'], 'progetti.produzione.form.sem');
			arrayInsertBefore( 'progetti.produzione.form.archiviazione', $p['progetti.produzione.form']['etc']['tabs'],'progetti.produzione.form.testo');
		//	arrayInsertBefore( 'progetti.produzione.form.archiviazione', $p['progetti.produzione.form']['etc']['tabs'],'progetti.produzione.form.menu');
			arrayInsertBefore( 'progetti.produzione.form.archiviazione', $p['progetti.produzione.form']['etc']['tabs'],'progetti.produzione.form.immagini');
			arrayInsertBefore( 'progetti.produzione.form.archiviazione', $p['progetti.produzione.form']['etc']['tabs'],'progetti.produzione.form.video');
			arrayInsertBefore( 'progetti.produzione.form.archiviazione', $p['progetti.produzione.form']['etc']['tabs'],'progetti.produzione.form.audio');
			arrayInsertBefore( 'progetti.produzione.form.archiviazione', $p['progetti.produzione.form']['etc']['tabs'],'progetti.produzione.form.file');
			arrayInsertBefore( 'progetti.produzione.form.archiviazione', $p['progetti.produzione.form']['etc']['tabs'],'progetti.produzione.form.macro');
			arrayInsertBefore( 'progetti.produzione.form.archiviazione', $p['progetti.produzione.form']['etc']['tabs'],'progetti.produzione.form.metadati' );
		}

		$p['progetti.produzione.form.sem'] = array(
			'sitemap'		=> false,
			'title'		=> array( $l		=> 'SEM/SMM' ),
			'h1'		=> array( $l		=> 'SEM/SMM' ),
			'parent'		=> array( 'id'		=> 'progetti.produzione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.form.sem.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_progetti.form.sem.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> $p['progetti.produzione.form']['etc']['tabs'] )
		);
		
		// form progetti.produzione testo
		$p['progetti.produzione.form.testo'] = array(
			'sitemap'		=> false,
			'title'		=> array( $l		=> 'testo' ),
			'h1'		=> array( $l		=> 'testo' ),
			'parent'		=> array( 'id'		=> 'progetti.produzione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.form.testo.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_progetti.form.testo.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> $p['progetti.produzione.form']['etc']['tabs'] )
		);
	
		$p['progetti.produzione.form.macro'] = array(
			'sitemap'		=> false,
			'title'		=> array( $l		=> 'macro' ),
			'h1'		=> array( $l		=> 'macro' ),
			'parent'		=> array( 'id'		=> 'progetti.produzione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.form.macro.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_progetti.form.macro.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> $p['progetti.produzione.form']['etc']['tabs'] )
		);
	
		$p['progetti.produzione.form.immagini'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-picture-o" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'immagini' ),
			'h1'		=> array( $l		=> 'immagini' ),
			'parent'		=> array( 'id'		=> 'progetti.produzione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.form.immagini.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_progetti.form.immagini.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> $p['progetti.produzione.form']['etc']['tabs'] )
		);
	
		// form progetti.produzione video
		$p['progetti.produzione.form.video'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-video-camera" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'video' ),
			'h1'		=> array( $l		=> 'video' ),
			'parent'		=> array( 'id'		=> 'progetti.produzione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.form.video.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_progetti.form.video.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> $p['progetti.produzione.form']['etc']['tabs'] )
		);
		
		// form progetti.produzione file
		$p['progetti.produzione.form.file'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-folder-open-o" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'file' ),
			'h1'		=> array( $l		=> 'file' ),
			'parent'		=> array( 'id'		=> 'progetti.produzione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.form.file.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_progetti.form.file.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> $p['progetti.produzione.form']['etc']['tabs'] )
		);
	
		// form progetti.produzione audio
		$p['progetti.produzione.form.audio'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-volume-up" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'audio' ),
			'h1'		=> array( $l		=> 'audio' ),
			'parent'		=> array( 'id'		=> 'progetti.produzione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.form.audio.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_progetti.form.audio.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> $p['progetti.produzione.form']['etc']['tabs'] )
		);
	
		// form progetti.produzione metadati
		$p['progetti.produzione.form.metadati'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-code" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'metadati' ),
			'h1'		=> array( $l		=> 'metadati' ),
			'parent'		=> array( 'id'		=> 'progetti.produzione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.form.metadati.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_progetti.form.metadati.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> $p['progetti.produzione.form']['etc']['tabs'] )
		);

		// form progetti.produzione menu
		$p['progetti.produzione.form.menu'] = array(
			'sitemap'		=> false,
			'title'		=> array( $l		=> 'menu' ),
			'h1'		=> array( $l		=> 'menu' ),
			'parent'		=> array( 'id'		=> 'progetti.produzione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.form.menu.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_progetti.form.menu.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> $p['progetti.produzione.form']['etc']['tabs'] )
		);
	/*
		// gestione todo progetti
		// in relazione con il modulo todo
		$p['progetti.produzione.form.todo'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'todo' ),
			'h1'			=> array( $l		=> 'to-do' ),
			'parent'		=> array( 'id'		=> 'progetti.produzione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.produzione.form.todo.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_progetti.produzione.form.todo.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['progetti.produzione.form']['etc']['tabs'] )
		);
	*/
		// gestione pause pianificazioni progetti
		# NOTA questa va nel modulo pianificazioni
		$p['progetti.produzione.form.pause'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'pause' ),
			'h1'			=> array( $l		=> 'sospensioni' ),
			'parent'		=> array( 'id'		=> 'progetti.produzione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.produzione.form.pause.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_progetti.produzione.form.pause.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['progetti.produzione.form']['etc']['tabs'] )
		);
	/*
		// gestione attività progetti
		// in relazione con il modulo attivita
		$p['progetti.produzione.form.attivita'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'attivita' ),
			'h1'			=> array( $l		=> 'attività' ),
			'parent'		=> array( 'id'		=> 'progetti.produzione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.produzione.form.attivita.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_progetti.produzione.form.attivita.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['progetti.produzione.form']['etc']['tabs'] )
		);
	*/
		// gestione progetti pianificazioni
		# NOTA questa va nel modulo pianificazioni
		$p['progetti.produzione.form.pianificazioni'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'pianificazione' ),
			'icon'			=> '<i class="fa fa-clock-o" aria-hidden="true"></i>',
			'h1'			=> array( $l		=> 'pianificazione' ),
			'parent'		=> array( 'id'		=> 'progetti.produzione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.produzione.form.pianificazioni.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_progetti.produzione.form.pianificazioni.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['progetti.produzione.form']['etc']['tabs'] )
		);

		// gestione progetti accettazione
		$p['progetti.produzione.form.accettazione'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-handshake-o" aria-hidden="true"></i>',
			'title'			=> array( $l		=> 'accettazione' ),
			'h1'			=> array( $l		=> 'accettazione' ),
			'parent'		=> array( 'id'		=> 'progetti.produzione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.produzione.form.accettazione.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_progetti.produzione.form.accettazione.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['progetti.produzione.form']['etc']['tabs'] )
		);

		// gestione progetti chiusura
		$p['progetti.produzione.form.chiusura'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-check-square-o" aria-hidden="true"></i>',
			'title'			=> array( $l		=> 'chiusura' ),
			'h1'			=> array( $l		=> 'chiusura' ),
			'parent'		=> array( 'id'		=> 'progetti.produzione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.produzione.form.chiusura.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_progetti.produzione.form.chiusura.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['progetti.produzione.form']['etc']['tabs'] )
		);

		// gestione progetti archiviazione
		$p['progetti.produzione.form.archiviazione'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-archive" aria-hidden="true"></i>',
			'title'			=> array( $l		=> 'archiviazione' ),
			'h1'			=> array( $l		=> 'archiviazione' ),
			'parent'		=> array( 'id'		=> 'progetti.produzione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.produzione.form.archiviazione.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_progetti.produzione.form.archiviazione.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['progetti.produzione.form']['etc']['tabs'] )
		);

		// gestione progetti tools
		$p['progetti.produzione.form.tools'] = array(
			'sitemap'		=> false,
			'icon'			=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
			'title'			=> array( $l		=> 'azioni' ),
			'h1'			=> array( $l		=> 'azioni' ),
			'parent'		=> array( 'id'		=> 'progetti.produzione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
			'macro'			=> array( $m . '_src/_inc/_macro/_progetti.produzione.form.tools.php' ),
			'etc'			=> array( 'tabs'	=> $p['progetti.produzione.form']['etc']['tabs'] ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) )
		);

		// vista categorie progetti
		$p['categorie.progetti.view'] = array(
			'sitemap'		=> false,
			'title'		=> array( $l		=> 'categorie' ),
			'h1'		=> array( $l		=> 'categorie' ),
			'parent'		=> array( 'id'		=> 'progetti.produzione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
			'macro'		=> array(  $m . '_src/_inc/_macro/_categorie.progetti.view.php' ),
			'etc'		=> array( 'tabs'	=> array( 'categorie.progetti.view' ) ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'categorie' ),
																				'priority'	=> '115' ) ) )									
		);

		// gestione categorie progetti
		$p['categorie.progetti.form'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'gestione' ),
			'h1'			=> array( $l		=> 'gestione' ),
			'parent'		=> array( 'id'		=> 'categorie.progetti.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.progetti.form.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_categorie.progetti.form.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> array(	'categorie.progetti.form',
															'categorie.progetti.form.tools' ) )
		);

		// RELAZIONI CON IL MODULO AMMINISTRAZIONE
		if( in_array( "3000.contenuti", $cf['mods']['active']['array'] ) ) {
			arrayInsertBefore( 'categorie.progetti.form.tools', $p['categorie.progetti.form']['etc']['tabs'], 'categorie.progetti.form.sem');
			arrayInsertBefore( 'categorie.progetti.form.tools', $p['categorie.progetti.form']['etc']['tabs'], 'categorie.progetti.form.testo');
		//	arrayInsertBefore( 'categorie.progetti.form.tools', $p['categorie.progetti.form']['etc']['tabs'], 'categorie.progetti.form.menu');
			arrayInsertBefore( 'categorie.progetti.form.tools', $p['categorie.progetti.form']['etc']['tabs'], 'categorie.progetti.form.immagini');
			arrayInsertBefore( 'categorie.progetti.form.tools', $p['categorie.progetti.form']['etc']['tabs'], 'categorie.progetti.form.video');
			arrayInsertBefore( 'categorie.progetti.form.tools', $p['categorie.progetti.form']['etc']['tabs'], 'categorie.progetti.form.audio');
			arrayInsertBefore( 'categorie.progetti.form.tools', $p['categorie.progetti.form']['etc']['tabs'], 'categorie.progetti.form.file');
			arrayInsertBefore( 'categorie.progetti.form.tools', $p['categorie.progetti.form']['etc']['tabs'], 'categorie.progetti.form.macro');
			arrayInsertBefore( 'categorie.progetti.form.tools', $p['categorie.progetti.form']['etc']['tabs'], 'categorie.progetti.form.metadati' );
		}

		$p['categorie.progetti.form.sem'] = array(
			'sitemap'		=> false,
			'title'		=> array( $l		=> 'SEM/SMM' ),
			'h1'		=> array( $l		=> 'SEM/SMM' ),
			'parent'		=> array( 'id'		=> 'categorie.progetti.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.progetti.form.sem.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_categorie.progetti.form.sem.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> $p['categorie.progetti.form']['etc']['tabs'] )
		);
		
		// form categorie.progetti testo
		$p['categorie.progetti.form.testo'] = array(
			'sitemap'		=> false,
			'title'		=> array( $l		=> 'testo' ),
			'h1'		=> array( $l		=> 'testo' ),
			'parent'		=> array( 'id'		=> 'categorie.progetti.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.progetti.form.testo.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_categorie.progetti.form.testo.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> $p['categorie.progetti.form']['etc']['tabs'] )
		);
	
		$p['categorie.progetti.form.macro'] = array(
			'sitemap'		=> false,
			'title'		=> array( $l		=> 'macro' ),
			'h1'		=> array( $l		=> 'macro' ),
			'parent'		=> array( 'id'		=> 'categorie.progetti.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.progetti.form.macro.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_categorie.progetti.form.macro.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> $p['categorie.progetti.form']['etc']['tabs'] )
		);
	
		$p['categorie.progetti.form.immagini'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-picture-o" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'immagini' ),
			'h1'		=> array( $l		=> 'immagini' ),
			'parent'		=> array( 'id'		=> 'categorie.progetti.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.progetti.form.immagini.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_categorie.progetti.form.immagini.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> $p['categorie.progetti.form']['etc']['tabs'] )
		);
	
		// form categorie.progetti video
		$p['categorie.progetti.form.video'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-video-camera" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'video' ),
			'h1'		=> array( $l		=> 'video' ),
			'parent'		=> array( 'id'		=> 'categorie.progetti.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.progetti.form.video.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_categorie.progetti.form.video.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> $p['categorie.progetti.form']['etc']['tabs'] )
		);
		
		// form categorie.progetti file
		$p['categorie.progetti.form.file'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-folder-open-o" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'file' ),
			'h1'		=> array( $l		=> 'file' ),
			'parent'		=> array( 'id'		=> 'categorie.progetti.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.progetti.form.file.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_categorie.progetti.form.file.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> $p['categorie.progetti.form']['etc']['tabs'] )
		);
	
		// form categorie.progetti audio
		$p['categorie.progetti.form.audio'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-volume-up" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'audio' ),
			'h1'		=> array( $l		=> 'audio' ),
			'parent'		=> array( 'id'		=> 'categorie.progetti.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.progetti.form.audio.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_categorie.progetti.form.audio.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> $p['categorie.progetti.form']['etc']['tabs'] )
		);
	
		// form categorie.progetti metadati
		$p['categorie.progetti.form.metadati'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-code" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'metadati' ),
			'h1'		=> array( $l		=> 'metadati' ),
			'parent'		=> array( 'id'		=> 'categorie.progetti.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.progetti.form.metadati.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_categorie.progetti.form.metadati.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> $p['categorie.progetti.form']['etc']['tabs'] )
		);

		// form categorie.progetti menu
		$p['categorie.progetti.form.menu'] = array(
			'sitemap'		=> false,
			'title'		=> array( $l		=> 'menu' ),
			'h1'		=> array( $l		=> 'menu' ),
			'parent'		=> array( 'id'		=> 'categorie.progetti.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.progetti.form.menu.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_categorie.progetti.form.menu.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> $p['categorie.progetti.form']['etc']['tabs'] )
		);

		// gestione progetti tools
		$p['categorie.progetti.form.tools'] = array(
			'sitemap'		=> false,
			'icon'			=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
			'title'			=> array( $l		=> 'azioni' ),
			'h1'			=> array( $l		=> 'azioni' ),
			'parent'		=> array( 'id'		=> 'categorie.progetti.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
			'macro'			=> array( $m . '_src/_inc/_macro/_categorie.progetti.form.tools.php' ),
			'etc'			=> array( 'tabs'	=> $p['categorie.progetti.form']['etc']['tabs'] ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) )
		);

	}
