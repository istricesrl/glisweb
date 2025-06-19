<?php

	// lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0400.documenti/';

    // RELAZIONI CON IL MODULO LOGISTICA
	if( in_array( "5200.missioni", $cf['mods']['active']['array'] ) ) {

		// dashboard logistica doc. attivi
		$p['missioni.view'] = array(
			'sitemap'		=> false,
			'title'		=> array( $l		=> 'missioni' ),
			'h1'		=> array( $l		=> 'missioni' ),
			'template'	=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_missioni.view.php' ),
			'parent'	=> array( 'id'		=> 'logistica' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> array( 'missioni.view', 'missioni.tools' ) ),
			'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'missioni' ),
			    'priority'	=> '120' ) ) )	
		);

        // tools missioni
        $p['missioni.tools'] = array(
            'sitemap'			=> false,
            'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
            'title'				=> array( $l		=> 'azioni' ),
            'h1'				=> array( $l		=> 'azioni' ),
            'parent'			=> array( 'id'		=> 'missioni.view' ),
            'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
            'macro'				=> array( $m . '_src/_inc/_macro/_missioni.tools.php' ),
            'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
            'etc'				=> array( 'tabs'	=> $p['missioni.view']['etc']['tabs'] )
        );

		// gestione ddt
		$p['missioni.form'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'gestione' ),
			'h1'			=> array( $l		=> 'gestione' ),
			'parent'		=> array( 'id'		=> 'missioni.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'missioni.form.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_missioni.form.php' ),
			'js'			=> array( 'internal' => array( $m . '_src/_templates/_athena/src/js/missioni.js' ) ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> array(	'missioni.form',
															'missioni.form.contenuto',
															'missioni.form.evasione',
															'missioni.form.righe',
															'missioni.form.chiusura',
															'missioni.form.invio',
															'missioni.form.stampe',
															'missioni.form.tools' ) )
		);        

        // gestione tools missioni
        $p['missioni.form.contenuto'] = array(
            'sitemap'		=> false,
            'title'			=> array( $l		=> 'contenuto missione' ),
            'h1'			=> array( $l		=> 'contenuto' ),
            'parent'		=> array( 'id'		=> 'missioni.view' ),
            'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'missioni.form.contenuto.html' ),
            'macro'			=> array( $m.'_src/_inc/_macro/_missioni.form.contenuto.php' ),
            'auth'			=> array( 'groups'	=> array(	'roots' ) ),
            'etc'			=> array( 'tabs'	=> $p['missioni.form']['etc']['tabs'] )
        );

        // gestione tools missioni
        $p['missioni.form.righe'] = array(
            'sitemap'		=> false,
            'title'			=> array( $l		=> 'righe missione' ),
            'h1'			=> array( $l		=> 'righe' ),
            'parent'		=> array( 'id'		=> 'missioni.view' ),
            'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'missioni.form.righe.html' ),
            'macro'			=> array( $m.'_src/_inc/_macro/_missioni.form.righe.php' ),
            'auth'			=> array( 'groups'	=> array(	'roots' ) ),
            'etc'			=> array( 'tabs'	=> $p['missioni.form']['etc']['tabs'] )
        );

        // gestione tools missioni
        $p['missioni.form.evasione'] = array(
            'sitemap'		=> false,
            'title'			=> array( $l		=> 'evasione' ),
            'h1'			=> array( $l		=> 'evasione' ),
            'parent'		=> array( 'id'		=> 'missioni.view' ),
            'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'missioni.form.evasione.html' ),
            'macro'			=> array( $m.'_src/_inc/_macro/_missioni.form.evasione.php' ),
            'auth'			=> array( 'groups'	=> array(	'roots' ) ),
            'etc'			=> array( 'tabs'	=> $p['missioni.form']['etc']['tabs'] )
        );

        // tools missioni
        $p['missioni.form.tools'] = array(
            'sitemap'			=> false,
            'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
            'title'				=> array( $l		=> 'azioni missione' ),
            'h1'				=> array( $l		=> 'azioni missione' ),
            'parent'			=> array( 'id'		=> 'missioni.view' ),
            'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
            'macro'				=> array( $m . '_src/_inc/_macro/_missioni.form.tools.php' ),
            'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
            'etc'				=> array( 'tabs'	=> $p['missioni.form']['etc']['tabs'] )
        );

		$p['missioni.form.stampe'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-print" aria-hidden="true"></i>',
			'title'		=> array( $l		=> 'stampe' ),
			'h1'		=> array( $l		=> 'stampe' ),
			'parent'		=> array( 'id'		=> 'missioni.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
			'macro'		=> array( $m.'_src/_inc/_macro/_missioni.form.stampe.php' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> $p['missioni.form']['etc']['tabs'] )
		);

    }
