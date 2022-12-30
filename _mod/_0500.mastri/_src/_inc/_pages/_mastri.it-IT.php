<?php

    // modulo di questo file
	$m = DIR_MOD . '_0500.mastri/';

	// vista mastri
	$p['mastri.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'mastri' ),
	    'h1'			=> array( $l		=> 'mastri' ),
	    'parent'		=> array( 'id'		=> 'archivio.amministrazione' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_mastri.view.php' ),
		'etc'			=> array( 'tabs'	=> array(	'mastri.view' ) ),
	    'auth'			=> array( 'groups'	=> array(	'roots' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'mastri' ),
														'priority'	=> '130' ) ) )
	);

	// gestione mastri
	$p['mastri.form'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'gestione' ),
	    'h1'			=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'mastri.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'mastri.form.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_mastri.form.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots' ) ),
		'etc'			=> array( 'tabs'	=> array(	'mastri.form', 'mastri.form.giacenze', 'mastri.form.movimenti', 'mastri.form.stampe', 'mastri.form.tools' ) )
	);

	// vista giacenze mastri
	$p['mastri.form.giacenze'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'giacenze' ),
	    'h1'			=> array( $l		=> 'giacenze' ),
	    'parent'		=> array( 'id'		=> 'mastri.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'mastri.form.giacenze.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_mastri.form.giacenze.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots' ) ),
		'etc'			=> array( 'tabs'	=> $p['mastri.form']['etc']['tabs'] )
	);

	// vista movimenti mastri
	$p['mastri.form.movimenti'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'movimenti' ),
	    'h1'			=> array( $l		=> 'movimenti' ),
	    'parent'		=> array( 'id'		=> 'mastri.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'mastri.form.movimenti.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_mastri.form.movimenti.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots' ) ),
		'etc'			=> array( 'tabs'	=> $p['mastri.form']['etc']['tabs'] )
	);

	// gestione tools mastri
	$p['mastri.form.tools'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'			=> array( $l		=> 'azioni mastri' ),
	    'h1'			=> array( $l		=> 'azioni mastri' ),
	    'parent'		=> array( 'id'		=> 'mastri.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_mastri.form.tools.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots' ) ),
		'etc'			=> array( 'tabs'	=> $p['mastri.form']['etc']['tabs'] )
	);

	// gestione anagrafica stampe
	$p['mastri.form.stampe'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-print" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'stampe' ),
	    'h1'		=> array( $l		=> 'stampe' ),
	    'parent'		=> array( 'id'		=> 'mastri.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'		=> array( $m.'_src/_inc/_macro/_mastri.form.stampe.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> $p['mastri.form']['etc']['tabs'] )
	);

/*
	if( in_array( "1000.produzione", $cf['mods']['active']['array'] ) ){

		// inserimento della tab 'progetti.produzione.form.certificazioni' nelle pagine di form produzione
		arrayInsertSeq( 'progetti.produzione.mastri', $p['progetti.produzione.form']['etc']['tabs'], 'progetti.produzione.form.mastri' );
		
		foreach( $p['progetti.produzione.form']['etc']['tabs'] as $t ){
			$p[ $t ]['etc']['tabs'] = $p['progetti.produzione.form']['etc']['tabs'];
		}

		// gestione todo progetti
		$p['progetti.produzione.form.mastri'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'mastri' ),
			'h1'			=> array( $l		=> 'mastri' ),
			'parent'		=> array( 'id'		=> 'progetti.produzione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.produzione.form.mastri.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_progetti.produzione.form.mastri.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots' ) ),
			'etc'			=> array( 'tabs'	=> $p['progetti.produzione.form']['etc']['tabs'] )
		);
	}

	if( in_array( "4000.catalogo", $cf['mods']['active']['array'] ) ){

		// inserimento della tab 'giacenze' e 'movimenti' nelle pagine di form articoli
		arrayInsertSeq( 'articoli.form.prezzi', $p['articoli.form']['etc']['tabs'], 'articoli.form.giacenze' );
		arrayInsertSeq( 'articoli.form.prezzi', $p['articoli.form']['etc']['tabs'], 'articoli.form.movimenti' );

		foreach( $p['articoli.form']['etc']['tabs'] as $t ){
			$p[ $t ]['etc']['tabs'] = $p['articoli.form']['etc']['tabs'];
		}
		
		// vista giacenze articoli
		$p['articoli.form.giacenze'] = array(
			'sitemap'		=> false,
			'title'		=> array( $l		=> 'giacenze_articoli' ),
			'h1'		=> array( $l		=> 'giacenze' ),
			'parent'		=> array( 'id'		=> 'articoli.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'articoli.form.giacenze.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_articoli.form.giacenze.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> $p['articoli.form']['etc']['tabs'] )
		);

		// vista giacenze articoli
		$p['articoli.form.movimenti'] = array(
			'sitemap'		=> false,
			'title'		=> array( $l		=> 'movimenti_articoli' ),
			'h1'		=> array( $l		=> 'movimenti' ),
			'parent'		=> array( 'id'		=> 'articoli.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'articoli.form.movimenti.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_articoli.form.movimenti.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots' ) ),
			'etc'		=> array( 'tabs'	=> $p['articoli.form']['etc']['tabs'] )
		);

	}
*/
