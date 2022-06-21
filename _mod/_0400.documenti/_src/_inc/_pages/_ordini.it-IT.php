<?php

    // modulo di questo file
	$m = DIR_MOD . '_0400.documenti/';

    // RELAZIONI CON IL MODULO LOGISTICA
	if( in_array( "5000.logistica", $cf['mods']['active']['array'] ) ) {

		// vista ddt
		$p['ordini.magazzini.view'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'ordini attivi' ),
			'h1'			=> array( $l		=> 'ordini attivi' ),
			'parent'		=> array( 'id'		=> 'logistica' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
			'macro'			=> array( $m . '_src/_inc/_macro/_ordini.magazzini.view.php' ),
			'etc'			=> array( 'tabs'	=> array(   'ordini.magazzini.view', 'ordini.passivi.magazzini.view' ) ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'ordini' ),
															'priority'	=> '200' ) ) )	
		);

		// gestione ddt
		$p['ordini.magazzini.form'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'gestione' ),
			'h1'			=> array( $l		=> 'gestione' ),
			'parent'		=> array( 'id'		=> 'ordini.magazzini.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'ordini.magazzini.form.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_ordini.magazzini.form.php' ),
			'js'			=> array( 'internal' => array( '_mod/_0400.documenti/_src/_templates/_athena/src/js/documenti.js' ) ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> array(	'ordini.magazzini.form',
															'ordini.magazzini.form.righe',
															'ordini.magazzini.form.invio',
															'ordini.magazzini.form.chiusura',
															'ordini.magazzini.form.stampe',
															'ordini.magazzini.form.tools' ) )
		);        

        // gestione righe ordini
		$p['ordini.magazzini.form.righe'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'righe ordini' ),
			'h1'			=> array( $l		=> 'righe' ),
			'parent'		=> array( 'id'		=> 'ordini.magazzini.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'ordini.magazzini.form.righe.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_ordini.magazzini.form.righe.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['ordini.magazzini.form']['etc']['tabs'] )
		);

		// gestione chiusura fatture
		$p['ordini.magazzini.form.invio'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-paper-plane-o" aria-hidden="true"></i>',
			'title'			=> array( $l		=> 'invio' ),
			'h1'			=> array( $l		=> 'invio' ),
			'parent'		=> array( 'id'		=> 'ordini.magazzini.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'ordini.magazzini.form.invio.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_ordini.magazzini.form.invio.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['ordini.magazzini.form']['etc']['tabs'] )
		);

		// gestione chiusura fatture
		$p['ordini.magazzini.form.chiusura'] = array(
			'sitemap'		=> false,
			'icon'		=> '<i class="fa fa-check-square-o" aria-hidden="true"></i>',
			'title'			=> array( $l		=> 'chiusura' ),
			'h1'			=> array( $l		=> 'chiusura' ),
			'parent'		=> array( 'id'		=> 'ordini.magazzini.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'ordini.magazzini.form.chiusura.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_ordini.magazzini.form.chiusura.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['ordini.magazzini.form']['etc']['tabs'] )
		);

		$p['ordini.magazzini.form.stampe'] = array(
            'sitemap'		=> false,
            'icon'		=> '<i class="fa fa-print" aria-hidden="true"></i>',
            'title'		=> array( $l		=> 'stampe' ),
            'h1'		=> array( $l		=> 'stampe' ),
            'parent'		=> array( 'id'		=> 'ordini.magazzini.view' ),
            'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
            'macro'		=> array( $m.'_src/_inc/_macro/_ordini.magazzini.form.stampe.php' ),
            'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
            'etc'		=> array( 'tabs'	=> $p['ordini.magazzini.form']['etc']['tabs'] )
        );
    

		// vista ordini passivi
		$p['ordini.passivi.magazzini.view'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'ordini passivi' ),
			'h1'			=> array( $l		=> 'ordini passivi' ),
			'parent'		=> array( 'id'		=> 'logistica' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
			'macro'			=> array( $m . '_src/_inc/_macro/_ordini.passivi.magazzini.view.php' ),
			'etc'			=> array( 'tabs'	=> $p['ordini.magazzini.view']['etc']['tabs'] ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) )
		);

			// gestione ddt
		$p['ordini.passivi.magazzini.form'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'gestione' ),
			'h1'			=> array( $l		=> 'gestione' ),
			'parent'		=> array( 'id'		=> 'ordini.passivi.magazzini.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'ordini.magazzini.form.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_ordini.magazzini.form.php' ),
			'js'			=> array( 'internal' => array( '_mod/_0400.documenti/_src/_templates/_athena/src/js/documenti.js' ) ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> array(	'ordini.passivi.magazzini.form',
															'ordini.passivi.magazzini.form.righe',
															'ordini.magazzini.form.stampe',
															'ordini.magazzini.form.tools' ) )
		);        

        // gestione righe ordini
		$p['ordini.passivi.magazzini.form.righe'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'righe ordini passivi' ),
			'h1'			=> array( $l		=> 'righe' ),
			'parent'		=> array( 'id'		=> 'ordini.passivi.magazzini.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'ordini.magazzini.form.righe.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_ordini.magazzini.form.righe.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['ordini.passivi.magazzini.form']['etc']['tabs'] )
		);



		$p['ordini.passivi.magazzini.form.stampe'] = array(
            'sitemap'		=> false,
            'icon'		=> '<i class="fa fa-print" aria-hidden="true"></i>',
            'title'		=> array( $l		=> 'stampe' ),
            'h1'		=> array( $l		=> 'stampe' ),
            'parent'		=> array( 'id'		=> 'ordini.passivi.magazzini.view' ),
            'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
            'macro'		=> array( $m.'_src/_inc/_macro/_ordini.magazzini.form.stampe.php' ),
            'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
            'etc'		=> array( 'tabs'	=> $p['ordini.magazzini.form']['etc']['tabs'] )
        );
 
		$p['ordini.magazzini.righe.form'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'gestione righe ordini' ),
			'h1'			=> array( $l		=> 'gestione' ),
			'parent'		=> array( 'id'		=> 'ordini.magazzini.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'ordini.magazzini.righe.form.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_ordini.magazzini.righe.form.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> array(	'ordini.magazzini.righe.form') )
		);    
    }
