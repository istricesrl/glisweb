<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
    $m = DIR_MOD . '_0900.progetti/';

  	// RELAZIONI CON IL MODULO COMMERCIALE
	if( in_array( "2000.commerciale", $cf['mods']['active']['array'] ) ) {

		// vista progetti
		$p['progetti.commerciale.view'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'progetti' ),
			'h1'			=> array( $l		=> 'progetti' ),
			'parent'		=> array( 'id'		=> 'commerciale' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
			'macro'			=> array( $m . '_src/_inc/_macro/_progetti.commerciale.view.php' ),
			'etc'			=> array( 'tabs'	=> array( 'progetti.commerciale.view' ) ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'progetti' ),
															'priority'	=> '080' ) ) )	
		);

		// gestione progetti
		$p['progetti.commerciale.form'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'gestione' ),
			'h1'			=> array( $l		=> 'gestione' ),
			'parent'		=> array( 'id'		=> 'progetti.commerciale.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.commerciale.form.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_progetti.commerciale.form.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> array(	'progetti.commerciale.form', 
														/*	'progetti.commerciale.form.mastri',*/
	#														'progetti.commerciale.form.todo',
	# NOTA questa va nel modulo pianificazioni
	#														'progetti.commerciale.form.pause',
															'progetti.commerciale.form.archiviazione',
	# NOTA questa va nel modulo pianificazioni
	#														'progetti.commerciale.form.pianificazioni',
															
															'progetti.commerciale.form.tools' ) )		);

		// RELAZIONI CON IL MODULO PRODUZIONE
		if( in_array( "1000.produzione", $cf['mods']['active']['array'] ) ) {
			arrayInsertSeq( 'progetti.commerciale.form', $p['progetti.commerciale.form']['etc']['tabs'], 'progetti.commerciale.form.accettazione' );
		}

		// RELAZIONI CON IL MODULO MATRICOLE
		if( in_array( "4110.matricole", $cf['mods']['active']['array'] ) ) {
			arrayInsertSeq( 'progetti.commerciale.form', $p['progetti.commerciale.form']['etc']['tabs'], 'progetti.commerciale.form.matricole' );
		}

		// RELAZIONI CON IL MODULO ATTIVITA
		if( in_array( "0200.attivita", $cf['mods']['active']['array'] ) ) {
			arrayInsertSeq( 'progetti.commerciale.form', $p['progetti.commerciale.form']['etc']['tabs'], 'progetti.commerciale.form.attivita' );
		}

		// RELAZIONI CON IL MODULO TODO
		if( in_array( "1200.todo", $cf['mods']['active']['array'] ) ) {
			arrayInsertSeq( 'progetti.commerciale.form', $p['progetti.commerciale.form']['etc']['tabs'], 'progetti.commerciale.form.todo' );
		}

		/*	
			// gestione todo progetti
			$p['progetti.commerciale.form.todo'] = array(
				'sitemap'		=> false,
				'title'			=> array( $l		=> 'todo' ),
				'h1'			=> array( $l		=> 'to-do' ),
				'parent'		=> array( 'id'		=> 'progetti.commerciale.view' ),
				'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.commerciale.form.todo.html' ),
				'macro'			=> array( $m.'_src/_inc/_macro/_progetti.commerciale.form.todo.php' ),
				'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
				'etc'			=> array( 'tabs'	=> $p['progetti.commerciale.form']['etc']['tabs'] )
			);
		*/

		// RELAZIONI CON IL MODULO contenuti
		if( in_array( "3000.contenuti", $cf['mods']['active']['array'] ) ) {
			arrayInsertBefore( 'progetti.commerciale.form.archiviazione', $p['progetti.commerciale.form']['etc']['tabs'], 'progetti.commerciale.form.sem' );
			arrayInsertBefore( 'progetti.commerciale.form.archiviazione', $p['progetti.commerciale.form']['etc']['tabs'], 'progetti.commerciale.form.testo' );
			arrayInsertBefore( 'progetti.commerciale.form.archiviazione', $p['progetti.commerciale.form']['etc']['tabs'], 'progetti.commerciale.form.immagini' );
			arrayInsertBefore( 'progetti.commerciale.form.archiviazione', $p['progetti.commerciale.form']['etc']['tabs'], 'progetti.commerciale.form.video' );
			arrayInsertBefore( 'progetti.commerciale.form.archiviazione', $p['progetti.commerciale.form']['etc']['tabs'], 'progetti.commerciale.form.audio' );
			arrayInsertBefore( 'progetti.commerciale.form.archiviazione', $p['progetti.commerciale.form']['etc']['tabs'], 'progetti.commerciale.form.file' );
			arrayInsertBefore( 'progetti.commerciale.form.archiviazione', $p['progetti.commerciale.form']['etc']['tabs'], 'progetti.commerciale.form.macro' );
			arrayInsertBefore( 'progetti.commerciale.form.archiviazione', $p['progetti.commerciale.form']['etc']['tabs'], 'progetti.commerciale.form.metadati' );
		}
		
		$p['progetti.commerciale.form.sem'] = array(
			'sitemap'		=> false,
			'icon'			=> '<i class="fa fa-google" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'SEM/SMM' ),
			'h1'		=> array( $l		=> 'SEM/SMM' ),
			'parent'		=> array( 'id'		=> 'progetti.commerciale.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.form.sem.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_progetti.form.sem.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> $p['progetti.commerciale.form']['etc']['tabs'] )
		);
		
		// form progetti.commerciale testo
		$p['progetti.commerciale.form.testo'] = array(
			'sitemap'		=> false,
			'icon'			=> '<i class="fa fa-file-text-o" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'testo' ),
			'h1'		=> array( $l		=> 'testo' ),
			'parent'		=> array( 'id'		=> 'progetti.commerciale.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.form.testo.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_progetti.form.testo.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> $p['progetti.commerciale.form']['etc']['tabs'] )
		);

		$p['progetti.commerciale.form.macro'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-caret-square-o-right" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'macro' ),
			'h1'		=> array( $l		=> 'macro' ),
			'parent'		=> array( 'id'		=> 'progetti.commerciale.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.form.macro.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_progetti.form.macro.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> $p['progetti.commerciale.form']['etc']['tabs'] )
		);

		$p['progetti.commerciale.form.immagini'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-picture-o" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'immagini' ),
			'h1'		=> array( $l		=> 'immagini' ),
			'parent'		=> array( 'id'		=> 'progetti.commerciale.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.form.immagini.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_progetti.form.immagini.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> $p['progetti.commerciale.form']['etc']['tabs'] )
		);

		// form progetti.commerciale video
		$p['progetti.commerciale.form.video'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-video-camera" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'video' ),
			'h1'		=> array( $l		=> 'video' ),
			'parent'		=> array( 'id'		=> 'progetti.commerciale.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.form.video.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_progetti.form.video.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> $p['progetti.commerciale.form']['etc']['tabs'] )
		);
		
		// form progetti.commerciale file
		$p['progetti.commerciale.form.file'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-folder-open-o" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'file' ),
			'h1'		=> array( $l		=> 'file' ),
			'parent'		=> array( 'id'		=> 'progetti.commerciale.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.form.file.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_progetti.form.file.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> $p['progetti.commerciale.form']['etc']['tabs'] )
		);

		// form progetti.commerciale audio
		$p['progetti.commerciale.form.audio'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-volume-up" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'audio' ),
			'h1'		=> array( $l		=> 'audio' ),
			'parent'		=> array( 'id'		=> 'progetti.commerciale.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.form.audio.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_progetti.form.audio.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> $p['progetti.commerciale.form']['etc']['tabs'] )
		);

		// form progetti.commerciale metadati
		$p['progetti.commerciale.form.metadati'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-code" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'metadati' ),
			'h1'		=> array( $l		=> 'metadati' ),
			'parent'		=> array( 'id'		=> 'progetti.commerciale.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.form.metadati.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_progetti.form.metadati.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> $p['progetti.commerciale.form']['etc']['tabs'] )
		);

		// gestione progetti accettazione
		$p['progetti.commerciale.form.accettazione'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-thumbs-o-up" aria-hidden="true"></i>',
			'title'			=> array( $l		=> 'accettazione' ),
			'h1'			=> array( $l		=> 'accettazione' ),
			'parent'		=> array( 'id'		=> 'progetti.commerciale.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.commerciale.form.accettazione.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_progetti.commerciale.form.accettazione.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['progetti.commerciale.form']['etc']['tabs'] )
		);

		// gestione progetti archiviazione
		$p['progetti.commerciale.form.archiviazione'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-archive" aria-hidden="true"></i>',
			'title'			=> array( $l		=> 'archiviazione' ),
			'h1'			=> array( $l		=> 'archiviazione' ),
			'parent'		=> array( 'id'		=> 'progetti.commerciale.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.commerciale.form.archiviazione.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_progetti.commerciale.form.archiviazione.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['progetti.commerciale.form']['etc']['tabs'] )
		);

	}
