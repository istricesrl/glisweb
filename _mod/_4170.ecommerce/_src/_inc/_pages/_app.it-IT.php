<?php

    // lingua di questo file
	$l = 'it-IT';

    // pagina principale
	$p['app.carrello'] = array(
	    'sitemap'		=> false,
	    'cacheable'		=> false,
	    'title'		=> array( $l		=> 'carrello app' ),
	    'h1'		=> array( $l		=> 'carrello' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_minerva/', 'schema' => 'app.carrello.html' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'macro'		=> array( '_mod/_4170.ecommerce/_src/_inc/_macro/_app.carrello.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff', 'users' ) ),
		'menu'			=> array( 'app-icons'	=> array(	'' => 	array(	'label'		=> array( $l => '<i class="fa fa-shopping-cart" aria-hidden="true"></i>' ), 'priority'	=> '900', 'visualizza' => SHOW_ALWAYS ) ) )
	);
