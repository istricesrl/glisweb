<?php

    // modulo di questo file
	$m = DIR_MOD . '_V900.software/';

    // pagina dell'archivio
	$p['archivio.software'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'archivio software' ),
	    'h1'		=> array( $l		=> 'archivio software' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'archivio.software.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_archivio.software.php' ),
	    'parent'		=> array( 'id'		=> 'archivio' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'archivio.software' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'software' ),
		'priority'	=> '830' ) ) )
	);

	// vista licenze
	$p['licenze.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'licenze' ),
	    'h1'			=> array( $l		=> 'licenze' ),
	    'parent'		=> array( 'id'		=> 'archivio.software' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_licenze.view.php' ),
		'etc'			=> array( 'tabs'	=> array(	'licenze.view',
														'licenze.tools' ) ),
	    'auth'			=> array( 'groups'	=> array(	'roots' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'licenze' ),
														'priority'	=> '100' ) ) )
	);

    // tools licenze
	$p['licenze.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'licenze.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_licenze.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['licenze.view']['etc']['tabs'] )
	);

	// gestione licenze
	$p['licenze.form'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'gestione' ),
	    'h1'			=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'licenze.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'licenze.form.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_licenze.form.php' ),
		'js'			=> array( 'internal' => array( '_mod/_0400.licenze/_src/_templates/_athena/src/js/licenze.js' ) ),
	    'auth'			=> array( 'groups'	=> array(	'roots' ) ),
		'etc'			=> array( 'tabs'	=> array(	'licenze.form', 
/*														'licenze.form.relazioni',
														'licenze.form.righe',
														'licenze.form.pagamenti',
														'licenze.form.invio',
														'licenze.form.chiusura',
*/														'licenze.form.stampe',
														'licenze.form.tools' ) )
	);

