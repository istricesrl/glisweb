<?php

	// lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_6000.amministrazione/';

	// dashboard amministrazione
	$p['amministrazione'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'amministrazione' ),
	    'h1'			=> array( $l		=> 'amministrazione' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'amministrazione.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_amministrazione.php' ),
		'etc'			=> array( 'tabs'	=> array(	'amministrazione', 'amministrazione.gestiti', 'amministrazione.tools' ) ),
	    'auth'			=> array( 'groups'	=> array(	'roots' ) ),
		'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'amministrazione' ),
														'priority'	=> '210' ) ) )
	);

	if( in_array( "0100.pianificazioni", $cf['mods']['active']['array'] ) ) {

		arrayInsertSeq( 'amministrazione.gestiti', $p['amministrazione']['etc']['tabs'], 'amministrazione.ricorrente' );

		// dashboard amministrazione
		$p['amministrazione.ricorrente'] = array(
			'sitemap'		=> false,
			'title'		=> array( $l		=> 'ricorrente' ),
			'h1'		=> array( $l		=> 'analisi ricorrente' ),
			'template'	=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'amministrazione.ricorrente.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_amministrazione.ricorrente.php' ),
			'parent'	=> array( 'id'		=> 'amministrazione' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> $p['amministrazione']['etc']['tabs'] )
		);

	}

	if( in_array( "0900.progetti", $cf['mods']['active']['array'] ) ) {

		// dashboard amministrazione
		$p['amministrazione.gestiti'] = array(
			'sitemap'		=> false,
			'title'		=> array( $l		=> 'gestiti' ),
			'h1'		=> array( $l		=> 'gestiti' ),
			'template'	=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'amministrazione.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_amministrazione.gestiti.php' ),
			'parent'	=> array( 'id'		=> 'amministrazione' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> $p['amministrazione']['etc']['tabs'] )
		);

	}

	// tools produzione
	$p['amministrazione.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'amministrazione' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_amministrazione.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['amministrazione']['etc']['tabs'] )
	);
