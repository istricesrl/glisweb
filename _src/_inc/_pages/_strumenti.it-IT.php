<?php

    /**
     * definizione delle pagine generali del CMS per la lingua italiana
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
     * dashboard e pagine collegate
     * ============================
     * 
     * 
     */

    // pagina principale
    $p['strumenti'] = array(
        'sitemap'       => false,
        'title'         => array( $l        => 'strumenti' ),
        'h1'            => array( $l        => 'strumenti' ),
        'template'      => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'parent'        => array( 'id'      => NULL ),
        'macro'         => array( '_src/_inc/_macro/_strumenti.php' ),
        'auth'          => array( 'groups'  => array( 'roots', 'staff' ) ),
        'etc'           => array( 'tabs'    => array( 'strumenti' ) ),
        'menu'          => array( 'admin'   => array( '' => array( 'label' => array( $l => 'strumenti' ), 'priority' => '900' ) ) )
    );
