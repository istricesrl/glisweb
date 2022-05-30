<?php

    // lingua di questo file
	$l = 'it-IT';
	$m = '_mod/_4170.ecommerce/';

    // carrello
	$p['carrello'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'carrello' ),
	    'h1'			=> array( $l		=> 'carrello' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'template'		=> array( 'path'	=> '_src/_templates/_lydia/', 'schema' => 'carrello.html' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_carrello.php' ),
	    'metadati'		=> array( 'ruolo'	=> 'carrello' )
	);

    // riepilogo
	$p['carrello_riepilogo'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'riepilogo' ),
	    'h1'			=> array( $l		=> 'riepilogo' ),
	    'parent'		=> array( 'id'		=> 'carrello' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_lydia/', 'schema' => 'carrello.riepilogo.html' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_carrello.riepilogo.php' )
	);

    // checkout
	$p['carrello_checkout'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'checkout ordine' ),
	    'h1'			=> array( $l		=> 'nessun ordine in corso' ),
	    'h2'			=> array( $l		=> NULL ),
	    'parent'		=> array( 'id'		=> 'carrello' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_lydia/', 'schema' => 'carrello.checkout.html' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_carrello.checkout.php' )
	);

    // checkout
	$p['carrello_esito'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'esito ordine' ),
	    'h1'			=> array( $l		=> 'nessun ordine in corso' ),
	    'h2'			=> array( $l		=> NULL ),
	    'parent'		=> array( 'id'		=> 'carrello' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_lydia/', 'schema' => 'carrello.esito.html' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_carrello.esito.php' )
	);

    // checkout
	$p['carrello_successo'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'esito ordine' ),
	    'h1'			=> array( $l		=> 'nessun ordine in corso' ),
	    'h2'			=> array( $l		=> NULL ),
	    'parent'		=> array( 'id'		=> 'carrello' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_lydia/', 'schema' => 'carrello.successo.html' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_carrello.successo.php' )
	);

    // checkout
	$p['carrello_fallimento'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'esito ordine' ),
	    'h1'			=> array( $l		=> 'nessun ordine in corso' ),
	    'h2'			=> array( $l		=> NULL ),
	    'parent'		=> array( 'id'		=> 'carrello' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_lydia/', 'schema' => 'carrello.fallimento.html' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_carrello.fallimento.php' )
	);

	// vista carrelli
	$p['carrelli.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'ecommerce' ),
	    'h1'			=> array( $l		=> 'ecommerce' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_carrelli.view.php' ),
		'auth'			=> array( 'groups'	=> array( 'roots' ) ),
		'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'ecommerce' ),
																		'priority'	=> '700' ) ) )	
	);
	
	// gestione carrelli
	$p['carrelli.form'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'gestione' ),
	    'h1'			=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'carrelli.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'carrelli.form.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_carrelli.form.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots' ) ),
		'etc'			=> array( 'tabs'	=> array(	'carrelli.form' ) )
	);
	