<?php

    /**
     * definizione della pagina di default per la lingua italiana
     *
     *
     *
     * @todo commentare
     *
     * @file
     *
     */

    // lingua di questo file
	$l = 'it-IT';

    // pagina di default
	$p[ NULL ] = array(
	    'sitemap'		=> false,
	    'headers'		=> array( 'Cache-Control: no-cache, must-revalidate' ),
	    'title'		=> array( $l		=> 'pagina generata automaticamente' ),
	    'h1'		=> array( $l		=> 'pagina generata automaticamente' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_aurora/', 'schema' => 'default.html' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'content'		=> array( $l		=> '<p>pagina generata il ' . date( 'Y-m-d H:i:s' ) . '</p>' ),
	    'rewrited'		=> array( $l		=> NULL )
	);
