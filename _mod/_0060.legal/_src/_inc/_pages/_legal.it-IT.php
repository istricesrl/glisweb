<?php

    // lingua di questo file
	$l = 'it-IT';

	$m = DIR_MOD . '_0060.legal/';

	// pagina principale
	$p['privacy'] = array(
	    'sitemap'		=> false,
	    'title'		    => array( $l		=> 'privacy' ),
	    'h1'		    => array( $l		=> 'privacy e cookie policy' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_aurora/', 'schema' => 'default.html' ),
	    'parent'		=> array( 'id'		=> NULL )
	);

    // pagina principale
	$p['affiliazioni'] = array(
	    'sitemap'		=> false,
	    'title'		    => array( $l		=> 'divulgazione affiliazioni' ),
	    'h1'		    => array( $l		=> 'divulgazione delle affiliazioni' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_aurora/', 'schema' => 'default.html' ),
	    'parent'		=> array( 'id'		=> NULL )
	);

    // debug
    // die( __FILE__ );
