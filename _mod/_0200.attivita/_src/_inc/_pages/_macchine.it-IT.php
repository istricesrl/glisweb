<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0200.attivita/';

	// subview attività dell'anagrafica 
    $p['macchine.form.attivita'] = array(
    	'sitemap'		=> false,
        'icon'			=> '<i class="fa fa-pencil-square-o" aria-hidden="true"></i>',
        'title'			=> array( $l		=> 'attività' ),
        'h1'			=> array( $l		=> 'attività' ),
        'parent'		=> array( 'id'		=> 'macchine.view' ),
        'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'macchine.form.attivita.html' ),
        'macro'			=> array( $m . '_src/_inc/_macro/_macchine.form.attivita.php' ),
        'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
        'etc'			=> array( 'tabs'	=> 'macchine.form' )
    );
