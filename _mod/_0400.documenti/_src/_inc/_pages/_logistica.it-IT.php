<?php

	// lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0400.documenti/';

    // RELAZIONI CON IL MODULO LOGISTICA
	if( in_array( "5000.logistica", $cf['mods']['active']['array'] ) ) {

		// dashboard logistica doc. attivi
		$p['logistica.documenti.attivi'] = array(
			'sitemap'		=> false,
			'title'		=> array( $l		=> 'ciclo attivo' ),
			'h1'		=> array( $l		=> 'ciclo attivo' ),
			'template'	=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'logistica.documenti.attivi.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_logistica.documenti.attivi.php' ),
			'parent'	=> array( 'id'		=> 'logistica' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> array( 'logistica.documenti.attivi', 'logistica.documenti.attivi.tools' ) ),
			'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'ciclo attivo' ),
			'priority'	=> '020' ) ) )	
		);

        // tools documenti
        $p['logistica.documenti.attivi.tools'] = array(
            'sitemap'			=> false,
            'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
            'title'				=> array( $l		=> 'azioni' ),
            'h1'				=> array( $l		=> 'azioni' ),
            'parent'			=> array( 'id'		=> 'logistica.documenti.attivi' ),
            'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
            'macro'				=> array( $m . '_src/_inc/_macro/_logistica.documenti.attivi.tools.php' ),
            'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
            'etc'				=> array( 'tabs'	=> $p['logistica.documenti.attivi']['etc']['tabs'] )
        );

		// dashboard logistica doc. passivi
		$p['logistica.documenti.passivi'] = array(
			'sitemap'		=> false,
			'title'		=> array( $l		=> 'ciclo passivo' ),
			'h1'		=> array( $l		=> 'ciclo passivo' ),
			'template'	=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'logistica.documenti.passivi.html' ),
			'macro'		=> array( $m . '_src/_inc/_macro/_logistica.documenti.passivi.php' ),
			'parent'	=> array( 'id'		=> 'logistica' ),
			'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'		=> array( 'tabs'	=> array( 'logistica.documenti.passivi', 'logistica.documenti.passivi.tools' ) ),
			'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'ciclo passivo' ),
			'priority'	=> '030' ) ) )	
		);

        // tools documenti
        $p['logistica.documenti.passivi.tools'] = array(
            'sitemap'			=> false,
            'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
            'title'				=> array( $l		=> 'azioni' ),
            'h1'				=> array( $l		=> 'azioni' ),
            'parent'			=> array( 'id'		=> 'logistica.documenti.passivi' ),
            'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
            'macro'				=> array( $m . '_src/_inc/_macro/_logistica.documenti.passivi.tools.php' ),
            'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
            'etc'				=> array( 'tabs'	=> $p['logistica.documenti.passivi']['etc']['tabs'] )
        );

    }
