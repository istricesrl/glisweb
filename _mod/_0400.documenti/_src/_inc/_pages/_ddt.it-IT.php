<?php

    // modulo di questo file
	$m = DIR_MOD . '_0400.documenti/';

    // RELAZIONI CON IL MODULO LOGISTICA
	if( in_array( "5000.logistica", $cf['mods']['active']['array'] ) ) {

		// vista ddt
		$p['ddt.magazzini.view'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'DDT attivi' ),
			'h1'			=> array( $l		=> 'DDT attivi' ),
			'parent'		=> array( 'id'		=> 'logistica.documenti.attivi' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
			'macro'			=> array( $m . '_src/_inc/_macro/_ddt.magazzini.view.php' ),
			'etc'			=> array( 'tabs'	=> array(   'ddt.magazzini.view' ) ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'DDT' ),
															'priority'	=> '010' ) ) )	
		);

		// gestione ddt
		$p['ddt.magazzini.form'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'gestione' ),
			'h1'			=> array( $l		=> 'gestione' ),
			'parent'		=> array( 'id'		=> 'ddt.magazzini.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'ddt.magazzini.form.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_ddt.magazzini.form.php' ),
			'js'			=> array( 'internal' => array( '_mod/_0400.documenti/_src/_templates/_athena/src/js/documenti.js' ) ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> array(	'ddt.magazzini.form',
															'ddt.magazzini.form.relazioni',
															'ddt.magazzini.form.ordine',
															'ddt.magazzini.form.righe',
															'ddt.magazzini.form.stampe',
															'ddt.magazzini.form.tools' ) )
		);

		// gestione relazioni ddt
		$p['ddt.magazzini.form.relazioni'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'relazioni' ),
			'h1'			=> array( $l		=> 'relazioni' ),
			'parent'		=> array( 'id'		=> 'ddt.magazzini.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'ddt.magazzini.form.relazioni.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_ddt.magazzini.form.relazioni.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['ddt.magazzini.form']['etc']['tabs'] )
		);

		// gestione righe ordini
		$p['ddt.magazzini.form.ordine'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'ordine' ),
			'h1'			=> array( $l		=> 'ordine' ),
			'parent'		=> array( 'id'		=> 'ddt.magazzini.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'ddt.magazzini.form.ordine.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_ddt.magazzini.form.ordine.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['ddt.magazzini.form']['etc']['tabs'] )
		);

		// gestione righe ddt
		$p['ddt.magazzini.form.righe'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'righe DDT' ),
			'h1'			=> array( $l		=> 'righe' ),
			'parent'		=> array( 'id'		=> 'ddt.magazzini.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'ddt.magazzini.form.righe.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_ddt.magazzini.form.righe.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['ddt.magazzini.form']['etc']['tabs'] )
		);


		$p['ddt.magazzini.form.stampe'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-print" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'stampe' ),
			'h1'		=> array( $l		=> 'stampe' ),
			'parent'		=> array( 'id'		=> 'ddt.magazzini.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
			'macro'		=> array( $m.'_src/_inc/_macro/_ddt.magazzini.form.stampe.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> $p['ddt.magazzini.form']['etc']['tabs'] )
		);
		
		// gestione righe ddt
		$p['ddt.magazzini.righe.form'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'gestione righe DDT' ),
			'h1'			=> array( $l		=> 'gestione' ),
			'parent'		=> array( 'id'		=> 'ddt.magazzini.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'ddt.magazzini.righe.form.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_ddt.magazzini.righe.form.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> array(	'ddt.magazzini.righe.form' ) )
		);

		// vista ddt
		$p['ddt.passivi.magazzini.view'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'DDT passivi' ),
			'h1'			=> array( $l		=> 'DDT passivi' ),
			'parent'		=> array( 'id'		=> 'logistica.documenti.passivi' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
			'macro'			=> array( $m . '_src/_inc/_macro/_ddt.passivi.magazzini.view.php' ),
			'etc'			=> array( 'tabs'	=> array(   'ddt.passivi.magazzini.view' ) ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'DDT' ),
															'priority'	=> '010' ) ) )	
		);

		// gestione ddt
		$p['ddt.passivi.magazzini.form'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'gestione' ),
			'h1'			=> array( $l		=> 'gestione' ),
			'parent'		=> array( 'id'		=> 'ddt.passivi.magazzini.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'ddt.passivi.magazzini.form.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_ddt.passivi.magazzini.form.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> array(	'ddt.passivi.magazzini.form',
															'ddt.passivi.magazzini.form.righe',
															'ddt.passivi.magazzini.form.stampe',
															'ddt.passivi.magazzini.form.tools' ) )
		);

		// gestione righe ddt
		$p['ddt.passivi.magazzini.form.righe'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'righe DDT passivi' ),
			'h1'			=> array( $l		=> 'righe' ),
			'parent'		=> array( 'id'		=> 'ddt.passivi.magazzini.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'ddt.passivi.magazzini.form.righe.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_ddt.passivi.magazzini.form.righe.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['ddt.passivi.magazzini.form']['etc']['tabs'] )
		);

		// gestione ddt_righe
		$p['ddt.passivi.magazzini.righe.form'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'gestione righe DDT passivi' ),
			'h1'			=> array( $l		=> 'gestione' ),
			'parent'		=> array( 'id'		=> 'ddt.passivi.magazzini.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'ddt.passivi.magazzini.righe.form.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_ddt.passivi.magazzini.righe.form.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> array(	'ddt.passivi.magazzini.righe.form' ) )
		);

		$p['ddt.passivi.magazzini.form.stampe'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-print" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'stampe' ),
			'h1'		=> array( $l		=> 'stampe' ),
			'parent'		=> array( 'id'		=> 'ddt.passivi.magazzini.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
			'macro'		=> array( $m.'_src/_inc/_macro/_ddt.magazzini.form.stampe.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> $p['ddt.passivi.magazzini.form']['etc']['tabs'] )
		);
	}
