<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0900.progetti/';

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

	// RELAZIONI CON IL MODULO ATTIVITA
	if( in_array( "1100.attivita", $cf['mods']['active']['array'] ) ) {
		arrayInsertSeq( 'progetti.produzione.form', $p['progetti.produzione.form']['etc']['tabs'], 'progetti.produzione.form.attivita' );
	}

	// RELAZIONI CON IL MODULO TODO
	if( in_array( "1200.todo", $cf['mods']['active']['array'] ) ) {
		arrayInsertSeq( 'progetti.produzione.form', $p['progetti.produzione.form']['etc']['tabs'], 'progetti.produzione.form.todo' );
	}

	// RELAZIONI CON IL MODULO COMMERCIALE
	if( in_array( "2000.commerciale", $cf['mods']['active']['array'] ) ) {
		arrayInsertSeq( 'progetti.produzione.form', $p['progetti.produzione.form']['etc']['tabs'], 'progetti.produzione.form.accettazione' );
	}

	// RELAZIONI CON IL MODULO AMMINISTRAZIONE
	if( in_array( "6000.amministrazione", $cf['mods']['active']['array'] ) ) {
		arrayInsertBefore( 'progetti.produzione.form.archiviazione', $p['progetti.produzione.form']['etc']['tabs'], 'progetti.produzione.form.chiusura' );
	}

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
		'etc'			=> array( 'tabs'	=> array(	'categorie.progetti.form' ) )
	);
