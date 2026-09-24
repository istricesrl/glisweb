<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_1250.ticket/';

	// vista ticket
	$p['ticket.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'ticket' ),
	    'h1'			=> array( $l		=> 'ticket' ),
	    'parent'		=> array( 'id'		=> 'produzione' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_ticket.view.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'ticket.view', 'ticket.gestiti.view', 'ticket.chiusi.view', 'ticket.archivio.view' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'ticket' ),
														'priority'	=> '120' ) ) )	
	);

	// vista ticket
	$p['ticket.gestiti.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'gestiti' ),
	    'h1'			=> array( $l		=> 'gestiti' ),
	    'parent'		=> array( 'id'		=> 'produzione' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_ticket.gestiti.view.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> $p['ticket.view']['etc']['tabs'] )
	);

	// vista ticket
	$p['ticket.chiusi.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'chiusi' ),
	    'h1'			=> array( $l		=> 'chiusi' ),
	    'parent'		=> array( 'id'		=> 'produzione' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_ticket.chiusi.view.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> $p['ticket.view']['etc']['tabs'] )
	);

	// gestione ticket
	$p['ticket.form'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'gestione' ),
	    'h1'			=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'ticket.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'ticket.form.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_ticket.form.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'ticket.form', 
														'ticket.form.attivita',
														'ticket.form.file',
														'ticket.form.chiusura',
														'ticket.form.archiviazione',
														'ticket.form.tools' 
													) )
	);
/*
	// gestione ticket vista attività
	$p['ticket.form.attivita'] = array(
	    'sitemap'		=> false,
		'icon'			=> '<i class="fa fa-pencil-square-o" aria-hidden="true"></i>',
	    'title'			=> array( $l		=> 'attivita' ),
	    'h1'			=> array( $l		=> 'attivita' ),
	    'parent'		=> array( 'id'		=> 'ticket.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'ticket.form.attivita.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_ticket.form.attivita.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> $p['ticket.form']['etc']['tabs'] )
	);
*/
	// gestione ticket file
	$p['ticket.form.file'] = array(
		'sitemap'	=> false,
		'icon'		=> '<i class="fa fa-folder-open-o" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'file' ),
		'h1'		=> array( $l		=> 'file' ),
		'parent'	=> array( 'id'		=> 'ticket.view' ),
		'template'	=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'ticket.form.file.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_ticket.form.file.php' ),
		'etc'		=> array( 'tabs'	=> $p['ticket.form']['etc']['tabs'] ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) )
	);

	// gestione ticket tools
	$p['ticket.form.tools'] = array(
		'sitemap'		=> false,
		'icon'			=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
		'title'			=> array( $l		=> 'azioni' ),
		'h1'			=> array( $l		=> 'azioni' ),
		'parent'		=> array( 'id'		=> 'ticket.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_ticket.form.tools.php' ),
		'etc'			=> array( 'tabs'	=> $p['ticket.form']['etc']['tabs'] ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) )
	);

	// gestione ticket archiviazione
	$p['ticket.form.chiusura'] = array(
	    'sitemap'		=> false,
		'icon'			=> '<i class="fa fa-check-square-o" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'chiusura' ),
	    'h1'		=> array( $l		=> 'chiusura' ),
	    'parent'		=> array( 'id'		=> 'ticket.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'ticket.form.chiusura.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_ticket.form.chiusura.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['ticket.form']['etc']['tabs'] )
	);

	// gestione ticket archiviazione
	$p['ticket.form.archiviazione'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-archive" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'archiviazione' ),
	    'h1'		=> array( $l		=> 'archiviazione' ),
	    'parent'		=> array( 'id'		=> 'ticket.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'ticket.form.archiviazione.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_ticket.form.archiviazione.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['ticket.form']['etc']['tabs'] )
	);

	// vista archivio ticket
	$p['ticket.archivio.view'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-archive" aria-hidden="true"></i>',
		'title'				=> array( $l		=> 'archivio' ),
		'h1'				=> array( $l		=> 'archivio' ),
		'parent'			=> array( 'id'		=> 'ticket.view' ),
		'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'				=> array( $m . '_src/_inc/_macro/_ticket.archivio.view.php' ),
		'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'				=> array( 'tabs'	=> $p['ticket.view']['etc']['tabs'] )
	);

	// gestione attivita
	$p['attivita.ticket.form'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'gestione attivita' ),
	    'h1'			=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'ticket.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'attivita.ticket.form.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_attivita.ticket.form.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'attivita.ticket.form' ) )
	);

