<?php

	// lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0400.documenti/';

    // RELAZIONI CON IL MODULO AMMINISTRAZIONE
	if( in_array( "6000.amministrazione", $cf['mods']['active']['array'] ) ) {

		// vista note di credito
		$p['note.credito.amministrazione.view'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'note di credito' ),
			'h1'			=> array( $l		=> 'note di credito' ),
			'parent'		=> array( 'id'		=> 'amministrazione.documenti.attivi' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
			'macro'			=> array( $m . '_src/_inc/_macro/_note.credito.amministrazione.view.php' ),
			'etc'			=> array( 'tabs'	=> array(   'note.credito.amministrazione.view'
#															'righe.note.credito.amministrazione.view',
#															'note.debito.amministrazione.view',
#															'righe.note.debito.amministrazione.view' 
														) ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'note di credito' ),
															'priority'	=> '060' ) ) )	
		);

		// vista righe note di credito
		$p['righe.note.credito.amministrazione.view'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'righe note di credito' ),
			'h1'			=> array( $l		=> 'righe note di credito' ),
			'parent'		=> array( 'id'		=> 'note.credito.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
			'macro'			=> array( $m . '_src/_inc/_macro/_righe.note.credito.amministrazione.view.php' ),
			'etc'			=> array( 'tabs'	=> $p['note.credito.amministrazione.view']['etc']['tabs'] ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) )
		);

		// gestione note di credito
		$p['note.credito.amministrazione.form'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'gestione' ),
			'h1'			=> array( $l		=> 'gestione' ),
			'parent'		=> array( 'id'		=> 'note.credito.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'note.credito.amministrazione.form.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_note.credito.amministrazione.form.php' ),
			'js'			=> array( 'internal' => array( '_mod/_0400.documenti/_src/_templates/_athena/src/js/documenti.js' ) ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> array(	'note.credito.amministrazione.form',
															'note.credito.amministrazione.form.relazioni',
															'note.credito.amministrazione.form.righe',
															'note.credito.amministrazione.form.pagamenti',
															'note.credito.amministrazione.form.chiusura',
															'note.credito.amministrazione.form.stampe',
															'note.credito.amministrazione.form.tools' ) )
		);

		// RELAZIONI CON IL MODULO ATTIVITA
		if( in_array( "0200.attivita", $cf['mods']['active']['array'] ) ) {
			arrayInsertSeq( 'note.credito.amministrazione.form', $p['note.credito.amministrazione.form']['etc']['tabs'], 'note.credito.amministrazione.form.attivita' );
		}

		// gestione relazioni note di credito
		$p['note.credito.amministrazione.form.relazioni'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'riferimenti nota di credito' ),
			'h1'			=> array( $l		=> 'riferimenti' ),
			'parent'		=> array( 'id'		=> 'note.credito.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'note.credito.amministrazione.form.relazioni.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_note.credito.amministrazione.form.relazioni.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['note.credito.amministrazione.form']['etc']['tabs'] )
		);

		// gestione righe note di credito
		$p['note.credito.amministrazione.form.righe'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'righe nota di credito' ),
			'h1'			=> array( $l		=> 'righe' ),
			'parent'		=> array( 'id'		=> 'note.credito.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'note.credito.amministrazione.form.righe.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_note.credito.amministrazione.form.righe.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['note.credito.amministrazione.form']['etc']['tabs'] )
		);

		// gestione pagamenti note di credito
		$p['note.credito.amministrazione.form.pagamenti'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'pagamenti' ),
			'h1'			=> array( $l		=> 'pagamenti' ),
			'parent'		=> array( 'id'		=> 'note.credito.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'documenti.form.pagamenti.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_documenti.form.pagamenti.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['note.credito.amministrazione.form']['etc']['tabs'] )
		);

		// gestione note di credito_righe
		$p['note.credito.amministrazione.righe.form'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'gestione righe' ),
			'h1'			=> array( $l		=> 'gestione' ),
			'parent'		=> array( 'id'		=> 'righe.note.credito.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'note.credito.amministrazione.righe.form.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_note.credito.amministrazione.righe.form.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> array(	'note.credito.amministrazione.righe.form', 'note.credito.amministrazione.righe.form.aggregate' ) )
		);

		// gestione tools documenti_articoli - attivita
		$p['note.credito.amministrazione.righe.form.aggregate'] = array(
				'sitemap'		=> false,
				'title'			=> array( $l		=> 'righe aggregate' ),
				'h1'			=> array( $l		=> 'righe aggregate' ),
				'parent'		=> array( 'id'		=> 'righe.note.credito.amministrazione.view' ),
				'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'documenti.articoli.form.aggregate.html' ),
				'macro'			=> array( $m.'_src/_inc/_macro/_documenti.articoli.form.aggregate.php' ),
				'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
				'etc'			=> array( 'tabs'	=> $p['note.credito.amministrazione.righe.form']['etc']['tabs'] )
		);

		// gestione tools note di credito
		$p['note.credito.amministrazione.form.chiusura'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-check-square-o" aria-hidden="true"></i>',
			'title'			=> array( $l		=> 'chiusura nota di credito' ),
			'h1'			=> array( $l		=> 'chiusura' ),
			'parent'		=> array( 'id'		=> 'note.credito.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'note.credito.amministrazione.form.chiusura.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_note.credito.amministrazione.form.chiusura.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['note.credito.amministrazione.form']['etc']['tabs'] )
		);

		// gestione tools note di credito
		$p['note.credito.amministrazione.form.tools'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
			'title'			=> array( $l		=> 'azioni documenti' ),
			'h1'			=> array( $l		=> 'azioni documenti' ),
			'parent'		=> array( 'id'		=> 'note.credito.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_note.credito.amministrazione.form.tools.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['note.credito.amministrazione.form']['etc']['tabs'] )
		);

		// gestione stampe note di credito
		$p['note.credito.amministrazione.form.stampe'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-print" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'stampe' ),
			'h1'		=> array( $l		=> 'stampe' ),
			'parent'		=> array( 'id'		=> 'note.credito.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
			'macro'		=> array( $m.'_src/_inc/_macro/_note.credito.amministrazione.form.stampe.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> $p['note.credito.amministrazione.form']['etc']['tabs'] )
		);

	// vista note di debito
	$p['note.debito.amministrazione.view'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'note di debito' ),
		'h1'			=> array( $l		=> 'note di debito' ),
		'parent'		=> array( 'id'		=> 'amministrazione' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_note.debito.amministrazione.view.php' ),
		'etc'			=> array( 'tabs'	=> $p['note.credito.amministrazione.view']['etc']['tabs'] ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) )
	#	'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'note di debito' ),
	#													'priority'	=> '060' ) ) )	
		);

		// vista righe note.debito
	$p['righe.note.debito.amministrazione.view'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'righe note di debito' ),
		'h1'			=> array( $l		=> 'righe note di debito' ),
		'parent'		=> array( 'id'		=> 'note.debito.amministrazione.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_righe.note.debito.amministrazione.view.php' ),
		'etc'			=> array( 'tabs'	=> $p['note.credito.amministrazione.view']['etc']['tabs'] ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) )
	);

		// gestione note di debito
		$p['note.debito.amministrazione.form'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'gestione' ),
			'h1'			=> array( $l		=> 'gestione' ),
			'parent'		=> array( 'id'		=> 'note.debito.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'note.debito.amministrazione.form.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_note.debito.amministrazione.form.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> array(	'note.debito.amministrazione.form',
															'note.debito.amministrazione.form.righe',
															'note.debito.amministrazione.form.pagamenti',
															'note.debito.amministrazione.form.stampe',
															'note.debito.amministrazione.form.tools' ) )
		);

		// gestione righe note di debito
		$p['note.debito.amministrazione.form.righe'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'righe nota di debito' ),
			'h1'			=> array( $l		=> 'righe' ),
			'parent'		=> array( 'id'		=> 'note.debito.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'note.debito.amministrazione.form.righe.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_note.debito.amministrazione.form.righe.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['note.debito.amministrazione.form']['etc']['tabs'] )
		);

		// gestione pagamenti note di debito
		$p['note.debito.amministrazione.form.pagamenti'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'pagamenti' ),
			'h1'			=> array( $l		=> 'pagamenti' ),
			'parent'		=> array( 'id'		=> 'note.debito.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'documenti.form.pagamenti.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_documenti.form.pagamenti.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['note.debito.amministrazione.form']['etc']['tabs'] )
		);

		// gestione righe note di debito
		$p['note.debito.amministrazione.righe.form'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'gestione righe' ),
			'h1'			=> array( $l		=> 'gestione' ),
			'parent'		=> array( 'id'		=> 'righe.note.debito.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'note.debito.amministrazione.righe.form.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_note.debito.amministrazione.righe.form.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> array(	'note.debito.amministrazione.righe.form', 'note.debito.amministrazione.righe.form.aggregate' ) )
		);

		// gestione 
		$p['note.debito.amministrazione.righe.form.aggregate'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'righe aggregate' ),
			'h1'			=> array( $l		=> 'righe aggregate' ),
			'parent'		=> array( 'id'		=> 'righe.note.debito.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'documenti.articoli.form.aggregate.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_documenti.articoli.form.aggregate.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['note.debito.amministrazione.righe.form']['etc']['tabs'] )
		);

		// gestione chiusura note di debito
		$p['note.debito.amministrazione.form.chiusura'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-check-square-o" aria-hidden="true"></i>',
			'title'			=> array( $l		=> 'chiusura' ),
			'h1'			=> array( $l		=> 'chiusura' ),
			'parent'		=> array( 'id'		=> 'note.debito.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'note.debito.amministrazione.form.chiusura.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_note.debito.amministrazione.form.chiusura.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['note.debito.amministrazione.form']['etc']['tabs'] )
		);

		// gestione tools note di debito
		$p['note.debito.amministrazione.form.tools'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
			'title'			=> array( $l		=> 'azioni documenti' ),
			'h1'			=> array( $l		=> 'azioni documenti' ),
			'parent'		=> array( 'id'		=> 'note.debito.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_note.debito.amministrazione.form.tools.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['note.debito.amministrazione.form']['etc']['tabs'] )
		);

		// gestione stampe note di debito
		$p['note.debito.amministrazione.form.stampe'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-print" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'stampe' ),
			'h1'		=> array( $l		=> 'stampe' ),
			'parent'		=> array( 'id'		=> 'note.debito.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
			'macro'		=> array( $m.'_src/_inc/_macro/_note.debito.amministrazione.form.stampe.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> $p['note.debito.amministrazione.form']['etc']['tabs'] )
		);

		// vista note di credito
		$p['note.credito.passive.amministrazione.view'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'note di credito' ),
			'h1'			=> array( $l		=> 'note di credito' ),
			'parent'		=> array( 'id'		=> 'amministrazione.documenti.passivi' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
			'macro'			=> array( $m . '_src/_inc/_macro/_note.credito.passive.amministrazione.view.php' ),
			'etc'			=> array( 'tabs'	=> array(   'note.credito.passive.amministrazione.view'
#															'righe.note.credito.passive.amministrazione.view',
#															'note.debito.amministrazione.view',
#															'righe.note.debito.amministrazione.view' 
														) ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'note di credito' ),
															'priority'	=> '090' ) ) )	
		);

		// vista righe note di credito
		$p['righe.note.credito.passive.amministrazione.view'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'righe note di credito' ),
			'h1'			=> array( $l		=> 'righe note di credito' ),
			'parent'		=> array( 'id'		=> 'note.credito.passive.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
			'macro'			=> array( $m . '_src/_inc/_macro/_righe.note.credito.passive.amministrazione.view.php' ),
			'etc'			=> array( 'tabs'	=> $p['note.credito.passive.amministrazione.view']['etc']['tabs'] ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) )
		);

		// gestione note di credito
		$p['note.credito.passive.amministrazione.form'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'gestione' ),
			'h1'			=> array( $l		=> 'gestione' ),
			'parent'		=> array( 'id'		=> 'note.credito.passive.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'note.credito.passive.amministrazione.form.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_note.credito.passive.amministrazione.form.php' ),
			'js'			=> array( 'internal' => array( '_mod/_0400.documenti/_src/_templates/_athena/src/js/documenti.js' ) ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> array(	'note.credito.passive.amministrazione.form',
# TODO creare queste pagine e decommentare
#															'note.credito.passive.amministrazione.form.relazioni',
#															'note.credito.passive.amministrazione.form.righe',
#															'note.credito.passive.amministrazione.form.pagamenti',
#															'note.credito.passive.amministrazione.form.chiusura',
#															'note.credito.passive.amministrazione.form.stampe',
															'note.credito.passive.amministrazione.form.tools' ) )
		);
