<?php

	// lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0400.documenti/';

	// vista pagamenti
	$p['pagamenti.view'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'pagamenti_vista' ),
		'h1'			=> array( $l		=> 'pagamenti' ),
		'parent'		=> array( 'id'		=> 'documenti.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_pagamenti.view.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> $p['documenti.view']['etc']['tabs'] )
	);

	// gestione pagamenti
	$p['pagamenti.form'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'gestione' ),
		'h1'			=> array( $l		=> 'gestione' ),
		'parent'		=> array( 'id'		=> 'pagamenti.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'pagamenti.form.html' ),
		'macro'			=> array( $m.'_src/_inc/_macro/_pagamenti.form.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'pagamenti.form' ) )
	);

    // RELAZIONI CON IL MODULO AMMINISTRAZIONE
	if( in_array( "6000.amministrazione", $cf['mods']['active']['array'] ) ) {

		// vista pagamenti
		$p['pagamenti.amministrazione.view'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'scadenziario' ),
			'h1'			=> array( $l		=> 'scadenziario' ),
			'parent'		=> array( 'id'		=> 'amministrazione' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
			'macro'			=> array( $m . '_src/_inc/_macro/_pagamenti.amministrazione.view.php' ),
			'etc'			=> array( 'tabs'	=> array(   'pagamenti.amministrazione.view', 'pagamenti.amministrazione.tools' ) ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'scadenziario' ),
															'priority'	=> '900' ) ) )	
		);

		// gestione pagamenti
		$p['pagamenti.amministrazione.form'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'gestione' ),
			'h1'			=> array( $l		=> 'gestione' ),
			'parent'		=> array( 'id'		=> 'pagamenti.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'pagamenti.amministrazione.form.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_pagamenti.amministrazione.form.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> array(	'pagamenti.form' ) )
		);

		// tools produzione
		$p['pagamenti.amministrazione.tools'] = array(
			'sitemap'			=> false,
			'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
			'title'				=> array( $l		=> 'azioni' ),
			'h1'				=> array( $l		=> 'azioni' ),
			'parent'			=> array( 'id'		=> 'pagamenti.amministrazione.view' ),
			'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
			'macro'				=> array( $m . '_src/_inc/_macro/_pagamenti.amministrazione.tools.php' ),
			'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'				=> array( 'tabs'	=> $p['pagamenti.amministrazione.view']['etc']['tabs'] )
		);

	}
