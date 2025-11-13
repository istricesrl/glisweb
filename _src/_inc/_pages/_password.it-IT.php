<?php

    // lingua di questo file
	$l = 'it-IT';

    // reset password
	$p['password.reset'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'reset password' ),
	    'h1'		=> array( $l		=> 'reset password' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'template'		=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'password.reset.twig' ),
	    'macro'		=> array( '_src/_inc/_macro/_password.reset.php' )
	);

    // reset password
	$p['password.reinsert'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'reimpostazione password' ),
	    'h1'		=> array( $l		=> 'reimpostazione password' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'template'		=> array( 'path'	=> '_src/_tpl/_lydia/', 'schema' => 'password.reset.twig' ),
	    'macro'		=> array( '_src/_inc/_macro/_password.reset.php' )
	);

    // debug
    // die();
