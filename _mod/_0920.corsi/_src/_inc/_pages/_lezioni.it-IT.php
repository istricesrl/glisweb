<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0920.corsi/';

	// RELAZIONI CON IL MODULO CATALOGO
	if( in_array( "4000.catalogo", $cf['mods']['active']['array'] ) ) {

		// dashboard prove
		$p['prove.view'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'prove' ),
			'h1'			=> array( $l		=> 'prove' ),
			'parent'		=> array( 'id'		=> 'corsi.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
			'macro'			=> array( $m . '_src/_inc/_macro/_prove.view.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> array(	'prove.view',
															'prove.lezioni.view',
															'prove.tools' ) ),
			'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'prove' ),
																			'priority'	=> '110' ) ) )														
		);

		// tools prove
		$p['prove.lezioni.view'] = array(
			'sitemap'			=> false,
			'title'				=> array( $l		=> 'lezioni di prova' ),
			'h1'				=> array( $l		=> 'lezioni di prova' ),
			'parent'			=> array( 'id'		=> 'prove.view' ),
			'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
			'macro'				=> array( $m . '_src/_inc/_macro/_prove.lezioni.view.php' ),
			'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'				=> array( 'tabs'	=> $p['prove.view']['etc']['tabs'] )
		);

		// tools prove
		$p['prove.tools'] = array(
			'sitemap'			=> false,
			'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
			'title'				=> array( $l		=> 'azioni' ),
			'h1'				=> array( $l		=> 'azioni' ),
			'parent'			=> array( 'id'		=> 'prove.view' ),
			'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
			'macro'				=> array( $m . '_src/_inc/_macro/_prove.tools.php' ),
			'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'				=> array( 'tabs'	=> $p['prove.view']['etc']['tabs'] )
		);

		// dashboard lezioni
		$p['lezioni.view'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'lezioni' ),
			'h1'			=> array( $l		=> 'lezioni' ),
			'parent'		=> array( 'id'		=> 'catalogo' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
			'macro'			=> array( $m . '_src/_inc/_macro/_lezioni.view.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
/*			'etc'			=> array( 'tabs'	=> array(	'lezioni.view',
															'lezioni.tools' ) ), 
			'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'lezioni' ),
																			'priority'	=> '220' ) ) ) */
			'etc'				=> array( 'tabs'	=> $p['corsi.view']['etc']['tabs'] )
		);

		// tools lezioni
		$p['lezioni.tools'] = array(
			'sitemap'			=> false,
			'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
			'title'				=> array( $l		=> 'azioni' ),
			'h1'				=> array( $l		=> 'azioni' ),
			'parent'			=> array( 'id'		=> 'lezioni.view' ),
			'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
			'macro'				=> array( $m . '_src/_inc/_macro/_lezioni.tools.php' ),
			'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'				=> array( 'tabs'	=> $p['lezioni.view']['etc']['tabs'] )
		);

		// gestione progetti
		$p['lezioni.form'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'gestione' ),
			'h1'			=> array( $l		=> 'gestione' ),
			'parent'		=> array( 'id'		=> 'lezioni.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'lezioni.form.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_lezioni.form.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> array(	'lezioni.form', 
															'lezioni.form.presenze',
															'lezioni.form.tools' ) )
		);

		// gestione progetti
		$p['lezioni.form.presenze'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'presenze' ),
			'h1'			=> array( $l		=> 'presenze' ),
			'parent'		=> array( 'id'		=> 'lezioni.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'lezioni.form.presenze.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_lezioni.form.presenze.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'				=> array( 'tabs'	=> $p['lezioni.form']['etc']['tabs'] )
		);

		// tools lezioni
		$p['lezioni.form.tools'] = array(
			'sitemap'			=> false,
			'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
			'title'				=> array( $l		=> 'azioni corso' ),
			'h1'				=> array( $l		=> 'azioni' ),
			'parent'			=> array( 'id'		=> 'lezioni.view' ),
			'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
			'macro'				=> array( $m . '_src/_inc/_macro/_lezioni.form.tools.php' ),
			'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'				=> array( 'tabs'	=> $p['lezioni.form']['etc']['tabs'] )
		);

		// dashboard prove
		$p['recuperi.view'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'recuperi' ),
			'h1'			=> array( $l		=> 'recuperi' ),
			'parent'		=> array( 'id'		=> 'corsi.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
			'macro'			=> array( $m . '_src/_inc/_macro/_recuperi.view.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> array(	'recuperi.view',
															'recuperi.tools' ) ),
			'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'recuperi' ),
																			'priority'	=> '115' ) ) )														
		);

		// tools prove
		$p['recuperi.tools'] = array(
			'sitemap'			=> false,
			'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
			'title'				=> array( $l		=> 'azioni' ),
			'h1'				=> array( $l		=> 'azioni' ),
			'parent'			=> array( 'id'		=> 'recuperi.view' ),
			'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
			'macro'				=> array( $m . '_src/_inc/_macro/_recuperi.tools.php' ),
			'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'				=> array( 'tabs'	=> $p['recuperi.view']['etc']['tabs'] )
		);

	}
