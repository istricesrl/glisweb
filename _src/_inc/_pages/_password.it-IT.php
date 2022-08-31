<?php

    // lingua di questo file
	$l = 'it-IT';

    // reset password
	$p['password.reset'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'reset password' ),
	    'h1'		=> array( $l		=> 'reset password' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'password.reset.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_password.reset.php' )
	);

    // reset password
	$p['password.reinsert'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'reimpostazione password' ),
	    'h1'		=> array( $l		=> 'reimpostazione password' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'template'		=> array( 'path'	=> '_src/_templates/_lydia/', 'schema' => 'password.reset.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_password.reset.php' )
	);

    // debug
    // die();
