<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_1200.todo/';

	// RELAZIONI CON IL MODULO PRODUZIONE
	if( in_array( "1000.produzione", $cf['mods']['active']['array'] ) ) {

		// vista todo
		$p['todo.view'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'todo' ),
			'h1'			=> array( $l		=> 'to-do' ),
			'parent'		=> array( 'id'		=> 'produzione' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
			'macro'			=> array( $m . '_src/_inc/_macro/_todo.view.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> array(	'todo.view', 'todo.archivio.view', 'todo.stampe' ) ),
			'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'to-do' ),
															'priority'	=> '090' ) ) )	
		);

		// gestione todo
		$p['todo.form'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'gestione' ),
			'h1'			=> array( $l		=> 'gestione' ),
			'parent'		=> array( 'id'		=> 'todo.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'todo.form.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_todo.form.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> array(	'todo.form', 
	#														'todo.form.attivita',
	#														'todo.form.documenti',
	# NOTA questa scheda dovrebbe essere collegata al modulo pianificazioni
	#														'todo.form.pianificazioni',
	# NOTA questa scheda dovrebbe essere collegata al modulo qualita
	#														'todo.form.feedback',
															'todo.form.chiusura',
															'todo.form.archiviazione',
															'todo.form.stampe',
															'todo.form.tools' ) )
		);

		// RELAZIONI CON IL MODULO ATTIVITA
		if( in_array( "0200.attivita", $cf['mods']['active']['array'] ) ) {
			arrayInsertSeq( 'todo.form', $p['todo.form']['etc']['tabs'], 'todo.form.attivita' );
		}

		$p['todo.form.attivita'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'attivita' ),
			'h1'			=> array( $l		=> 'attivita' ),
			'parent'		=> array( 'id'		=> 'todo.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'todo.form.attivita.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_todo.form.attivita.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['todo.form']['etc']['tabs'] )
		);

		$p['todo.form.documenti'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'documenti' ),
			'h1'			=> array( $l		=> 'documenti' ),
			'parent'		=> array( 'id'		=> 'todo.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'todo.form.documenti.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_todo.form.documenti.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['todo.form']['etc']['tabs'] )
		);

		// gestione todo pianificazioni
		$p['todo.form.pianificazioni'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'pianificazione' ),
			'icon'			=> '<i class="fa fa-clock-o" aria-hidden="true"></i>',
			'h1'			=> array( $l		=> 'pianificazione' ),
			'parent'		=> array( 'id'		=> 'todo.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'todo.form.pianificazioni.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_todo.form.pianificazioni.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['todo.form']['etc']['tabs'] )
		);


		// gestione todo tools
		$p['todo.form.tools'] = array(
			'sitemap'		=> false,
			'icon'			=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
			'title'			=> array( $l		=> 'azioni' ),
			'h1'			=> array( $l		=> 'azioni' ),
			'parent'		=> array( 'id'		=> 'todo.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
			'macro'			=> array( $m . '_src/_inc/_macro/_todo.form.tools.php' ),
			'etc'			=> array( 'tabs'	=> $p['todo.form']['etc']['tabs'] ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) )
		);

		// gestione anagrafica stampe
		$p['todo.form.stampe'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-print" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'stampe_todo' ),
			'h1'		=> array( $l		=> 'stampe_todo' ),
			'parent'		=> array( 'id'		=> 'todo.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_todo.form.stampe.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> $p['todo.form']['etc']['tabs'] )
		);

		// gestione progetti chiusura
		$p['todo.form.chiusura'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-check-square-o" aria-hidden="true"></i>',
			'title'			=> array( $l		=> 'chiusura' ),
			'h1'			=> array( $l		=> 'chiusura' ),
			'parent'		=> array( 'id'		=> 'todo.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'todo.form.chiusura.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_todo.form.chiusura.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['todo.form']['etc']['tabs'] )
		);

		// gestione anagrafica stampe
		$p['todo.form.archiviazione'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-archive" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'archiviazione' ),
			'h1'		=> array( $l		=> 'archiviazione' ),
			'parent'		=> array( 'id'		=> 'todo.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'todo.form.archiviazione.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_todo.form.archiviazione.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> $p['todo.form']['etc']['tabs'] )
		);

		// gestione todo - feedback
		$p['todo.form.feedback'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'feedback' ),
			'h1'			=> array( $l		=> 'feedback' ),
			'parent'		=> array( 'id'		=> 'todo.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'todo.form.feedback.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_todo.form.feedback.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['todo.form']['etc']['tabs'] )
		);

		// vista archivio anagrafica
		$p['todo.archivio.view'] = array(
			'sitemap'			=> false,
			'icon'				=> '<i class="fa fa-archive" aria-hidden="true"></i>',
			'title'				=> array( $l		=> 'archivio' ),
			'h1'				=> array( $l		=> 'archivio' ),
			'parent'			=> array( 'id'		=> 'todo.view' ),
			'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
			'macro'				=> array( $m . '_src/_inc/_macro/_todo.archivio.view.php' ),
			'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'				=> array( 'tabs'	=> $p['todo.view']['etc']['tabs'] )
		);

		// vista archivio anagrafica
		$p['todo.stampe'] = array(
			'sitemap'			=> false,
			'icon'				=> '<i class="fa fa-print" aria-hidden="true"></i>',
			'title'				=> array( $l		=> 'stampe' ),
			'h1'				=> array( $l		=> 'stampe' ),
			'parent'			=> array( 'id'		=> 'todo.view' ),
			'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
			'macro'				=> array( $m . '_src/_inc/_macro/_todo.stampe.php' ),
			'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'				=> array( 'tabs'	=> $p['todo.view']['etc']['tabs'] )
		);

	}

	// RELAZIONI CON IL MODULO AMMINISTRAZIONE
	if( in_array( "6000.amministrazione", $cf['mods']['active']['array'] ) ) {

		// vista todo
		$p['todo.amministrazione.view'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'todo' ),
			'h1'			=> array( $l		=> 'to-do' ),
			'parent'		=> array( 'id'		=> 'amministrazione' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
			'macro'			=> array( $m . '_src/_inc/_macro/_todo.amministrazione.view.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> array(	'todo.amministrazione.view', 'todo.archivio.view', 'todo.stampe' ) ),
			'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'to-do' ),
															'priority'	=> '090' ) ) )	
		);

		// gestione todo
		$p['todo.amministrazione.form'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'gestione' ),
			'h1'			=> array( $l		=> 'gestione' ),
			'parent'		=> array( 'id'		=> 'todo.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'todo.form.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_todo.form.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> array(	'todo.form', 
	#														'todo.form.attivita',
	#														'todo.form.documenti',
	# NOTA questa scheda dovrebbe essere collegata al modulo pianificazioni
	#														'todo.form.pianificazioni',
	# NOTA questa scheda dovrebbe essere collegata al modulo qualita
	#														'todo.form.feedback',
															'todo.form.chiusura',
															'todo.form.archiviazione',
															'todo.form.stampe',
															'todo.form.tools' ) )
		);

		// RELAZIONI CON IL MODULO ATTIVITA
		if( in_array( "0200.attivita", $cf['mods']['active']['array'] ) ) {
			arrayInsertSeq( 'todo.form', $p['todo.amministrazione.form']['etc']['tabs'], 'todo.form.attivita' );
		}

		$p['todo.amministrazione.form.attivita'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'attivita' ),
			'h1'			=> array( $l		=> 'attivita' ),
			'parent'		=> array( 'id'		=> 'todo.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'todo.form.attivita.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_todo.form.attivita.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['todo.amministrazione.form']['etc']['tabs'] )
		);

		$p['todo.amministrazione.form.documenti'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'documenti' ),
			'h1'			=> array( $l		=> 'documenti' ),
			'parent'		=> array( 'id'		=> 'todo.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'todo.form.documenti.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_todo.form.documenti.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['todo.amministrazione.form']['etc']['tabs'] )
		);

		// gestione todo pianificazioni
		$p['todo.amministrazione.form.pianificazioni'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'pianificazione' ),
			'icon'			=> '<i class="fa fa-clock-o" aria-hidden="true"></i>',
			'h1'			=> array( $l		=> 'pianificazione' ),
			'parent'		=> array( 'id'		=> 'todo.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'todo.form.pianificazioni.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_todo.form.pianificazioni.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['todo.amministrazione.form']['etc']['tabs'] )
		);


		// gestione todo tools
		$p['todo.amministrazione.form.tools'] = array(
			'sitemap'		=> false,
			'icon'			=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
			'title'			=> array( $l		=> 'azioni' ),
			'h1'			=> array( $l		=> 'azioni' ),
			'parent'		=> array( 'id'		=> 'todo.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
			'macro'			=> array( $m . '_src/_inc/_macro/_todo.form.tools.php' ),
			'etc'			=> array( 'tabs'	=> $p['todo.amministrazione.form']['etc']['tabs'] ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) )
		);

		// gestione anagrafica stampe
		$p['todo.amministrazione.form.stampe'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-print" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'stampe_todo' ),
			'h1'		=> array( $l		=> 'stampe_todo' ),
			'parent'		=> array( 'id'		=> 'todo.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_todo.form.stampe.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> $p['todo.amministrazione.form']['etc']['tabs'] )
		);

		// gestione progetti chiusura
		$p['todo.amministrazione.form.chiusura'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-check-square-o" aria-hidden="true"></i>',
			'title'			=> array( $l		=> 'chiusura' ),
			'h1'			=> array( $l		=> 'chiusura' ),
			'parent'		=> array( 'id'		=> 'todo.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'todo.form.chiusura.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_todo.form.chiusura.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['todo.amministrazione.form']['etc']['tabs'] )
		);

		// gestione anagrafica stampe
		$p['todo.amministrazione.form.archiviazione'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-archive" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'archiviazione' ),
			'h1'		=> array( $l		=> 'archiviazione' ),
			'parent'		=> array( 'id'		=> 'todo.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'todo.form.archiviazione.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_todo.form.archiviazione.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> $p['todo.amministrazione.form']['etc']['tabs'] )
		);

		// gestione todo - feedback
		$p['todo.amministrazione.form.feedback'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'feedback' ),
			'h1'			=> array( $l		=> 'feedback' ),
			'parent'		=> array( 'id'		=> 'todo.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'todo.form.feedback.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_todo.form.feedback.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['todo.amministrazione.form']['etc']['tabs'] )
		);

		// vista archivio anagrafica
		$p['todo.archivio.view'] = array(
			'sitemap'			=> false,
			'icon'				=> '<i class="fa fa-archive" aria-hidden="true"></i>',
			'title'				=> array( $l		=> 'archivio' ),
			'h1'				=> array( $l		=> 'archivio' ),
			'parent'			=> array( 'id'		=> 'todo.amministrazione.view' ),
			'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
			'macro'				=> array( $m . '_src/_inc/_macro/_todo.archivio.view.php' ),
			'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'				=> array( 'tabs'	=> $p['todo.amministrazione.view']['etc']['tabs'] )
		);

		// vista archivio anagrafica
		$p['todo.stampe'] = array(
			'sitemap'			=> false,
			'icon'				=> '<i class="fa fa-print" aria-hidden="true"></i>',
			'title'				=> array( $l		=> 'stampe' ),
			'h1'				=> array( $l		=> 'stampe' ),
			'parent'			=> array( 'id'		=> 'todo.amministrazione.view' ),
			'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
			'macro'				=> array( $m . '_src/_inc/_macro/_todo.stampe.php' ),
			'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'				=> array( 'tabs'	=> $p['todo.amministrazione.view']['etc']['tabs'] )
		);

	}
