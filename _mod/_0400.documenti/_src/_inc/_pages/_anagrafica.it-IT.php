<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0400.documenti/';

	// subview attività dell'anagrafica 
    $p['anagrafica.form.documenti'] = array(
    	'sitemap'		=> false,
        'icon'			=> '<i class="fa fa-files-o" aria-hidden="true"></i>',
        'title'			=> array( $l		=> 'documenti anagrafica' ),
        'h1'			=> array( $l		=> 'documenti anagrafica' ),
        'parent'		=> array( 'id'		=> 'anagrafica.view' ),
        'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'anagrafica.form.documenti.html' ),
        'macro'			=> array( $m . '_src/_inc/_macro/_anagrafica.form.documenti.php' ),
        'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
        'etc'			=> array( 'tabs'	=> 'anagrafica.form' )
    );

	// subview attività dell'anagrafica 
    $p['anagrafica.form.documenti.righe'] = array(
    	'sitemap'		=> false,
        'icon'			=> '<i class="fa fa-list" aria-hidden="true"></i>',
        'title'			=> array( $l		=> 'righe documenti anagrafica' ),
        'h1'			=> array( $l		=> 'righe documenti anagrafica' ),
        'parent'		=> array( 'id'		=> 'anagrafica.view' ),
        'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'anagrafica.form.documenti.righe.html' ),
        'macro'			=> array( $m . '_src/_inc/_macro/_anagrafica.form.documenti.righe.php' ),
        'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
        'etc'			=> array( 'tabs'	=> 'anagrafica.form' )
    );
