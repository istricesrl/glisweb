<?php

    /** 
     * 
     * 
     * 
     * 
     * TODO documentare
     * 
     * 
     */

    // lingua di questo file
    $l = 'it-IT';

    // modulo di questo file
    $m = DIR_MOD . '_FI000.file/';

    // gestione catalogo marchi form file
    $p['catalogo.marchi.form.file'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa-regular fa-folder-open" aria-hidden="true"></i>',
        'title'                => array( $l        => 'file' ),
        'h1'                => array( $l        => 'file' ),
        'parent'            => array( 'id'        => 'catalogo.marchi.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'catalogo.marchi.form.file.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.marchi.form.file.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'catalogo.marchi.form' )
    );

    // gestione articoli form file
    $p['catalogo.articoli.form.file'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa-regular fa-folder-open" aria-hidden="true"></i>',
        'title'                => array( $l        => 'file' ),
        'h1'                => array( $l        => 'file' ),
        'parent'            => array( 'id'        => 'catalogo.articoli.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'catalogo.articoli.form.file.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.articoli.form.file.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'catalogo.articoli.form' )
    );

    // gestione pagine form file
    $p['catalogo.prodotti.form.file'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa-regular fa-folder-open" aria-hidden="true"></i>',
        'title'                => array( $l        => 'file' ),
        'h1'                => array( $l        => 'file' ),
        'parent'            => array( 'id'        => 'catalogo.prodotti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'catalogo.prodotti.form.file.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.prodotti.form.file.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'catalogo.prodotti.form' )
    );

    // gestione catalogo categorie prodotti form file
    $p['catalogo.categorie.prodotti.form.file'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa-regular fa-folder-open" aria-hidden="true"></i>',
        'title'                => array( $l        => 'file' ),
        'h1'                => array( $l        => 'file' ),
        'parent'            => array( 'id'        => 'catalogo.categorie.prodotti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'catalogo.categorie.prodotti.form.file.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.categorie.prodotti.form.file.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'catalogo.categorie.prodotti.form' )
    );
