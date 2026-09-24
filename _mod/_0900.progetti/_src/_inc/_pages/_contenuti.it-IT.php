<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0900.progetti/';

	// subview progetti dell'anagrafica 
    $p['pagine.form.progetti'] = array(
    	'sitemap'		=> false,
        'icon'			=> '<i class="fa fa-briefcase" aria-hidden="true"></i>',
        'title'			=> array( $l		=> 'progetti pagina' ),
        'h1'			=> array( $l		=> 'progetti' ),
        'parent'		=> array( 'id'		=> 'pagine.view' ),
        'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'pagine.form.progetti.html' ),
        'macro'			=> array( $m . '_src/_inc/_macro/_pagine.form.progetti.php' ),
        'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
        'etc'			=> array( 'tabs'	=> 'pagine.form' )
    );
