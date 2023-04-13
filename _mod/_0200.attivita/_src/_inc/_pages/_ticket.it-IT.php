<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0200.attivita/';

	// gestione ticket vista attività
	$p['ticket.form.attivita'] = array(
	    'sitemap'		=> false,
		'icon'			=> '<i class="fa fa-pencil-square-o" aria-hidden="true"></i>',
	    'title'			=> array( $l		=> 'attivita' ),
	    'h1'			=> array( $l		=> 'attivita' ),
	    'parent'		=> array( 'id'		=> 'ticket.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'ticket.form.attivita.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_ticket.form.attivita.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> 'ticket.form' )
	);

