<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0400.documenti/';

	// subview documenti dell'anagrafica 
    $p['anagrafica.form.documenti'] = array(
    	'sitemap'		=> false,
        'icon'			=> '<i class="fa fa-files-o" aria-hidden="true"></i>',
        'title'			=> array( $l		=> 'documenti' ),
        'h1'			=> array( $l		=> 'documenti' ),
        'parent'		=> array( 'id'		=> 'anagrafica.view' ),
        'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'anagrafica.form.documenti.html' ),
        'macro'			=> array( $m . '_src/_inc/_macro/_anagrafica.form.documenti.php' ),
        'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
        'etc'			=> array( 'tabs'	=> 'anagrafica.form' )
    );
