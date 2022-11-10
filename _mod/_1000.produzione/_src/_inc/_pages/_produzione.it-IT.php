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
		'etc'			=> array( 'tabs'	=> array(	'produzione',
														'produzione.pacchetti',	// TODO in relazione col modulo mastri
														'produzione.contratti'	// TODO in relazione col modulo contratti?
														 ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'produzione' ),
																		'priority'	=> '200' ) ) )														
	);

	// RELAZIONI CON IL MODULO TODO
	if( in_array( "1200.todo", $cf['mods']['active']['array'] ) ) {
		arrayInsertSeq( 'produzione.contratti', $p['produzione']['etc']['tabs'], 'produzione.done' );
		arrayInsertSeq( 'produzione.contratti', $p['produzione']['etc']['tabs'], 'produzione.planned' );
		arrayInsertSeq( 'produzione.contratti', $p['produzione']['etc']['tabs'], 'produzione.sprint' );
		arrayInsertSeq( 'produzione.contratti', $p['produzione']['etc']['tabs'], 'produzione.backlog' );
	}

	// TODO tutta 'sta cosa dei pacchetti andrebbe nel modulo mastri
	// gestione todo progetti
	$p['produzione.pacchetti'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'pacchetti' ),
		'h1'			=> array( $l		=> 'pacchetti' ),
		'parent'		=> array( 'id'		=> 'produzione' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'produzione.pacchetti.html' ),
		'macro'			=> array( $m.'_src/_inc/_macro/_produzione.pacchetti.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> $p['produzione']['etc']['tabs'] )
	);

	// ...
	$p['produzione.contratti'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'contratti' ),
		'h1'			=> array( $l		=> 'contratti' ),
		'parent'		=> array( 'id'		=> 'produzione' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'produzione.contratti.html' ),
		'macro'			=> array( $m.'_src/_inc/_macro/_produzione.contratti.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> $p['produzione']['etc']['tabs'] )
	);
