<?php

	// lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0400.documenti/';

    // RELAZIONI CON IL MODULO AMMINISTRAZIONE
	if( in_array( "6000.amministrazione", $cf['mods']['active']['array'] ) ) {

		// vista proforma
		$p['proforma.amministrazione.view'] = array(
				'sitemap'		=> false,
				'title'			=> array( $l		=> 'proforma' ),
				'h1'			=> array( $l		=> 'proforma' ),
				'parent'		=> array( 'id'		=> 'amministrazione.documenti.attivi' ),
				'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
				'macro'			=> array( $m . '_src/_inc/_macro/_proforma.amministrazione.view.php' ),
				'etc'			=> array( 'tabs'	=> array(   'proforma.amministrazione.view' , 'righe.proforma.amministrazione.view') ),
				'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
				'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'proforma' ),
																'priority'	=> '040' ) ) )	
		);

		// vista righe proforma
		$p['righe.proforma.amministrazione.view'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'righe note proforma attive' ),
			'h1'			=> array( $l		=> 'righe attive' ),
			'parent'		=> array( 'id'		=> 'proforma.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
			'macro'			=> array( $m . '_src/_inc/_macro/_righe.proforma.amministrazione.view.php' ),
			'etc'			=> array( 'tabs'	=> $p['proforma.amministrazione.view']['etc']['tabs'] ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) )
		);

		// gestione proforma
		$p['proforma.amministrazione.form'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'gestione' ),
			'h1'			=> array( $l		=> 'gestione' ),
			'parent'		=> array( 'id'		=> 'proforma.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'proforma.amministrazione.form.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_proforma.amministrazione.form.php' ),
			'js'			=> array( 'internal' => array( '_mod/_0400.documenti/_src/_templates/_athena/src/js/documenti.js' ) ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> array(	'proforma.amministrazione.form',
															'proforma.amministrazione.form.relazioni',
															'proforma.amministrazione.form.righe',
															'proforma.amministrazione.form.pagamenti',
															'proforma.amministrazione.form.chiusura',
															'proforma.amministrazione.form.stampe',
															'proforma.amministrazione.form.tools' ) )
		);

		// gestione relazioni proforma
		$p['proforma.amministrazione.form.relazioni'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'riferimenti fattura' ),
			'h1'			=> array( $l		=> 'riferimenti' ),
			'parent'		=> array( 'id'		=> 'proforma.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'proforma.amministrazione.form.relazioni.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_proforma.amministrazione.form.relazioni.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['proforma.amministrazione.form']['etc']['tabs'] )
		);

		// gestione righe proforma
		$p['proforma.amministrazione.form.righe'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'righe nota proforma attiva' ),
			'h1'			=> array( $l		=> 'righe' ),
			'parent'		=> array( 'id'		=> 'proforma.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'proforma.amministrazione.form.righe.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_proforma.amministrazione.form.righe.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['proforma.amministrazione.form']['etc']['tabs'] )
		);

		// gestione pagamenti proforma
		$p['proforma.amministrazione.form.pagamenti'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'pagamenti' ),
			'h1'			=> array( $l		=> 'pagamenti' ),
			'parent'		=> array( 'id'		=> 'proforma.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'documenti.form.pagamenti.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_documenti.form.pagamenti.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['proforma.amministrazione.form']['etc']['tabs'] )
		);

		// gestione proforma_righe
		$p['proforma.amministrazione.righe.form'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'gestione righe' ),
			'h1'			=> array( $l		=> 'gestione' ),
			'parent'		=> array( 'id'		=> 'righe.proforma.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'proforma.amministrazione.righe.form.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_proforma.amministrazione.righe.form.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> array(	'proforma.amministrazione.righe.form', 'proforma.amministrazione.righe.form.aggregate' ) )
		);

		// gestione 
		$p['proforma.amministrazione.righe.form.aggregate'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'righe aggregate' ),
			'h1'			=> array( $l		=> 'righe aggregate' ),
			'parent'		=> array( 'id'		=> 'righe.proforma.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'documenti.articoli.form.aggregate.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_documenti.articoli.form.aggregate.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['proforma.amministrazione.righe.form']['etc']['tabs'] )
		);

		// gestione tools proforma
		$p['proforma.amministrazione.form.chiusura'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-check-square-o" aria-hidden="true"></i>',
			'title'			=> array( $l		=> 'chiusura' ),
			'h1'			=> array( $l		=> 'chiusura' ),
			'parent'		=> array( 'id'		=> 'proforma.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'proforma.amministrazione.form.chiusura.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_proforma.amministrazione.form.tools.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['proforma.amministrazione.form']['etc']['tabs'] )
		);

		// gestione tools proforma
		$p['proforma.amministrazione.form.tools'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
			'title'			=> array( $l		=> 'azioni documenti' ),
			'h1'			=> array( $l		=> 'azioni documenti' ),
			'parent'		=> array( 'id'		=> 'proforma.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_proforma.amministrazione.form.tools.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['proforma.amministrazione.form']['etc']['tabs'] )
		);

		// gestione proforma stampe
		$p['proforma.amministrazione.form.stampe'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-print" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'stampe' ),
			'h1'		=> array( $l		=> 'stampe' ),
			'parent'		=> array( 'id'		=> 'proforma.amministrazione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
			'macro'		=> array( $m.'_src/_inc/_macro/_proforma.amministrazione.form.stampe.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> $p['proforma.amministrazione.form']['etc']['tabs'] )
		);

	}
