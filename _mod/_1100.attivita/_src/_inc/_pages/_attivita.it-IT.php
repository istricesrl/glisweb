<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_1100.attivita/';

	// vista attivita
	$p['attivita.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'attivita' ),
	    'h1'			=> array( $l		=> 'attività' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_attivita.view.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'menu'			=> array( 'admin'	=> array(	'label'		=> array( $l => 'attività' ),
														'priority'	=> '100' ) )
	);

	// gestione attivita
	$p['attivita.form'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'gestione' ),
	    'h1'			=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'attivita.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'attivita.form.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_attivita.form.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'			=> array( 'tabs'	=> array(	'attivita.form' ) )
	);

