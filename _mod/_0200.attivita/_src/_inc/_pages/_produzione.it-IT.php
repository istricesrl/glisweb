<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0200.attivita/';

    // tools produzione
	// TODO questa va nel modulo cartellini?
	$p['produzione.attivita'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-pencil-square-o" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'attività' ),
	    'h1'				=> array( $l		=> 'attività' ),
	    'parent'			=> array( 'id'		=> 'produzione' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_produzione.attivita.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> 'produzione' )
	);
