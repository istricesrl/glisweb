<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0900.progetti/';

	// subview progetti dell'anagrafica 
    $p['anagrafica.form.progetti'] = array(
    	'sitemap'		=> false,
        'icon'			=> '<i class="fa fa-briefcase" aria-hidden="true"></i>',
        'title'			=> array( $l		=> 'progetti' ),
        'h1'			=> array( $l		=> 'progetti' ),
        'parent'		=> array( 'id'		=> 'anagrafica.view' ),
        'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'anagrafica.form.progetti.html' ),
        'macro'			=> array( $m . '_src/_inc/_macro/_anagrafica.form.progetti.php' ),
        'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
        'etc'			=> array( 'tabs'	=> 'anagrafica.form' )
    );
