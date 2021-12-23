<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_1120.cartellini/';

    // tools attività
	$p['attivita.tools']['macro'][]		= $m . '_src/_inc/_macro/_attivita.tools.php';

	// dashboard cartellini
	$p['cartellini'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'cartellini' ),
	    'h1'		=> array( $l		=> 'cartellini' ),
	    'parent'		=> array( 'id'		=> 'produzione' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'cartellini.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_cartellini.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['attivita.view']['etc']['tabs'] )
    );

	// gestione cartellini
	$p['cartellini.form'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'gestione' ),
	    'h1'			=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'cartellini' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'cartellini.form.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_cartellini.form.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'cartellini.form', 'cartellini.form.righe','cartellini.form.approvazione' ) )
	);

	// gestione cartellini - righe
	$p['cartellini.form.righe'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'righe' ),
	    'h1'			=> array( $l		=> 'righe' ),
	    'parent'		=> array( 'id'		=> 'cartellini' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'cartellini.form.righe.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_cartellini.form.righe.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> $p['cartellini.form']['etc']['tabs'] )
	);

	// gestione cartellini - approvazione
	$p['cartellini.form.approvazione'] = array(
	    'sitemap'		=> false,
		'icon'			=> '<i class="fa-check-square-o" aria-hidden="true"></i>',
	    'title'			=> array( $l		=> 'approvazione' ),
	    'h1'			=> array( $l		=> 'approvazione' ),
	    'parent'		=> array( 'id'		=> 'cartellini' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'cartellini.form.approvazione.html' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_cartellini.form.approvazione.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> $p['cartellini.form']['etc']['tabs'] )
	);

	// gestione cartellini
	$p['righe.cartellini.form'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'gestione_righe' ),
	    'h1'			=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'cartellini' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'righe.cartellini.form.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_righe.cartellini.form.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'righe.cartellini.form') )
	);
	
