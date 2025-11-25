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
    $l = 'it-IT';

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
        'title'         => array( $l        => 'pagina non trovata' ),
        'h1'            => array( $l        => 'pagina non trovata' ),
        'template'      => array( 'path'    => '_src/_tpl/_aurora/', 'schema' => 'default.twig' ),
        'parent'        => array( 'id'      => NULL ),
        'content'       => array( $l        => '<p>la pagina che stai cercando non esiste più, oppure è stata spostata!</p><p>prova a ripartire dalla <a href="/">home page</a></p>
                                                <p>pagina generata automaticamente il {{ now|date("Y/m/d H:i:s") }}</p>' ),
        'rewrited'      => array( $l        => NULL )
    );
