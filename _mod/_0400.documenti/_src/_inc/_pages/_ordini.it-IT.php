<?php

    // modulo di questo file
	$m = DIR_MOD . '_0400.documenti/';

    // RELAZIONI CON IL MODULO LOGISTICA
	if( in_array( "5000.logistica", $cf['mods']['active']['array'] ) ) {

		// vista ddt
		$p['ordini.magazzini.view'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'ordini' ),
			'h1'			=> array( $l		=> 'ordini' ),
			'parent'		=> array( 'id'		=> 'logistica' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
			'macro'			=> array( $m . '_src/_inc/_macro/_ordini.magazzini.view.php' ),
			'etc'			=> array( 'tabs'	=> array(   'ordini.magazzini.view' ) ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'ordini' ),
															'priority'	=> '200' ) ) )	
		);

		// gestione ddt
		$p['ordini.magazzini.form'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'gestione' ),
			'h1'			=> array( $l		=> 'gestione' ),
			'parent'		=> array( 'id'		=> 'ordini.magazzini.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'ordini.magazzini.form.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_ordini.magazzini.form.php' ),
			'js'			=> array( 'internal' => array( '_mod/_0400.documenti/_src/_templates/_athena/src/js/documenti.js' ) ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> array(	'ordini.magazzini.form',
															'ordini.magazzini.form.righe',
															'ordini.magazzini.form.stampe',
															'ordini.magazzini.form.tools' ) )
		);        

        // gestione righe ordini
		$p['ordini.magazzini.form.righe'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'righe ordini' ),
			'h1'			=> array( $l		=> 'righe' ),
			'parent'		=> array( 'id'		=> 'ordini.magazzini.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'ordini.magazzini.form.righe.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_ordini.magazzini.form.righe.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['ordini.magazzini.form']['etc']['tabs'] )
		);

    }