/*
	// RELAZIONI CON IL MODULO ATTIVITA
	if( in_array( "0200.attivita", $cf['mods']['active']['array'] ) ) {
		arrayInsertSeq( 'documenti.form', $p['documenti.form']['etc']['tabs'], 'documenti.form.attivita' );
	}

	// gestione tools documenti
	$p['documenti.form.relazioni'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'relazioni documenti' ),
	    'h1'			=> array( $l		=> 'relazioni' ),
	    'parent'		=> array( 'id'		=> 'documenti.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'documenti.form.relazioni.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_documenti.form.relazioni.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots' ) ),
		'etc'			=> array( 'tabs'	=> $p['documenti.form']['etc']['tabs'] )
	);

	// gestione tools documenti
	$p['documenti.form.righe'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'righe documento' ),
	    'h1'			=> array( $l		=> 'righe' ),
	    'parent'		=> array( 'id'		=> 'documenti.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'documenti.form.righe.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_documenti.form.righe.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots' ) ),
		'etc'			=> array( 'tabs'	=> $p['documenti.form']['etc']['tabs'] )
	);

	// gestione xml documenti
	$p['documenti.form.xml'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'xml' ),
	    'h1'			=> array( $l		=> 'xml' ),
	    'parent'		=> array( 'id'		=> 'documenti.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'documenti.form.xml.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_documenti.form.xml.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots' ) ),
		'etc'			=> array( 'tabs'	=> $p['documenti.form']['etc']['tabs'] )
	);

	// gestione pagamenti documenti
	$p['documenti.form.pagamenti'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'pagamenti' ),
	    'h1'			=> array( $l		=> 'pagamenti' ),
	    'parent'		=> array( 'id'		=> 'documenti.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'documenti.form.pagamenti.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_documenti.form.pagamenti.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots' ) ),
		'etc'			=> array( 'tabs'	=> $p['documenti.form']['etc']['tabs'] )
	);

	// gestione chiusura documenti
	$p['documenti.form.invio'] = array(
	    'sitemap'		=> false,
        'icon'		=> '<i class="fa fa-envelope-o" aria-hidden="true"></i>',
	    'title'			=> array( $l		=> 'invio' ),
	    'h1'			=> array( $l		=> 'invio' ),
	    'parent'		=> array( 'id'		=> 'documenti.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'documenti.form.invio.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_documenti.form.invio.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots' ) ),
		'etc'			=> array( 'tabs'	=> $p['documenti.form']['etc']['tabs'] )
	);

	// gestione chiusura documenti
	$p['documenti.form.chiusura'] = array(
	    'sitemap'		=> false,
        'icon'		=> '<i class="fa fa-check-square-o" aria-hidden="true"></i>',
	    'title'			=> array( $l		=> 'chiusura' ),
	    'h1'			=> array( $l		=> 'chiusura' ),
	    'parent'		=> array( 'id'		=> 'documenti.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'documenti.form.chiusura.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_documenti.form.chiusura.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots' ) ),
		'etc'			=> array( 'tabs'	=> $p['documenti.form']['etc']['tabs'] )
	);

	// gestione tools documenti
	$p['documenti.form.tools'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'			=> array( $l		=> 'azioni documenti' ),
	    'h1'			=> array( $l		=> 'azioni documenti' ),
	    'parent'		=> array( 'id'		=> 'documenti.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_documenti.form.tools.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots' ) ),
		'etc'			=> array( 'tabs'	=> $p['documenti.form']['etc']['tabs'] )
	);

	// gestione anagrafica stampe
	$p['documenti.form.stampe'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-print" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'stampe' ),
	    'h1'		=> array( $l		=> 'stampe' ),
	    'parent'		=> array( 'id'		=> 'documenti.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'		=> array( $m.'_src/_inc/_macro/_documenti.form.stampe.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> $p['documenti.form']['etc']['tabs'] )
	);

	// vista documenti_articoli (righe)
	$p['documenti.articoli.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'righe' ),
	    'h1'			=> array( $l		=> 'righe' ),
	    'parent'		=> array( 'id'		=> 'documenti.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_documenti.articoli.view.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots' ) ),
		'etc'			=> array( 'tabs'	=> $p['documenti.view']['etc']['tabs'] )
	);

	// gestione documenti_articoli
	$p['documenti.articoli.form'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'gestione' ),
	    'h1'			=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'documenti.articoli.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'documenti.articoli.form.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_documenti.articoli.form.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots' ) ),
		'etc'			=> array( 'tabs'	=> array(	'documenti.articoli.form','documenti.articoli.form.aggregate','documenti.articoli.form.attivita', 'documenti.articoli.form.tools' ) )
	);

	// gestione tools documenti_articoli - attivita
	$p['documenti.articoli.form.attivita'] = array(
		'sitemap'		=> false,
		'icon'			=> '<i class="fa fa-pencil-square-o" aria-hidden="true"></i>',
		'title'			=> array( $l		=> 'attivita' ),
		'h1'			=> array( $l		=> 'attivita' ),
		'parent'		=> array( 'id'		=> 'documenti.articoli.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'documenti.articoli.form.attivita.html' ),
		'macro'			=> array( $m.'_src/_inc/_macro/_documenti.articoli.form.attivita.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots' ) ),
		'etc'			=> array( 'tabs'	=> $p['documenti.articoli.form']['etc']['tabs'] )
	);

	// gestione tools documenti_articoli - attivita
	$p['documenti.articoli.form.aggregate'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'righe aggregate' ),
			'h1'			=> array( $l		=> 'righe aggregate' ),
			'parent'		=> array( 'id'		=> 'documenti.articoli.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'documenti.articoli.form.aggregate.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_documenti.articoli.form.aggregate.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots' ) ),
			'etc'			=> array( 'tabs'	=> $p['documenti.articoli.form']['etc']['tabs'] )
	);

	// gestione tools documenti_articoli
	$p['documenti.articoli.form.tools'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
		'title'			=> array( $l		=> 'azioni righe' ),
		'h1'			=> array( $l		=> 'azioni righe' ),
		'parent'		=> array( 'id'		=> 'documenti.articoli.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
		'macro'			=> array( $m.'_src/_inc/_macro/_documenti.articoli.form.tools.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots' ) ),
		'etc'			=> array( 'tabs'	=> $p['documenti.articoli.form']['etc']['tabs'] )
	);
*/
