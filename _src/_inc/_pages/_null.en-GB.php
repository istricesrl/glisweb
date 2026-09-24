<?php

    /**
     * definizione della pagina di default per la lingua italiana
     *
     *
     *
     * TODO documentare
     *
     *
     */

    // lingua di questo file
    $l = 'en-GB';

    /**
     * pagina 404
     * ==========
     * 
     * 
     */

    // pagina di default
    $p[ NULL ] = array(
        'sitemap'       => false,
        'cacheable'     => false,
        'http'          => array( 'status'  => 404 ),
        'title'         => array( $l        => 'page not found' ),
        'h1'            => array( $l        => 'page not found' ),
        'template'      => array( 'path'    => '_src/_tpl/_aurora/', 'schema' => 'default.twig' ),
        'parent'        => array( 'id'      => NULL ),
        'content'       => array( $l        => '<p>the page you are looking for no longer exists, or has been moved!</p><p>try starting again from the <a href="/">home page</a></p>
                                                <p>page generated automatically on {{ now|date("Y/m/d H:i:s") }}</p>' ),
        'rewrited'      => array( $l        => NULL )
    );
