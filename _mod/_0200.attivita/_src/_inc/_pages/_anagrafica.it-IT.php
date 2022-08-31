<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0200.attivita/';

	// subview attività dell'anagrafica 
    $p['anagrafica.form.attivita'] = array(
    	'sitemap'		=> false,
        'icon'			=> '<i class="fa fa-pencil-square-o" aria-hidden="true"></i>',
        'title'			=> array( $l		=> 'attività' ),
        'h1'			=> array( $l		=> 'attività' ),
        'parent'		=> array( 'id'		=> 'anagrafica.view' ),
        'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'anagrafica.form.attivita.html' ),
        'macro'			=> array( $m . '_src/_inc/_macro/_anagrafica.form.attivita.php' ),
        'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
        'etc'			=> array( 'tabs'	=> 'anagrafica.form' )
    );
