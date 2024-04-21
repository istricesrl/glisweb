<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0900.progetti/';

		// vista progetti
		$p['progetti.view'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'progetti' ),
			'h1'			=> array( $l		=> 'progetti' ),
			'parent'		=> array( 'id'		=> 'archivio.produzione' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
			'macro'			=> array( $m . '_src/_inc/_macro/_progetti.view.php' ),
			'etc'			=> array( 'tabs'	=> array( 'progetti.view', 'progetti.archivio.view', 'progetti.tools' ) ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'progetti' ),
																			'priority'	=> '380' ) ) )									
		);

		// vista progetti 
		$p['progetti.archivio.view'] = array(
			'sitemap'		=> false,
			'icon'			=> '<i class="fa fa-archive" aria-hidden="true"></i>',
			'title'			=> array( $l		=> 'archivio' ),
			'h1'			=> array( $l		=> 'archivio' ),
			'parent'		=> array( 'id'		=> 'archivio.produzione' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
			'macro'			=> array( $m . '_src/_inc/_macro/_progetti.archivio.view.php' ),
			'etc'			=> array( 'tabs'	=> $p['progetti.view']['etc']['tabs'] ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) )
		);

		// progetti tools
		$p['progetti.tools'] = array(
			'sitemap'		=> false,
			'icon'			=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
			'title'			=> array( $l		=> 'azioni progetti' ),
			'h1'			=> array( $l		=> 'azioni' ),
			'parent'		=> array( 'id'		=> 'archivio.produzione' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
			'macro'			=> array( $m . '_src/_inc/_macro/_progetti.tools.php' ),
			'etc'			=> array( 'tabs'	=> $p['progetti.view']['etc']['tabs'] ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) )
		);

		// gestione progetti
		$p['progetti.form'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'gestione' ),
			'h1'			=> array( $l		=> 'gestione' ),
			'parent'		=> array( 'id'		=> 'progetti.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.form.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_progetti.form.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> array(	'progetti.form', 
														/*	'progetti.form.mastri',*/
	#														'progetti.form.todo',
	# NOTA questa va nel modulo pianificazioni
	#														'progetti.form.pause',
															'progetti.form.file',
															'progetti.form.archiviazione',
	# NOTA questa va nel modulo pianificazioni
	#														'progetti.form.pianificazioni',
															
															'progetti.form.tools' ) )
		);

		// RELAZIONI CON IL MODULO MATRICOLE
		if( in_array( "4110.matricole", $cf['mods']['active']['array'] ) ) {
			arrayInsertSeq( 'progetti.form', $p['progetti.form']['etc']['tabs'], 'progetti.form.matricole' );
		}

		// RELAZIONI CON IL MODULO COMMERCIALE
		if( in_array( "2000.commerciale", $cf['mods']['active']['array'] ) ) {
			arrayInsertSeq( 'progetti.form', $p['progetti.form']['etc']['tabs'], 'progetti.form.accettazione' );
		}

		// RELAZIONI CON IL MODULO ATTIVITA
		if( in_array( "0200.attivita", $cf['mods']['active']['array'] ) ) {
			arrayInsertSeq( 'progetti.form', $p['progetti.form']['etc']['tabs'], 'progetti.form.attivita' );
		}

		// RELAZIONI CON IL MODULO MASTRI
		if( in_array( "0500.mastri", $cf['mods']['active']['array'] ) ) {
			arrayInsertSeq( 'progetti.form', $p['progetti.form']['etc']['tabs'], 'progetti.form.mastri' );
		}

		// RELAZIONI CON IL MODULO TODO
		if( in_array( "1200.todo", $cf['mods']['active']['array'] ) ) {
			arrayInsertSeq( 'progetti.form', $p['progetti.form']['etc']['tabs'], 'progetti.form.done' );
			arrayInsertSeq( 'progetti.form', $p['progetti.form']['etc']['tabs'], 'progetti.form.planned' );
			arrayInsertSeq( 'progetti.form', $p['progetti.form']['etc']['tabs'], 'progetti.form.sprint' );
			arrayInsertSeq( 'progetti.form', $p['progetti.form']['etc']['tabs'], 'progetti.form.backlog' );
		}

		// RELAZIONI CON IL MODULO AMMINISTRAZIONE
		if( in_array( "6000.amministrazione", $cf['mods']['active']['array'] ) ) {
			arrayInsertBefore( 'progetti.form.archiviazione', $p['progetti.form']['etc']['tabs'], 'progetti.form.chiusura' );
		}

		// RELAZIONI CON IL MODULO DOCUMENTI
		if( in_array( "0400.documenti", $cf['mods']['active']['array'] ) ) {
			// arrayInsertBefore( 'progetti.form.immagini', $p['progetti.form']['etc']['tabs'], 'progetti.form.documenti' );
			arrayInsertBefore( 'progetti.form.file', $p['progetti.form']['etc']['tabs'], 'progetti.form.documenti.righe' );
		}

		// RELAZIONI CON IL MODULO contenuti
		if( in_array( "3000.contenuti", $cf['mods']['active']['array'] ) ) {
			arrayInsertBefore( 'progetti.form.file', $p['progetti.form']['etc']['tabs'], 'progetti.form.web');
			arrayInsertBefore( 'progetti.form.file', $p['progetti.form']['etc']['tabs'], 'progetti.form.sem');
			arrayInsertBefore( 'progetti.form.file', $p['progetti.form']['etc']['tabs'], 'progetti.form.testo');
		//	arrayInsertBefore( 'progetti.form.archiviazione', $p['progetti.form']['etc']['tabs'], 'progetti.form.menu');
			arrayInsertBefore( 'progetti.form.file', $p['progetti.form']['etc']['tabs'], 'progetti.form.immagini');
			arrayInsertBefore( 'progetti.form.file', $p['progetti.form']['etc']['tabs'], 'progetti.form.video');
			arrayInsertBefore( 'progetti.form.file', $p['progetti.form']['etc']['tabs'], 'progetti.form.audio');
		//	arrayInsertBefore( 'progetti.form.archiviazione', $p['progetti.form']['etc']['tabs'], 'progetti.form.file');
			arrayInsertBefore( 'progetti.form.chiusura', $p['progetti.form']['etc']['tabs'], 'progetti.form.macro');
			arrayInsertBefore( 'progetti.form.chiusura', $p['progetti.form']['etc']['tabs'], 'progetti.form.metadati' );
		}

		// RELAZIONI CON IL MODULO PIANIFICAZIONI
		if( in_array( "0100.pianificazioni", $cf['mods']['active']['array'] ) ) {
			arrayInsertBefore( 'progetti.form.chiusura', $p['progetti.form']['etc']['tabs'], 'progetti.form.pianificazioni' );
		}

		$p['progetti.form.web'] = array(
			'sitemap'		=> false,
			'icon'			=> '<i class="fa fa-chrome" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'web' ),
			'h1'		=> array( $l		=> 'web' ),
			'parent'		=> array( 'id'		=> 'progetti.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.form.web.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_progetti.form.web.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> $p['progetti.form']['etc']['tabs'] )
		);

		$p['progetti.form.sem'] = array(
			'sitemap'		=> false,
			'icon'			=> '<i class="fa fa-google" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'SEM/SMM' ),
			'h1'		=> array( $l		=> 'SEM/SMM' ),
			'parent'		=> array( 'id'		=> 'progetti.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.form.sem.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_progetti.form.sem.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> $p['progetti.form']['etc']['tabs'] )
		);

		// form progetti testo
		$p['progetti.form.testo'] = array(
			'sitemap'		=> false,
			'icon'			=> '<i class="fa fa-file-text-o" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'testo' ),
			'h1'		=> array( $l		=> 'testo' ),
			'parent'		=> array( 'id'		=> 'progetti.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.form.testo.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_progetti.form.testo.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> $p['progetti.form']['etc']['tabs'] )
		);
	
		$p['progetti.form.macro'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-caret-square-o-right" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'macro' ),
			'h1'		=> array( $l		=> 'macro' ),
			'parent'		=> array( 'id'		=> 'progetti.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.form.macro.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_progetti.form.macro.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> $p['progetti.form']['etc']['tabs'] )
		);
	
        $p['progetti.form.pianificazioni'] = array(
            'sitemap'		=> false,
            'icon'		=> '<i class="fa fa-clock-o" aria-hidden="true"></i>',
            'title'		=> array( $l		=> 'pianificazioni' ),
            'h1'		=> array( $l		=> 'pianificazioni' ),
            'parent'		=> array( 'id'		=> 'progetti.view' ),
            'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.form.pianificazioni.html' ),
            'macro'		=> array( $m . '_src/_inc/_macro/_progetti.form.pianificazioni.php' ),
            'auth'		=> array( 'groups'	=> array(	'roots' ) ),
            'etc'		=> array( 'tabs'	=> $p['progetti.form']['etc']['tabs'] )
        );

    $p['progetti.form.documenti'] = array(
    	'sitemap'		=> false,
        'icon'			=> '<i class="fa fa-files-o" aria-hidden="true"></i>',
        'title'			=> array( $l		=> 'documenti progetti' ),
        'h1'			=> array( $l		=> 'documenti progetti' ),
        'parent'		=> array( 'id'		=> 'progetti.view' ),
        'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.form.documenti.html' ),
        'macro'			=> array( $m . '_src/_inc/_macro/_progetti.form.documenti.php' ),
        'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
        'etc'			=> array( 'tabs'	=> 'progetti.form' )
    );

    $p['progetti.form.documenti.righe'] = array(
    	'sitemap'		=> false,
        'icon'			=> '<i class="fa fa-list" aria-hidden="true"></i>',
        'title'			=> array( $l		=> 'righe documenti progetti' ),
        'h1'			=> array( $l		=> 'righe documenti progetti' ),
        'parent'		=> array( 'id'		=> 'progetti.view' ),
        'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.form.documenti.righe.html' ),
        'macro'			=> array( $m . '_src/_inc/_macro/_progetti.form.documenti.righe.php' ),
        'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
        'etc'			=> array( 'tabs'	=> 'progetti.form' )
    );

		$p['progetti.form.immagini'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-picture-o" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'immagini' ),
			'h1'		=> array( $l		=> 'immagini' ),
			'parent'		=> array( 'id'		=> 'progetti.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.form.immagini.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_progetti.form.immagini.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> $p['progetti.form']['etc']['tabs'] )
		);
	
		// form progetti video
		$p['progetti.form.video'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-video-camera" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'video' ),
			'h1'		=> array( $l		=> 'video' ),
			'parent'		=> array( 'id'		=> 'progetti.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.form.video.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_progetti.form.video.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> $p['progetti.form']['etc']['tabs'] )
		);
		
		// form progetti file
		$p['progetti.form.file'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-folder-open-o" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'file' ),
			'h1'		=> array( $l		=> 'file' ),
			'parent'		=> array( 'id'		=> 'progetti.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.form.file.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_progetti.form.file.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> $p['progetti.form']['etc']['tabs'] )
		);
	
		// form progetti audio
		$p['progetti.form.audio'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-volume-up" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'audio' ),
			'h1'		=> array( $l		=> 'audio' ),
			'parent'		=> array( 'id'		=> 'progetti.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.form.audio.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_progetti.form.audio.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> $p['progetti.form']['etc']['tabs'] )
		);
	
		// form progetti metadati
		$p['progetti.form.metadati'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-code" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'metadati' ),
			'h1'		=> array( $l		=> 'metadati' ),
			'parent'		=> array( 'id'		=> 'progetti.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.form.metadati.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_progetti.form.metadati.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> $p['progetti.form']['etc']['tabs'] )
		);

		// form progetti menu
		$p['progetti.form.menu'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-bars" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'menu' ),
			'h1'		=> array( $l		=> 'menu' ),
			'parent'		=> array( 'id'		=> 'progetti.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.form.menu.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_progetti.form.menu.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> $p['progetti.form']['etc']['tabs'] )
		);
	/*
		// gestione todo progetti
		// in relazione con il modulo todo
		$p['progetti.form.todo'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'todo' ),
			'h1'			=> array( $l		=> 'to-do' ),
			'parent'		=> array( 'id'		=> 'progetti.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.form.todo.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_progetti.form.todo.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['progetti.form']['etc']['tabs'] )
		);
	*/
		// gestione pause pianificazioni progetti
		# NOTA questa va nel modulo pianificazioni
		$p['progetti.form.pause'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'pause' ),
			'h1'			=> array( $l		=> 'sospensioni' ),
			'parent'		=> array( 'id'		=> 'progetti.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.form.pause.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_progetti.form.pause.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['progetti.form']['etc']['tabs'] )
		);
	/*
		// gestione attività progetti
		// in relazione con il modulo attivita
		$p['progetti.form.attivita'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'attivita' ),
			'h1'			=> array( $l		=> 'attività' ),
			'parent'		=> array( 'id'		=> 'progetti.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.form.attivita.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_progetti.form.attivita.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['progetti.form']['etc']['tabs'] )
		);
	*/
		// gestione progetti pianificazioni
		# NOTA questa va nel modulo pianificazioni
		$p['progetti.form.pianificazioni'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'pianificazione' ),
			'icon'			=> '<i class="fa fa-clock-o" aria-hidden="true"></i>',
			'h1'			=> array( $l		=> 'pianificazione' ),
			'parent'		=> array( 'id'		=> 'progetti.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.form.pianificazioni.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_progetti.form.pianificazioni.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['progetti.form']['etc']['tabs'] )
		);

		// gestione progetti accettazione
		$p['progetti.form.accettazione'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-thumbs-o-up" aria-hidden="true"></i>',
			'title'			=> array( $l		=> 'accettazione' ),
			'h1'			=> array( $l		=> 'accettazione' ),
			'parent'		=> array( 'id'		=> 'progetti.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.form.accettazione.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_progetti.form.accettazione.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['progetti.form']['etc']['tabs'] )
		);

		// gestione progetti chiusura
		$p['progetti.form.chiusura'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-check-square-o" aria-hidden="true"></i>',
			'title'			=> array( $l		=> 'chiusura' ),
			'h1'			=> array( $l		=> 'chiusura' ),
			'parent'		=> array( 'id'		=> 'progetti.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.form.chiusura.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_progetti.form.chiusura.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['progetti.form']['etc']['tabs'] )
		);

		// gestione progetti archiviazione
		$p['progetti.form.archiviazione'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-archive" aria-hidden="true"></i>',
			'title'			=> array( $l		=> 'archiviazione' ),
			'h1'			=> array( $l		=> 'archiviazione' ),
			'parent'		=> array( 'id'		=> 'progetti.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.form.archiviazione.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_progetti.form.archiviazione.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['progetti.form']['etc']['tabs'] )
		);

		// gestione progetti tools
		$p['progetti.form.tools'] = array(
			'sitemap'		=> false,
			'icon'			=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
			'title'			=> array( $l		=> 'azioni' ),
			'h1'			=> array( $l		=> 'azioni' ),
			'parent'		=> array( 'id'		=> 'progetti.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
			'macro'			=> array( $m . '_src/_inc/_macro/_progetti.form.tools.php' ),
			'etc'			=> array( 'tabs'	=> $p['progetti.form']['etc']['tabs'] ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) )
		);

		// vista categorie progetti
		$p['categorie.progetti.view'] = array(
			'sitemap'		=> false,
			'title'		=> array( $l		=> 'categorie' ),
			'h1'		=> array( $l		=> 'categorie' ),
			'parent'		=> array( 'id'		=> 'progetti.view' ),
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
			arrayInsertBefore( 'categorie.progetti.form.tools', $p['categorie.progetti.form']['etc']['tabs'], 'categorie.progetti.form.web');
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

		$p['categorie.progetti.form.web'] = array(
			'sitemap'		=> false,
			'icon'			=> '<i class="fa fa-chrome" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'web' ),
			'h1'		=> array( $l		=> 'web' ),
			'parent'		=> array( 'id'		=> 'categorie.progetti.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.progetti.form.web.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_categorie.progetti.form.web.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> $p['categorie.progetti.form']['etc']['tabs'] )
		);

		$p['categorie.progetti.form.sem'] = array(
			'sitemap'		=> false,
			'icon'			=> '<i class="fa fa-google" aria-hidden="true"></i>',
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
			'icon'			=> '<i class="fa fa-file-text-o" aria-hidden="true"></i>',
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
			'icon'		=> '<i class="fa fa-caret-square-o-right" aria-hidden="true"></i>',
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
			'icon'		=> '<i class="fa fa-bars" aria-hidden="true"></i>',
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

