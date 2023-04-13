<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0200.attivita/';

	// vista attivita
	$p['attivita.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'attivita' ),
	    'h1'			=> array( $l		=> 'attività' ),
	    'parent'		=> array( 'id'		=> 'archivio.produzione' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_attivita.view.php' ),
		'etc'			=> array( 'tabs'	=> array(	'attivita.view', 'cartellini', 'attivita.tools' ) ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'attività' ),
																		'priority'	=> '100' ) ) )	
	);

    // tools attività
	$p['attivita.tools'] = array(
		'sitemap'		=> false,
		'icon'			=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'			=> array( $l		=> 'azioni' ),
	    'h1'			=> array( $l		=> 'azioni' ),
	    'parent'		=> array( 'id'		=> 'attivita.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_attivita.tools.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'			=> array( 'tabs'	=> $p['attivita.view']['etc']['tabs'] )
	);

	// gestione attivita
	$p['attivita.form'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'gestione' ),
	    'h1'			=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'attivita.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'attivita.form.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_attivita.form.php' ),
	    'parser'		=> array( $m . '_src/_inc/_parser/_attivita.form.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'attivita.form',
														'attivita.form.file' ) )
	);

	// form gestione attivita file
	$p['attivita.form.file'] = array(
		'sitemap'		=> false,
		'icon'			=> '<i class="fa fa-folder-open-o" aria-hidden="true"></i>',
		'title'			=> array( $l		=> 'file' ),
		'h1'			=> array( $l		=> 'file' ),
		'parent'		=> array( 'id'		=> 'attivita.form' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'attivita.form.file.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_attivita.form.file.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> $p['attivita.form']['etc']['tabs'] )
	);

/*
	// gestione attivita - feedback
	$p['attivita.form.feedback'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'feedback' ),
	    'h1'			=> array( $l		=> 'feedback' ),
	    'parent'		=> array( 'id'		=> 'attivita.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'attivita.form.feedback.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_attivita.form.feedback.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots' ) ),
		'etc'			=> array( 'tabs'	=> $p['attivita.form']['etc']['tabs'] )
	);


	// vista turni
	$p['turni.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'turni' ),
	    'h1'			=> array( $l		=> 'turni' ),
	    'parent'		=> array( 'id'		=> 'produzione' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_turni.view.php' ),
		'etc'			=> array( 'tabs'	=> array( 'turni.view', 'turni.schema' ) ),
		'auth'			=> array( 'groups'	=> array(	'roots' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'turni' ),
																		'priority'	=> '110' ) ) )	
	);
*/

	// turni tools
	/*$p['turni.tools'] = array(
	    'sitemap'		=> false,
		'title'			=> array( $l		=> 'pianificazione turni' ),
		'icon'			=> '<i class="fa fa-clock-o" aria-hidden="true"></i>',
	    'h1'			=> array( $l		=> 'pianificazione' ),
	    'parent'		=> array( 'id'		=> 'produzione' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'turni.tools.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_turni.tools.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots' ) ),
		'etc'			=> array( 'tabs'	=> $p['turni.view']['etc']['tabs'] )
	);
	*/

/*
	// pagina schema
	$p['turni.schema'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'schema' ),
		'h1'			=> array( $l		=> 'schema' ),
		'parent'		=> array( 'id'		=> 'produzione' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'turni.schema.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_turni.schema.php' ),
		'etc'			=> array( 'tabs'	=> $p['turni.view']['etc']['tabs'] ),
		'auth'			=> array( 'groups'	=> array(	'roots' ) )
	);

	// gestione turni
	$p['turni.form'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'gestione' ),
	    'h1'			=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'turni.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'turni.form.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_turni.form.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots' ) ),
		'etc'			=> array( 'tabs'	=> array(	'turni.form', 'turni.form.pianificazioni' ) )
	);
	
	// gestione turni pianificazioni
	$p['turni.form.pianificazioni'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'pianificazione' ),
		'icon'			=> '<i class="fa fa-clock-o" aria-hidden="true"></i>',
		'h1'			=> array( $l		=> 'pianificazione' ),
		'parent'		=> array( 'id'		=> 'turni.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'turni.form.pianificazioni.html' ),
		'macro'			=> array( $m.'_src/_inc/_macro/_turni.form.pianificazioni.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots' ) ),
		'etc'			=> array( 'tabs'	=> $p['turni.form']['etc']['tabs'] )
	);

	// vista categorie attività - ripristinato solo per todo
	$p['categorie.attivita.view'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'categorie' ),
		'h1'		=> array( $l		=> 'categorie' ),
		'parent'		=> array( 'id'		=> 'attivita.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'		=> array(  $m . '_src/_inc/_macro/_categorie.attivita.view.php' ),
		'etc'		=> array( 'tabs'	=> array( 'categorie.attivita.view' ) ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'menu'		=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'categorie' ),
		'priority'	=> '115' ) ) )
	);

	// gestione categorie attività - rimosso provvisoriamente
	$p['categorie.attivita.form'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'gestione' ),
	    'h1'			=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'categorie.attivita.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.attivita.form.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_categorie.attivita.form.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots' ) ),
		'etc'			=> array( 'tabs'	=> array(	'categorie.attivita.form' ) )
	);
*/

	$p['tipologie.attivita.view'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'tipologie' ),
		'h1'			=> array( $l		=> 'tipologie' ),
		'parent'		=> array( 'id'		=> 'attivita.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array(  $m . '_src/_inc/_macro/_tipologie.attivita.view.php' ),
		'etc'			=> array( 'tabs'	=> array( 'tipologie.attivita.view' ) ),
		'auth'			=> array( 'groups'	=> array(	'roots' ) ),
		'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'tipologie' ),
																		'priority'	=> '115' ) ) )	
	);

	// gestione categorie attività
	$p['tipologie.attivita.form'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'gestione' ),
	    'h1'			=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'tipologie.attivita.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'tipologie.attivita.form.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_tipologie.attivita.form.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots' ) ),
		'etc'			=> array( 'tabs'	=> array(	'tipologie.attivita.form',
														'tipologie.attivita.form.metadati' ) )
	);

	// form tipologie attivita metadati
	$p['tipologie.attivita.form.metadati'] = array(
		'sitemap'		=> false,
		'icon'			=> '<i class="fa fa-code" aria-hidden="true"></i>',
		'title'			=> array( $l		=> 'metadati' ),
		'h1'			=> array( $l		=> 'metadati' ),
		'parent'		=> array( 'id'		=> 'tipologie.attivita.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'tipologie.attivita.form.metadati.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_tipologie.attivita.form.metadati.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots' ) ),
		'etc'			=> array( 'tabs'	=> $p['tipologie.attivita.form']['etc']['tabs'] )
	);