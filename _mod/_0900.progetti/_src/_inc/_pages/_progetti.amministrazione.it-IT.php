<?php

	// lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0900.progetti/';

	// RELAZIONI CON IL MODULO AMMINISTRAZIONE
	if( in_array( "6000.amministrazione", $cf['mods']['active']['array'] ) ) {

		// vista progetti
		$p['progetti.amministrazione.view'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'progetti' ),
			'h1'			=> array( $l		=> 'progetti' ),
			'parent'		=> array( 'id'		=> 'amministrazione' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
			'macro'			=> array( $m . '_src/_inc/_macro/_progetti.amministrazione.view.php' ),
			'etc'			=> array( 'tabs'	=> array( 'progetti.amministrazione.view', 'progetti.amministrazione.archivio.view', 'progetti.amministrazione.tools' ) ),
			'auth'			=> array( 'groups'	=> array(	'roots' ) ),
			'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'progetti' ),
																			'priority'	=> '010' ) ) )									
		);

		// vista progetti 
		$p['progetti.amministrazione.archivio.view'] = array(
			'sitemap'		=> false,
			'icon'			=> '<i class="fa fa-archive" aria-hidden="true"></i>',
			'title'			=> array( $l		=> 'archivio' ),
			'h1'			=> array( $l		=> 'archivio' ),
			'parent'		=> array( 'id'		=> 'amministrazione' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
			'macro'			=> array( $m . '_src/_inc/_macro/_progetti.amministrazione.archivio.view.php' ),
			'etc'			=> array( 'tabs'	=> $p['progetti.amministrazione.view']['etc']['tabs'] ),
			'auth'			=> array( 'groups'	=> array(	'roots' ) )
		);

		// progetti tools
		$p['progetti.amministrazione.tools'] = array(
			'sitemap'		=> false,
			'icon'			=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
			'title'			=> array( $l		=> 'azioni progetti' ),
			'h1'			=> array( $l		=> 'azioni' ),
			'parent'		=> array( 'id'		=> 'amministrazione' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
			'macro'			=> array( $m . '_src/_inc/_macro/_progetti.amministrazione.tools.php' ),
			'etc'			=> array( 'tabs'	=> $p['progetti.amministrazione.view']['etc']['tabs'] ),
			'auth'			=> array( 'groups'	=> array(	'roots' ) )
		);

		// gestione progetti
		$p['progetti.amministrazione.form'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'gestione' ),
			'h1'			=> array( $l		=> 'gestione' ),
			'parent'		=> array( 'id'		=> 'progetti.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.amministrazione.form.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_progetti.amministrazione.form.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots' ) ),
			'etc'			=> array( 'tabs'	=> array(	'progetti.amministrazione.form',
															'progetti.amministrazione.form.archiviazione',
															'progetti.amministrazione.form.tools' ) )
		);

		// RELAZIONI CON IL MODULO MATRICOLE
		if( in_array( "4110.matricole", $cf['mods']['active']['array'] ) ) {
			arrayInsertSeq( 'progetti.amministrazione.form', $p['progetti.amministrazione.form']['etc']['tabs'], 'progetti.amministrazione.form.matricole' );
		}

		// RELAZIONI CON IL MODULO ATTIVITA
		if( in_array( "0200.attivita", $cf['mods']['active']['array'] ) ) {
			arrayInsertSeq( 'progetti.amministrazione.form', $p['progetti.amministrazione.form']['etc']['tabs'], 'progetti.amministrazione.form.attivita' );
		}

		// RELAZIONI CON IL MODULO TODO
		if( in_array( "1200.todo", $cf['mods']['active']['array'] ) ) {
			arrayInsertSeq( 'progetti.amministrazione.form', $p['progetti.amministrazione.form']['etc']['tabs'], 'progetti.amministrazione.form.todo' );
		}

		// RELAZIONI CON IL MODULO COMMERCIALE
		if( in_array( "2000.commerciale", $cf['mods']['active']['array'] ) ) {
			arrayInsertBefore( 'progetti.amministrazione.form.archiviazione', $p['progetti.amministrazione.form']['etc']['tabs'], 'progetti.amministrazione.form.accettazione' );
		}

		// RELAZIONI CON IL MODULO PRODUZIONE
		if( in_array( "1000.produzione", $cf['mods']['active']['array'] ) ) {
			arrayInsertBefore( 'progetti.amministrazione.form.archiviazione', $p['progetti.amministrazione.form']['etc']['tabs'], 'progetti.amministrazione.form.chiusura' );
		}

		// RELAZIONI CON IL MODULO contenuti
		if( in_array( "3000.contenuti", $cf['mods']['active']['array'] ) ) {
			arrayInsertBefore( 'progetti.amministrazione.form.archiviazione', $p['progetti.amministrazione.form']['etc']['tabs'], 'progetti.amministrazione.form.sem');
			arrayInsertBefore( 'progetti.amministrazione.form.archiviazione', $p['progetti.amministrazione.form']['etc']['tabs'],'progetti.amministrazione.form.testo');
		//	arrayInsertBefore( 'progetti.amministrazione.form.archiviazione', $p['progetti.amministrazione.form']['etc']['tabs'],'progetti.amministrazione.form.menu');
			arrayInsertBefore( 'progetti.amministrazione.form.archiviazione', $p['progetti.amministrazione.form']['etc']['tabs'],'progetti.amministrazione.form.immagini');
			arrayInsertBefore( 'progetti.amministrazione.form.archiviazione', $p['progetti.amministrazione.form']['etc']['tabs'],'progetti.amministrazione.form.video');
			arrayInsertBefore( 'progetti.amministrazione.form.archiviazione', $p['progetti.amministrazione.form']['etc']['tabs'],'progetti.amministrazione.form.audio');
			arrayInsertBefore( 'progetti.amministrazione.form.archiviazione', $p['progetti.amministrazione.form']['etc']['tabs'],'progetti.amministrazione.form.file');
			arrayInsertBefore( 'progetti.amministrazione.form.archiviazione', $p['progetti.amministrazione.form']['etc']['tabs'],'progetti.amministrazione.form.macro');
			arrayInsertBefore( 'progetti.amministrazione.form.archiviazione', $p['progetti.amministrazione.form']['etc']['tabs'],'progetti.amministrazione.form.metadati' );
		}
	/*
		// gestione todo progetti
		// in relazione con il modulo todo
		// TODO spostare con la sua macro e il suo schema nel modulo todo
		$p['progetti.amministrazione.form.todo'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'todo' ),
			'h1'			=> array( $l		=> 'to-do' ),
			'parent'		=> array( 'id'		=> 'progetti.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.amministrazione.form.todo.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_progetti.amministrazione.form.todo.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots' ) ),
			'etc'			=> array( 'tabs'	=> $p['progetti.amministrazione.form']['etc']['tabs'] )
		);
	*/
	/*
		// gestione attività progetti
		// in relazione con il modulo attivita
		// TODO spostare con la sua macro e il suo schema nel modulo attivita
		$p['progetti.amministrazione.form.attivita'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'attivita' ),
			'h1'			=> array( $l		=> 'attività' ),
			'parent'		=> array( 'id'		=> 'progetti.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.amministrazione.form.attivita.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_progetti.amministrazione.form.attivita.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots' ) ),
			'etc'			=> array( 'tabs'	=> $p['progetti.amministrazione.form']['etc']['tabs'] )
		);
	*/
		// gestione progetti accettazione
		// in relazione con il modulo commerciale
		// TODO spostare con la sua macro e il suo schema nel modulo commerciale
		$p['progetti.amministrazione.form.accettazione'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-thumbs-o-up" aria-hidden="true"></i>',
			'title'			=> array( $l		=> 'accettazione' ),
			'h1'			=> array( $l		=> 'accettazione' ),
			'parent'		=> array( 'id'		=> 'progetti.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.amministrazione.form.accettazione.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_progetti.amministrazione.form.accettazione.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots' ) ),
			'etc'			=> array( 'tabs'	=> $p['progetti.amministrazione.form']['etc']['tabs'] )
		);

		// gestione progetti chiusura
		$p['progetti.amministrazione.form.chiusura'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-check-square-o" aria-hidden="true"></i>',
			'title'			=> array( $l		=> 'chiusura' ),
			'h1'			=> array( $l		=> 'chiusura' ),
			'parent'		=> array( 'id'		=> 'progetti.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.amministrazione.form.chiusura.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_progetti.amministrazione.form.chiusura.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots' ) ),
			'etc'			=> array( 'tabs'	=> $p['progetti.amministrazione.form']['etc']['tabs'] )
		);

		// gestione progetti archiviazione
		$p['progetti.amministrazione.form.archiviazione'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-archive" aria-hidden="true"></i>',
			'title'			=> array( $l		=> 'archiviazione' ),
			'h1'			=> array( $l		=> 'archiviazione' ),
			'parent'		=> array( 'id'		=> 'progetti.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.amministrazione.form.archiviazione.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_progetti.amministrazione.form.archiviazione.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots' ) ),
			'etc'			=> array( 'tabs'	=> $p['progetti.amministrazione.form']['etc']['tabs'] )
		);

		// gestione progetti tools
		$p['progetti.amministrazione.form.tools'] = array(
			'sitemap'		=> false,
			'icon'			=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
			'title'			=> array( $l		=> 'azioni' ),
			'h1'			=> array( $l		=> 'azioni' ),
			'parent'		=> array( 'id'		=> 'progetti.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
			'macro'			=> array( $m . '_src/_inc/_macro/_progetti.amministrazione.form.tools.php' ),
			'etc'			=> array( 'tabs'	=> $p['progetti.amministrazione.form']['etc']['tabs'] ),
			'auth'			=> array( 'groups'	=> array(	'roots' ) )
		);

		$p['progetti.amministrazione.form.sem'] = array(
			'sitemap'		=> false,
			'icon'			=> '<i class="fa fa-google" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'SEM/SMM' ),
			'h1'		=> array( $l		=> 'SEM/SMM' ),
			'parent'		=> array( 'id'		=> 'progetti.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.form.sem.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_progetti.form.sem.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> $p['progetti.amministrazione.form']['etc']['tabs'] )
		);
		
		// form progetti.amministrazione testo
		$p['progetti.amministrazione.form.testo'] = array(
			'sitemap'		=> false,
			'icon'			=> '<i class="fa fa-file-text-o" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'testo' ),
			'h1'		=> array( $l		=> 'testo' ),
			'parent'		=> array( 'id'		=> 'progetti.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.form.testo.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_progetti.form.testo.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> $p['progetti.amministrazione.form']['etc']['tabs'] )
		);
	
		$p['progetti.amministrazione.form.macro'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-caret-square-o-right" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'macro' ),
			'h1'		=> array( $l		=> 'macro' ),
			'parent'		=> array( 'id'		=> 'progetti.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.form.macro.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_progetti.form.macro.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> $p['progetti.amministrazione.form']['etc']['tabs'] )
		);
	
		$p['progetti.amministrazione.form.immagini'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-picture-o" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'immagini' ),
			'h1'		=> array( $l		=> 'immagini' ),
			'parent'		=> array( 'id'		=> 'progetti.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.form.immagini.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_progetti.form.immagini.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> $p['progetti.amministrazione.form']['etc']['tabs'] )
		);
	
		// form progetti.amministrazione video
		$p['progetti.amministrazione.form.video'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-video-camera" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'video' ),
			'h1'		=> array( $l		=> 'video' ),
			'parent'		=> array( 'id'		=> 'progetti.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.form.video.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_progetti.form.video.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> $p['progetti.amministrazione.form']['etc']['tabs'] )
		);
		
		// form progetti.amministrazione file
		$p['progetti.amministrazione.form.file'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-folder-open-o" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'file' ),
			'h1'		=> array( $l		=> 'file' ),
			'parent'		=> array( 'id'		=> 'progetti.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.form.file.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_progetti.form.file.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> $p['progetti.amministrazione.form']['etc']['tabs'] )
		);
	
		// form progetti.amministrazione audio
		$p['progetti.amministrazione.form.audio'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-volume-up" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'audio' ),
			'h1'		=> array( $l		=> 'audio' ),
			'parent'		=> array( 'id'		=> 'progetti.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.form.audio.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_progetti.form.audio.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> $p['progetti.amministrazione.form']['etc']['tabs'] )
		);
	
		// form progetti.amministrazione metadati
		$p['progetti.amministrazione.form.metadati'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-code" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'metadati' ),
			'h1'		=> array( $l		=> 'metadati' ),
			'parent'		=> array( 'id'		=> 'progetti.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.form.metadati.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_progetti.form.metadati.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> $p['progetti.amministrazione.form']['etc']['tabs'] )
		);

	}
