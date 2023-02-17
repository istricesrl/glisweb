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
	    'cacheable'		=> ( ( SITE_STATUS == PRODUCTION ) ? true : false ),
        'headers'		=> array( 'Cache-Control: no-cache, must-revalidate' ),
        'http'          => array( 'status' => 404 ),
//	    'title'		    => array( $l		=> 'pagina generata automaticamente' ),
//	    'h1'		    => array( $l		=> 'pagina generata automaticamente' ),
	    'title'		    => array( $l		=> 'pagina non trovata' ),
	    'h1'		    => array( $l		=> 'pagina non trovata' ),
        'template'		=> array( 'path'	=> '_src/_templates/_aurora/', 'schema' => 'default.html' ),
	    'parent'		=> array( 'id'		=> NULL ),
//	    'content'		=> array( $l		=> '<p>pagina generata il ' . date( 'Y-m-d H:i:s' ) . '</p>' ),
	    'content'		=> array( $l		=> '<p>la pagina che stai cercando non esiste più, oppure è stata spostata!</p><p>prova a ripartire dalla <a href="/">home page</a></p>' ),
	    'rewrited'		=> array( $l		=> NULL )
	);
