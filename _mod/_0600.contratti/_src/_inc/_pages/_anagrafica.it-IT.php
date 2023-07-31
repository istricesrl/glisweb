<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0600.contratti/';

	// subview contratti dell'anagrafica 
    $p['anagrafica.form.contratti'] = array(
    	'sitemap'		=> false,
        'icon'			=> '<i class="fa fa-handshake-o" aria-hidden="true"></i>',
        'title'			=> array( $l		=> 'contratti' ),
        'h1'			=> array( $l		=> 'contratti' ),
        'parent'		=> array( 'id'		=> 'anagrafica.view' ),
        'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'anagrafica.form.contratti.html' ),
        'macro'			=> array( $m . '_src/_inc/_macro/_anagrafica.form.contratti.php' ),
        'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
        'etc'			=> array( 'tabs'	=> 'anagrafica.form' )
    );
