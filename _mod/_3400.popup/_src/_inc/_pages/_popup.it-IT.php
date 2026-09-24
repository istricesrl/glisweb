<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_3400.popup/';

	// vista popup
	$p['popup.view'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'popup' ),
	    'h1'		=> array( $l		=> 'popup' ),
	    'parent'		=> array( 'id'		=> 'contenuti' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_popup.view.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'popup.view',
									'popup.tools' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'popup' ),
									'priority'	=> '080' ) ) )				
	    );

    // gestione popup
	$p['popup.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'popup.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'popup.form.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_popup.form.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> array(	'popup.form',
													'popup.form.pagine',
													'popup.form.testo',
													'popup.form.tools') )
	);

	// gestione pagine popup
	$p['popup.form.pagine'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'pagine' ),
	    'h1'		=> array( $l		=> 'pagine' ),
	    'parent'		=> array( 'id'		=> 'popup.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'popup.form.pagine.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_popup.form.pagine.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> $p['popup.form']['etc']['tabs'] )
	);

	// gestione testo popup
	$p['popup.form.testo'] = array(
	    'sitemap'		=> false,
		'icon'			=> '<i class="fa fa-file-text-o" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'testo' ),
	    'h1'		=> array( $l		=> 'testo' ),
	    'parent'		=> array( 'id'		=> 'popup.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'popup.form.testo.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_popup.form.testo.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> $p['popup.form']['etc']['tabs'] )
	);
