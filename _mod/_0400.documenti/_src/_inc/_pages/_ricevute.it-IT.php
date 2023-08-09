<?php

	// lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0400.documenti/';

    // RELAZIONI CON IL MODULO AMMINISTRAZIONE
	if( in_array( "6000.amministrazione", $cf['mods']['active']['array'] ) ) {

		// vista ricevute
		$p['ricevute.amministrazione.view'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'ricevute attive' ),
			'h1'			=> array( $l		=> 'ricevute attive' ),
			'parent'		=> array( 'id'		=> 'amministrazione.documenti.attivi' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
			'macro'			=> array( $m . '_src/_inc/_macro/_ricevute.amministrazione.view.php' ),
			'etc'			=> array( 'tabs'	=> array(   'ricevute.amministrazione.view',
															'righe.ricevute.amministrazione.view' ) ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'ricevute' ),
															'priority'	=> '055' ) ) )	
		);

		// vista righe proforma
		$p['righe.ricevute.amministrazione.view'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'righe ricevute attive' ),
			'h1'			=> array( $l		=> 'righe attive' ),
			'parent'		=> array( 'id'		=> 'ricevute.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
			'macro'			=> array( $m . '_src/_inc/_macro/_righe.ricevute.amministrazione.view.php' ),
			'etc'			=> array( 'tabs'	=> $p['ricevute.amministrazione.view']['etc']['tabs'] ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) )
		);

		// gestione ricevute
		$p['ricevute.amministrazione.form'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'gestione' ),
			'h1'			=> array( $l		=> 'gestione' ),
			'parent'		=> array( 'id'		=> 'ricevute.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'ricevute.amministrazione.form.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_ricevute.amministrazione.form.php' ),
			'js'			=> array( 'internal' => array( '_mod/_0400.documenti/_src/_templates/_athena/src/js/documenti.js' ) ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> array(	'ricevute.amministrazione.form',
															'ricevute.amministrazione.form.relazioni',
															'ricevute.amministrazione.form.righe',
															'ricevute.amministrazione.form.pagamenti',
															'ricevute.amministrazione.form.chiusura',
															'ricevute.amministrazione.form.file',
															'ricevute.amministrazione.form.stampe',
															'ricevute.amministrazione.form.tools' ) )
		);

		// RELAZIONI CON IL MODULO ATTIVITA
		if( in_array( "0200.attivita", $cf['mods']['active']['array'] ) ) {
			arrayInsertSeq( 'ricevute.amministrazione.form', $p['ricevute.amministrazione.form']['etc']['tabs'], 'ricevute.amministrazione.form.attivita' );
		}

		// gestione relazioni ricevute
		$p['ricevute.amministrazione.form.relazioni'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'riferimenti fattura' ),
			'h1'			=> array( $l		=> 'riferimenti' ),
			'parent'		=> array( 'id'		=> 'ricevute.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'ricevute.amministrazione.form.relazioni.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_ricevute.amministrazione.form.relazioni.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['ricevute.amministrazione.form']['etc']['tabs'] )
		);

		// gestione righe ricevute
		$p['ricevute.amministrazione.form.righe'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'righe ricevuta' ),
			'h1'			=> array( $l		=> 'righe' ),
			'parent'		=> array( 'id'		=> 'ricevute.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'ricevute.amministrazione.form.righe.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_ricevute.amministrazione.form.righe.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['ricevute.amministrazione.form']['etc']['tabs'] )
		);

		// gestione pagamenti ricevute
		$p['ricevute.amministrazione.form.pagamenti'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'pagamenti' ),
			'h1'			=> array( $l		=> 'pagamenti' ),
			'parent'		=> array( 'id'		=> 'ricevute.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'documenti.form.pagamenti.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_documenti.form.pagamenti.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['ricevute.amministrazione.form']['etc']['tabs'] )
		);

		// gestione ricevute_righe
		$p['righe.ricevute.amministrazione.form'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'gestione righe' ),
			'h1'			=> array( $l		=> 'gestione' ),
			'parent'		=> array( 'id'		=> 'righe.ricevute.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'righe.ricevute.amministrazione.form.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_righe.ricevute.amministrazione.form.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> array(	'righe.ricevute.amministrazione.form', 'righe.ricevute.amministrazione.form.aggregate' ) )
		);

		// gestione tools documenti_articoli - attivita
		$p['righe.ricevute.amministrazione.form.aggregate'] = array(
				'sitemap'		=> false,
				'title'			=> array( $l		=> 'righe aggregate' ),
				'h1'			=> array( $l		=> 'righe aggregate' ),
				'parent'		=> array( 'id'		=> 'righe.ricevute.amministrazione.view' ),
				'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'documenti.articoli.form.aggregate.html' ),
				'macro'			=> array( $m.'_src/_inc/_macro/_documenti.articoli.form.aggregate.php' ),
				'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
				'etc'			=> array( 'tabs'	=> $p['righe.ricevute.amministrazione.form']['etc']['tabs'] )
		);

		// gestione chiusura ricevute
		$p['ricevute.amministrazione.form.chiusura'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-check-square-o" aria-hidden="true"></i>',
			'title'			=> array( $l		=> 'chiusura' ),
			'h1'			=> array( $l		=> 'chiusura' ),
			'parent'		=> array( 'id'		=> 'ricevute.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'ricevute.amministrazione.form.chiusura.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_ricevute.amministrazione.form.chiusura.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['ricevute.amministrazione.form']['etc']['tabs'] )
		);

		// gestione tools ricevute
		$p['ricevute.amministrazione.form.file'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-folder-open-o" aria-hidden="true"></i>',
			'title'			=> array( $l		=> 'file' ),
			'h1'			=> array( $l		=> 'file' ),
			'parent'		=> array( 'id'		=> 'ricevute.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'ricevute.amministrazione.form.file.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_ricevute.amministrazione.form.file.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['ricevute.amministrazione.form']['etc']['tabs'] )
		);

		// gestione tools ricevute
		$p['ricevute.amministrazione.form.tools'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
			'title'			=> array( $l		=> 'azioni documenti' ),
			'h1'			=> array( $l		=> 'azioni documenti' ),
			'parent'		=> array( 'id'		=> 'ricevute.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_ricevute.amministrazione.form.tools.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['ricevute.amministrazione.form']['etc']['tabs'] )
		);

		// gestione stampe ricevute
		$p['ricevute.amministrazione.form.stampe'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-print" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'stampe' ),
			'h1'		=> array( $l		=> 'stampe' ),
			'parent'		=> array( 'id'		=> 'ricevute.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
			'macro'		=> array( $m.'_src/_inc/_macro/_ricevute.amministrazione.form.stampe.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> $p['ricevute.amministrazione.form']['etc']['tabs'] )
		);

		// gestione ricevute_righe
		$p['righe.ricevute.amministrazione.form'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'gestione righe' ),
			'h1'			=> array( $l		=> 'gestione' ),
			'parent'		=> array( 'id'		=> 'righe.ricevute.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'righe.ricevute.amministrazione.form.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_righe.ricevute.amministrazione.form.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> array(	'righe.ricevute.amministrazione.form', 'righe.ricevute.amministrazione.form.aggregate' ) )
		);

	// vista ricevute passive
	$p['ricevute.passive.amministrazione.view'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'ricevute passive' ),
		'h1'			=> array( $l		=> 'ricevute passive' ),
		'parent'		=> array( 'id'		=> 'amministrazione.documenti.passivi' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_ricevute.passive.amministrazione.view.php' ),
		'etc'			=> array( 'tabs'	=> array(   'ricevute.passive.amministrazione.view',
														'righe.ricevute.passive.amministrazione.view' ) ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'ricevute' ),
														'priority'	=> '060' ) ) )	
		);

		// vista righe ricevute.passive
	$p['righe.ricevute.passive.amministrazione.view'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'righe passive' ),
		'h1'			=> array( $l		=> 'righe passive' ),
		'parent'		=> array( 'id'		=> 'ricevute.passive.amministrazione.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_righe.ricevute.passive.amministrazione.view.php' ),
		'etc'			=> array( 'tabs'	=> $p['ricevute.passive.amministrazione.view']['etc']['tabs'] ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) )
	);

		// gestione ricevute passive
		$p['ricevute.passive.amministrazione.form'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'gestione' ),
			'h1'			=> array( $l		=> 'gestione' ),
			'parent'		=> array( 'id'		=> 'ricevute.passive.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'ricevute.passive.amministrazione.form.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_ricevute.passive.amministrazione.form.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> array(	'ricevute.passive.amministrazione.form',
															'ricevute.passive.amministrazione.form.righe',
															'ricevute.passive.amministrazione.form.pagamenti',
															'ricevute.passive.amministrazione.form.file',
															'ricevute.passive.amministrazione.form.stampe',
															'ricevute.passive.amministrazione.form.tools' ) )
		);

		// gestione righe ricevute passive
		$p['ricevute.passive.amministrazione.form.righe'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'righe_ricevuta' ),
			'h1'			=> array( $l		=> 'righe' ),
			'parent'		=> array( 'id'		=> 'ricevute.passive.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'ricevute.passive.amministrazione.form.righe.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_ricevute.passive.amministrazione.form.righe.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['ricevute.passive.amministrazione.form']['etc']['tabs'] )
		);

		// gestione pagamenti ricevute passive
		$p['ricevute.passive.amministrazione.form.pagamenti'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'pagamenti' ),
			'h1'			=> array( $l		=> 'pagamenti' ),
			'parent'		=> array( 'id'		=> 'ricevute.passive.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'documenti.form.pagamenti.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_documenti.form.pagamenti.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['ricevute.passive.amministrazione.form']['etc']['tabs'] )
		);

		// gestione righe ricevute passive
		$p['ricevute.passive.amministrazione.righe.form'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'gestione righe' ),
			'h1'			=> array( $l		=> 'gestione' ),
			'parent'		=> array( 'id'		=> 'righe.ricevute.passive.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'ricevute.passive.amministrazione.righe.form.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_ricevute.passive.amministrazione.righe.form.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> array(	'ricevute.passive.amministrazione.righe.form', 'ricevute.passive.amministrazione.righe.form.aggregate' ) )
		);

		// gestione 
		$p['ricevute.passive.amministrazione.righe.form.aggregate'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'righe aggregate' ),
			'h1'			=> array( $l		=> 'righe aggregate' ),
			'parent'		=> array( 'id'		=> 'righe.ricevute.passive.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'documenti.articoli.form.aggregate.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_documenti.articoli.form.aggregate.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['ricevute.passive.amministrazione.righe.form']['etc']['tabs'] )
		);

		// gestione chiusura ricevute passive
		$p['ricevute.passive.amministrazione.form.chiusura'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-check-square-o" aria-hidden="true"></i>',
			'title'			=> array( $l		=> 'chiusura' ),
			'h1'			=> array( $l		=> 'chiusura' ),
			'parent'		=> array( 'id'		=> 'ricevute.passive.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'ricevute.passive.amministrazione.form.chiusura.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_ricevute.passive.amministrazione.form.tools.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['ricevute.passive.amministrazione.form']['etc']['tabs'] )
		);

		// gestione tools ricevute
		$p['ricevute.passive.amministrazione.form.file'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-folder-open-o" aria-hidden="true"></i>',
			'title'			=> array( $l		=> 'file' ),
			'h1'			=> array( $l		=> 'file' ),
			'parent'		=> array( 'id'		=> 'ricevute.passive.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'ricevute.passive.amministrazione.form.file.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_ricevute.passive.amministrazione.form.file.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['ricevute.passive.amministrazione.form']['etc']['tabs'] )
		);

		// gestione tools ricevute passive
		$p['ricevute.passive.amministrazione.form.tools'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
			'title'			=> array( $l		=> 'azioni documenti' ),
			'h1'			=> array( $l		=> 'azioni documenti' ),
			'parent'		=> array( 'id'		=> 'ricevute.passive.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_ricevute.passive.amministrazione.form.tools.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['ricevute.passive.amministrazione.form']['etc']['tabs'] )
		);

		// gestione stampe ricevute passive
		$p['ricevute.passive.amministrazione.form.stampe'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-print" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'stampe' ),
			'h1'		=> array( $l		=> 'stampe' ),
			'parent'		=> array( 'id'		=> 'ricevute.passive.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
			'macro'		=> array( $m.'_src/_inc/_macro/_ricevute.passive.amministrazione.form.stampe.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> $p['ricevute.passive.amministrazione.form']['etc']['tabs'] )
		);

	}
