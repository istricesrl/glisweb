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
														'produzione.contratti',	// TODO in relazione col modulo contratti?
														'produzione.tools'
														 ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'produzione' ),
																		'priority'	=> '200' ) ) )														
	);

	// RELAZIONI CON IL MODULO ATTIVITÀ
	if( in_array( "0200.attivita", $cf['mods']['active']['array'] ) ) {
		arrayInsertSeq( 'produzione.contratti', $p['produzione']['etc']['tabs'], 'produzione.attivita' );
	}

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

	// TODO questa andrebbe nel modulo contratti?
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

    // tools produzione
	$p['produzione.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'produzione' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_produzione.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['produzione']['etc']['tabs'] )
	);
