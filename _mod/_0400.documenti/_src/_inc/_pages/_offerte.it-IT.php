<?php

    // modulo di questo file
	$m = DIR_MOD . '_0400.documenti/';

    // RELAZIONI CON IL MODULO COMMERCIALE
	if( in_array( "2000.commerciale", $cf['mods']['active']['array'] ) ) {

		// vista offerte
		$p['offerte.commerciale.view'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'offerte attive' ),
			'h1'			=> array( $l		=> 'offerte attive' ),
			'parent'		=> array( 'id'		=> 'commerciale.documenti.attivi' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
			'macro'			=> array( $m . '_src/_inc/_macro/_offerte.commerciale.view.php' ),
			'etc'			=> array( 'tabs'	=> array(   'offerte.commerciale.view' ) ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'offerte' ),
															'priority'	=> '010' ) ) )	
		);

		// gestione offerte
		$p['offerte.commerciale.form'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'gestione' ),
			'h1'			=> array( $l		=> 'gestione' ),
			'parent'		=> array( 'id'		=> 'offerte.commerciale.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'offerte.commerciale.form.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_offerte.commerciale.form.php' ),
			'js'			=> array( 'internal' => array( '_mod/_0400.documenti/_src/_templates/_athena/src/js/documenti.js' ) ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> array(	'offerte.commerciale.form',
															// 'offerte.commerciale.form.relazioni',
															// 'offerte.commerciale.form.ordine',
															'offerte.commerciale.form.righe',
															// 'offerte.commerciale.form.packing',
															// 'offerte.commerciale.form.chiusura',
															'offerte.commerciale.form.stampe',
															'offerte.commerciale.form.tools' ) )
		);

		// gestione relazioni offerte
		$p['offerte.commerciale.form.relazioni'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'relazioni' ),
			'h1'			=> array( $l		=> 'relazioni' ),
			'parent'		=> array( 'id'		=> 'offerte.commerciale.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'offerte.commerciale.form.relazioni.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_offerte.commerciale.form.relazioni.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['offerte.commerciale.form']['etc']['tabs'] )
		);

		// gestione righe ordini
		$p['offerte.commerciale.form.ordine'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'ordine' ),
			'h1'			=> array( $l		=> 'ordine' ),
			'parent'		=> array( 'id'		=> 'offerte.commerciale.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'offerte.commerciale.form.ordine.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_offerte.commerciale.form.ordine.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['offerte.commerciale.form']['etc']['tabs'] )
		);

		// gestione righe offerte
		$p['offerte.commerciale.form.righe'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'righe offerte' ),
			'h1'			=> array( $l		=> 'righe' ),
			'parent'		=> array( 'id'		=> 'offerte.commerciale.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'offerte.commerciale.form.righe.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_offerte.commerciale.form.righe.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['offerte.commerciale.form']['etc']['tabs'] )
		);

		// gestione packing list offerte
		$p['offerte.commerciale.form.packing'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'packing list offerte' ),
			'h1'			=> array( $l		=> 'packing list' ),
			'parent'		=> array( 'id'		=> 'offerte.commerciale.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'offerte.commerciale.form.packing.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_offerte.commerciale.form.packing.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['offerte.commerciale.form']['etc']['tabs'] )
		);

		// gestione chiusura fatture
		$p['offerte.commerciale.form.chiusura'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-check-square-o" aria-hidden="true"></i>',
			'title'			=> array( $l		=> 'chiusura' ),
			'h1'			=> array( $l		=> 'chiusura' ),
			'parent'		=> array( 'id'		=> 'offerte.commerciale.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'offerte.commerciale.form.chiusura.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_offerte.commerciale.form.chiusura.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['offerte.commerciale.form']['etc']['tabs'] )
		);

		$p['offerte.commerciale.form.stampe'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-print" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'stampe' ),
			'h1'		=> array( $l		=> 'stampe' ),
			'parent'		=> array( 'id'		=> 'offerte.commerciale.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
			'macro'		=> array( $m.'_src/_inc/_macro/_offerte.commerciale.form.stampe.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> $p['offerte.commerciale.form']['etc']['tabs'] )
		);

		$p['offerte.commerciale.form.tools'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'strumenti' ),
			'h1'		=> array( $l		=> 'strumenti' ),
			'parent'		=> array( 'id'		=> 'offerte.commerciale.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
			'macro'		=> array( $m.'_src/_inc/_macro/_offerte.commerciale.form.tools.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> $p['offerte.commerciale.form']['etc']['tabs'] )
		);

		// gestione righe offerte
		$p['righe.offerte.commerciale.form'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'gestione righe offerte' ),
			'h1'			=> array( $l		=> 'gestione' ),
			'parent'		=> array( 'id'		=> 'offerte.commerciale.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'righe.offerte.commerciale.form.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_righe.offerte.commerciale.form.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> array(	'righe.offerte.commerciale.form' ) )
		);

    }
