<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_1000.produzione/';

	// dashboard produzione
	$p['produzione'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'produzione' ),
	    'h1'			=> array( $l		=> 'produzione' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'produzione.html' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_produzione.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'produzione' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'produzione' ),
																		'priority'	=> '200' ) ) )														
	);

	// vista progetti
	$p['progetti.produzione.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'progetti' ),
	    'h1'			=> array( $l		=> 'progetti' ),
	    'parent'		=> array( 'id'		=> 'produzione' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_progetti.produzione.view.php' ),
		'etc'			=> array( 'tabs'	=> array( 'progetti.produzione.view', 'progetti.eliminare.view', 'progetti.produzione.tools' ) ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'progetti' ),
																		'priority'	=> '080' ) ) )									
	);

	// vista progetti eliminare
	$p['progetti.eliminare.view'] = array(
	    'sitemap'		=> false,
	    'icon'			=> '<i class="fa fa-trash" aria-hidden="true"></i>',
		'title'			=> array( $l		=> 'eliminare' ),
	    'h1'			=> array( $l		=> 'eliminare' ),
	    'parent'		=> array( 'id'		=> 'produzione' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_progetti.eliminare.view.php' ),
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
														'progetti.produzione.form.todo',
														'progetti.produzione.form.attivita',
														'progetti.produzione.form.pause',
														'progetti.produzione.form.chiusura',
														'progetti.produzione.form.pianificazioni',
														'progetti.produzione.form.tools' ) )
	);


	// gestione todo progetti
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

	// gestione progetti chiusura
	$p['progetti.produzione.form.chiusura'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'chiusura' ),
		'h1'			=> array( $l		=> 'chiusura' ),
		'parent'		=> array( 'id'		=> 'progetti.produzione.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.produzione.form.chiusura.html' ),
		'macro'			=> array( $m.'_src/_inc/_macro/_progetti.produzione.form.chiusura.php' ),
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