/*
		TODO creare questa pagina e decommentare

		// RELAZIONI CON IL MODULO ATTIVITA
		if( in_array( "0200.attivita", $cf['mods']['active']['array'] ) ) {
			arrayInsertSeq( 'note.credito.passive.amministrazione.form', $p['note.credito.passive.amministrazione.form']['etc']['tabs'], 'note.credito.passive.amministrazione.form.attivita' );
		}
*/
		// gestione relazioni note di credito
		$p['note.credito.passive.amministrazione.form.relazioni'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'riferimenti nota di credito' ),
			'h1'			=> array( $l		=> 'riferimenti' ),
			'parent'		=> array( 'id'		=> 'note.credito.passive.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'note.credito.passive.amministrazione.form.relazioni.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_note.credito.passive.amministrazione.form.relazioni.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['note.credito.passive.amministrazione.form']['etc']['tabs'] )
		);

		// gestione righe note di credito
		$p['note.credito.passive.amministrazione.form.righe'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'righe nota di credito' ),
			'h1'			=> array( $l		=> 'righe' ),
			'parent'		=> array( 'id'		=> 'note.credito.passive.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'note.credito.passive.amministrazione.form.righe.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_note.credito.passive.amministrazione.form.righe.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['note.credito.passive.amministrazione.form']['etc']['tabs'] )
		);

		// gestione pagamenti note di credito
		$p['note.credito.passive.amministrazione.form.pagamenti'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'pagamenti' ),
			'h1'			=> array( $l		=> 'pagamenti' ),
			'parent'		=> array( 'id'		=> 'note.credito.passive.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'documenti.form.pagamenti.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_documenti.form.pagamenti.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['note.credito.passive.amministrazione.form']['etc']['tabs'] )
		);

		// gestione note di credito_righe
		$p['note.credito.passive.amministrazione.righe.form'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'gestione righe' ),
			'h1'			=> array( $l		=> 'gestione' ),
			'parent'		=> array( 'id'		=> 'righe.note.credito.passive.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'note.credito.passive.amministrazione.righe.form.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_note.credito.passive.amministrazione.righe.form.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> array(	'note.credito.passive.amministrazione.righe.form', 'note.credito.passive.amministrazione.righe.form.aggregate' ) )
		);

		// gestione tools documenti_articoli - attivita
		$p['note.credito.passive.amministrazione.righe.form.aggregate'] = array(
				'sitemap'		=> false,
				'title'			=> array( $l		=> 'righe aggregate' ),
				'h1'			=> array( $l		=> 'righe aggregate' ),
				'parent'		=> array( 'id'		=> 'righe.note.credito.passive.amministrazione.view' ),
				'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'documenti.articoli.form.aggregate.html' ),
				'macro'			=> array( $m.'_src/_inc/_macro/_documenti.articoli.form.aggregate.php' ),
				'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
				'etc'			=> array( 'tabs'	=> $p['note.credito.passive.amministrazione.righe.form']['etc']['tabs'] )
		);

		// gestione tools note di credito
		$p['note.credito.passive.amministrazione.form.chiusura'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-check-square-o" aria-hidden="true"></i>',
			'title'			=> array( $l		=> 'chiusura nota di credito' ),
			'h1'			=> array( $l		=> 'chiusura' ),
			'parent'		=> array( 'id'		=> 'note.credito.passive.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'note.credito.passive.amministrazione.form.chiusura.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_note.credito.passive.amministrazione.form.chiusura.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['note.credito.passive.amministrazione.form']['etc']['tabs'] )
		);

		// gestione tools note di credito
		$p['note.credito.passive.amministrazione.form.tools'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
			'title'			=> array( $l		=> 'azioni documenti' ),
			'h1'			=> array( $l		=> 'azioni documenti' ),
			'parent'		=> array( 'id'		=> 'note.credito.passive.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_note.credito.passive.amministrazione.form.tools.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['note.credito.passive.amministrazione.form']['etc']['tabs'] )
		);

		// gestione stampe note di credito
		$p['note.credito.passive.amministrazione.form.stampe'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-print" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'stampe' ),
			'h1'		=> array( $l		=> 'stampe' ),
			'parent'		=> array( 'id'		=> 'note.credito.passive.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
			'macro'		=> array( $m.'_src/_inc/_macro/_note.credito.passive.amministrazione.form.stampe.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> $p['note.credito.passive.amministrazione.form']['etc']['tabs'] )
		);

	}
