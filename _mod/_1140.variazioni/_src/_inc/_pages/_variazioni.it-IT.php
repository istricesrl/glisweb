<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_1140.variazioni/';

	// vista variazioni
	$p['variazioni.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'variazioni' ),
	    'h1'			=> array( $l		=> 'variazioni' ),
	    'parent'		=> array( 'id'		=> 'produzione' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_variazioni.view.php' ),
		'etc'			=> array( 'tabs'	=> array(	'variazioni.view' ) ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'menu'			=> array( 'admin'	=> array(	'label'		=> array( $l => 'variazioni' ),
														'priority'	=> '115' ) )
	);

    
	// gestione variazioni
	$p['variazioni.form'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'gestione' ),
	    'h1'			=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'variazioni.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'variazioni.form.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_variazioni.form.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'variazioni.form', 'variazioni.form.approvazione' ) )
	);

    // gestione approvazione variazioni
	$p['variazioni.form.approvazione'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'approvazione' ),
	    'h1'			=> array( $l		=> 'approvazione' ),
	    'parent'		=> array( 'id'		=> 'variazioni.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'variazioni.form.approvazione.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_variazioni.form.approvazione.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> $p['variazioni.form']['etc']['tabs'] )
	);

	// view progetti scoperti per sostituzioni
	$p['progetti.scoperti.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'progetti' ),
	    'h1'			=> array( $l		=> 'progetti' ),
	    'parent'		=> array( 'id'		=> 'variazioni.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_progetti.scoperti.view.php' ),
		'etc'			=> array( 'tabs'	=> array(	
													'progetti.scoperti.view', 
													'attivita.scoperte.view', 
													'conferme.view',
													'sostituzioni.view',
													'variazioni.tools' ) ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'menu'			=> array( 'admin'	=> array(	'label'		=> array( $l => 'sostituzioni' ),
														'priority'	=> '120' ) )
	);

	$p['progetti.scoperti.form'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'gestione' ),
	    'h1'			=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'progetti.scoperti.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.scoperti.form.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_progetti.scoperti.form.php' ),
		'etc'			=> array( 'tabs'	=> array( 'progetti.scoperti.form' ) ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) )
	);

	// view attivita scoperte per sostituzioni 
	$p['attivita.scoperte.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'attivita' ),
	    'h1'			=> array( $l		=> 'attivita' ),
	    'parent'		=> array( 'id'		=> 'variazioni.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_attivita.scoperte.view.php' ),
		'etc'			=> array( 'tabs'	=> $p['progetti.scoperti.view']['etc']['tabs'] ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) )
	);

	// form attivita scoperte per sostituzioni 
	$p['attivita.scoperte.form'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'gestione' ),
	    'h1'			=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'attivita.scoperte.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'attivita.scoperte.form.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_attivita.scoperte.form.php' ),
		'etc'			=> array( 'tabs'	=> array( 'attivita.scoperte.form' ) ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) )
	);
    
	// view conferme per operatore
	$p['conferme.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'conferme' ),
	    'h1'			=> array( $l		=> 'conferme' ),
	    'parent'		=> array( 'id'		=> 'variazioni.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'conferme.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_conferme.view.php' ),
		'etc'			=> array( 'tabs'	=> $p['progetti.scoperti.view']['etc']['tabs'] ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) )
	);

	// view per richieste sostituzioni
	$p['sostituzioni.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'richieste' ),
	    'h1'			=> array( $l		=> 'richieste' ),
	    'parent'		=> array( 'id'		=> 'variazioni.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_sostituzioni.view.php' ),
		'etc'			=> array( 'tabs'	=> $p['progetti.scoperti.view']['etc']['tabs'] ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) )
	);

	// vista tipologie variazioni
	$p['tipologie.variazioni.view'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'tipologie' ),
		'h1'		=> array( $l		=> 'tipologie' ),
		'parent'		=> array( 'id'		=> 'variazioni.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'		=> array(  $m . '_src/_inc/_macro/_tipologie.variazioni.view.php' ),
		'etc'		=> array( 'tabs'	=> array( 'tipologie.variazioni.view' ) ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'menu'		=> array( 'admin'	=> array(	'label'		=> array( $l => 'tipologie' ),
									'priority'	=> '115' ) )
	);

	// gestione tipologie variazioni
	$p['tipologie.variazioni.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'tipologie.variazioni.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'tipologie.variazioni.form.html' ),
		'macro'		=> array(  $m . '_src/_inc/_macro/_tipologie.variazioni.form.php' ),
		'etc'		=> array( 'tabs'	=> array( 'tipologie.variazioni.form' ) ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) )		
	);

	// tools per variazioni
	$p['variazioni.tools'] = array(
	    'sitemap'		=> false,
	    'icon'			=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
		'title'			=> array( $l		=> 'azioni' ),
	    'h1'			=> array( $l		=> 'azioni' ),
	    'parent'		=> array( 'id'		=> 'variazioni.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_variazioni.tools.php' ),
		'etc'			=> array( 'tabs'	=> $p['progetti.scoperti.view']['etc']['tabs'] ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) )
	);

