<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_9000.agenda/';
    
    // dashboard contenuti
	$p['agenda'] = array(
	    'sitemap'	=> false,
	    'title'		=> array( $l		=> 'agenda' ),
	    'h1'		=> array( $l		=> 'agenda' ),
	    'template'	=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'agenda.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_agenda.php' ),
	    'parent'	=> array( 'id'		=> NULL ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> array(	'agenda', 'agenda.stampe' ) ),
		'menu'		=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'agenda' ),
									'priority'	=> '040' ) ) )	
	);

    // stampe agenda
	$p['agenda.stampe'] = array(
	    'sitemap'	=> false,
		'icon'		=> '<i class="fa fa-print" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'stampe_agenda' ),
	    'h1'		=> array( $l		=> 'stampe' ),
	    'parent'	=> array( 'id'		=> 'agenda' ),
	    'template'	=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_agenda.stampe.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['agenda']['etc']['tabs'] )
	);

	// gestione attivita
	$p['agenda.form'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'gestione' ),
	    'h1'			=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'agenda' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'agenda.form.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_agenda.form.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'agenda.form', 'agenda.form.feedback' ) )
	);

	// gestione agenda - feedback
	$p['agenda.form.feedback'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'feedback' ),
	    'h1'			=> array( $l		=> 'feedback' ),
	    'parent'		=> array( 'id'		=> 'agenda' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'agenda.form.feedback.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_agenda.form.feedback.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> $p['agenda.form']['etc']['tabs'] )
	);

	// dashboard contenuti
	$p['agenda.todo.view'] = array(
	    'sitemap'	=> false,
	    'title'		=> array( $l		=> 'todo' ),
	    'h1'		=> array( $l		=> 'todo' ),
	    'template'	=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_agenda.todo.view.php' ),
	    'parent'	=> array( 'id'		=> 'agenda' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> array(	'todo' ) ),
		'menu'		=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'todo' ),
									'priority'	=> '040' ) ) )	
	);

	// gestione attivita
	$p['agenda.todo.form'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'gestione' ),
	    'h1'			=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'agenda.todo.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'agenda.todo.form.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_agenda.todo.form.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'agenda.todo.form',
														'agenda.todo.form.attivita',
														'agenda.todo.form.chiusura',
														'agenda.todo.form.archiviazione',
														'agenda.todo.form.stampe',
														'agenda.todo.form.tools' ) )
	);

	$p['agenda.todo.form.attivita'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'attivita' ),
	    'h1'			=> array( $l		=> 'attivita' ),
	    'parent'		=> array( 'id'		=> 'agenda.todo.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'agenda.todo.form.attivita.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_agenda.todo.form.attivita.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> $p['agenda.todo.form']['etc']['tabs'] )
	);

	// gestione todo tools
	$p['agenda.todo.form.tools'] = array(
		'sitemap'		=> false,
		'icon'			=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
		'title'			=> array( $l		=> 'azioni' ),
		'h1'			=> array( $l		=> 'azioni' ),
		'parent'		=> array( 'id'		=> 'agenda.todo.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_agenda.todo.form.tools.php' ),
		'etc'			=> array( 'tabs'	=> $p['agenda.todo.form']['etc']['tabs'] ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) )
	);

	// gestione anagrafica stampe
	$p['agenda.todo.form.stampe'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-print" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'stampe' ),
	    'h1'		=> array( $l		=> 'stampe' ),
	    'parent'		=> array( 'id'		=> 'agenda.todo.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_agenda.todo.form.stampe.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['agenda.todo.form']['etc']['tabs'] )
	);

	// gestione progetti chiusura
	$p['agenda.todo.form.chiusura'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-check-square-o" aria-hidden="true"></i>',
		'title'			=> array( $l		=> 'chiusura' ),
		'h1'			=> array( $l		=> 'chiusura' ),
		'parent'		=> array( 'id'		=> 'agenda.todo.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'agenda.todo.form.chiusura.html' ),
		'macro'			=> array( $m.'_src/_inc/_macro/_agenda.todo.form.chiusura.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> $p['agenda.todo.form']['etc']['tabs'] )
	);

	// gestione todo archiviazione
	$p['agenda.todo.form.archiviazione'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-archive" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'archiviazione' ),
	    'h1'		=> array( $l		=> 'archiviazione' ),
	    'parent'		=> array( 'id'		=> 'agenda.todo.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'agenda.todo.form.archiviazione.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_agenda.todo.form.archiviazione.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['agenda.todo.form']['etc']['tabs'] )
	);
