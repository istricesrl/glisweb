<?php

	// lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0400.documenti/';

    // debug
    // die( print_r( $p, true ) );

    // RELAZIONI CON IL MODULO LOGISTICA
	if( in_array( "5200.missioni", $cf['mods']['active']['array'] ) ) {

		// dashboard logistica doc. attivi
		$p['missioni.view'] = array(
			'sitemap'		=> false,
			'title'		    => array( $l		=> 'missioni' ),
			'h1'		=> array( $l		=> 'missioni' ),
			'template'	=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_missioni.view.php' ),
			'parent'	=> array( 'id'		=> 'logistica' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> array( 'missioni.view', 'missioni.tools' ) ),
			'menu'		=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'missioni' ), 'priority'	=> '120' ) ) )	
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
															'missioni.form.righe',
															'missioni.form.chiusura',
															'missioni.form.invio',
															'missioni.form.stampe',
															'missioni.form.tools' ) )
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

    }

    // debug
    // die( print_r( $p, true ) );
