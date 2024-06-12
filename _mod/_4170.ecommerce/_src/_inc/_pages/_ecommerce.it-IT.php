<?php

    // lingua di questo file
	$l = 'it-IT';
	$m = '_mod/_4170.ecommerce/';

	// pagina principale
	$p['ecommerce'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'ecommerce' ),
		'h1'		=> array( $l		=> 'ecommerce' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'ecommerce.html' ),
		'parent'		=> array( 'id'		=> NULL ),
		'macro'		=> array( $m . '_src/_inc/_macro/_ecommerce.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> array(	'ecommerce' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'ecommerce' ), 'priority'	=> '660' ) ) )
	);

	// carrello
	$p['ecommerce.carrello'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'cassa' ),
		'h1'			=> array( $l		=> 'cassa' ),
		'parent'		=> array( 'id'		=> 'ecommerce' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'ecommerce.carrello.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_ecommerce.carrello.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> array(	'ecommerce.carrello', 'ecommerce.ricerca', 'ecommerce.pagamento' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'cassa' ), 'priority'	=> '660' ) ) )
	);

	// carrello
	$p['ecommerce.ricerca'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'ricerca' ),
		'h1'			=> array( $l		=> 'ricerca' ),
		'parent'		=> array( 'id'		=> 'ecommerce' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'ecommerce.ricerca.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_ecommerce.ricerca.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> 'ecommerce.carrello' )
	);

	// carrello
	$p['ecommerce.pagamento'] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'pagamento' ),
		'h1'			=> array( $l		=> 'pagamento' ),
		'parent'		=> array( 'id'		=> 'ecommerce' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'ecommerce.pagamento.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_ecommerce.pagamento.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> 'ecommerce.carrello' )
	);

    // carrello
	$p['carrello'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'carrello' ),
	    'h1'			=> array( $l		=> 'carrello' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'template'		=> array( 'path'	=> '_src/_templates/_lydia/', 'schema' => 'carrello.html' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_carrello.php' ),
	    'metadati'		=> array( 'ruolo'	=> 'carrello' ),
		'menu'			=> array( 'icons'	=> array(	'' => 	array(	'label'		=> array( $l => '<i class="fa fa-shopping-cart" aria-hidden="true"></i>' ), 'priority'	=> '800' ) ) )
	);

    // riepilogo
	$p['carrello.riepilogo'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'riepilogo' ),
	    'h1'			=> array( $l		=> 'riepilogo' ),
	    'parent'		=> array( 'id'		=> 'carrello' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_lydia/', 'schema' => 'carrello.riepilogo.html' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_carrello.riepilogo.php' ),
		'metadati'		=> array( 'profilo_registrazione'	=>	'sito' )
	);

    // checkout
	$p['carrello.checkout'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'checkout ordine' ),
	    'h1'			=> array( $l		=> 'conclusione ordine' ),
	    'h2'			=> array( $l		=> NULL ),
	    'parent'		=> array( 'id'		=> 'carrello' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_lydia/', 'schema' => 'carrello.checkout.html' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_carrello.checkout.php' )
	);

    // checkout
	$p['carrello.esito'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'esito ordine' ),
	    'h1'			=> array( $l		=> 'conclusione ordine' ),
	    'h2'			=> array( $l		=> NULL ),
	    'parent'		=> array( 'id'		=> 'carrello' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_lydia/', 'schema' => 'carrello.esito.html' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_carrello.esito.php' )
	);

    // checkout
	$p['carrello.successo'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'esito ordine' ),
	    'h1'			=> array( $l		=> 'conclusione ordine' ),
	    'h2'			=> array( $l		=> NULL ),
	    'parent'		=> array( 'id'		=> 'carrello' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_lydia/', 'schema' => 'carrello.successo.html' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_carrello.successo.php' )
	);

    // checkout
	$p['carrello.fallimento'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'esito ordine' ),
	    'h1'			=> array( $l		=> 'conclusione ordine' ),
	    'h2'			=> array( $l		=> NULL ),
	    'parent'		=> array( 'id'		=> 'carrello' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_lydia/', 'schema' => 'carrello.fallimento.html' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_carrello.fallimento.php' )
	);
