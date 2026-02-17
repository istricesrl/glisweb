<?php

    /**
     * definizione delle pagine per la gestione delle immagini
     * 
     * 
     * 
     * 
     * 
     * TODO documentare
     * 
     */

    // lingua di questo file
    $l = 'it-IT';

    // modulo di questo file
    $m = DIR_MOD . '_IM000.immagini/';

    // gestione catalogo.prodotti form immagini
    $p['catalogo.prodotti.form.immagini'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-image" aria-hidden="true"></i>',
        'title'                => array( $l        => 'immagini' ),
        'h1'                => array( $l        => 'immagini' ),
        'parent'            => array( 'id'        => 'catalogo.prodotti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'catalogo.prodotti.form.immagini.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.prodotti.form.immagini.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'catalogo.prodotti.form' )
    );

    // gestione catalogo.prodotti form immagini
    $p['catalogo.categorie.prodotti.form.immagini'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-image" aria-hidden="true"></i>',
        'title'                => array( $l        => 'immagini' ),
        'h1'                => array( $l        => 'immagini' ),
        'parent'            => array( 'id'        => 'catalogo.categorie.prodotti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'catalogo.categorie.prodotti.form.immagini.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.categorie.prodotti.form.immagini.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'catalogo.categorie.prodotti.form' )
    );

    // gestione catalogo.prodotti form immagini
    $p['catalogo.articoli.form.immagini'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-image" aria-hidden="true"></i>',
        'title'                => array( $l        => 'immagini' ),
        'h1'                => array( $l        => 'immagini' ),
        'parent'            => array( 'id'        => 'catalogo.articoli.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'catalogo.articoli.form.immagini.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.articoli.form.immagini.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'catalogo.articoli.form' )
    );