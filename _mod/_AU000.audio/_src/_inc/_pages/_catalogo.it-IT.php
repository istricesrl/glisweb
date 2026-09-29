<?php

    /**
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
    $m = DIR_MOD . '_AU000.audio/';

    // gestione catalogo.prodotti form audio
    $p['catalogo.prodotti.form.audio'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-volume-up" aria-hidden="true"></i>',
        'title'                => array( $l        => 'audio' ),
        'h1'                => array( $l        => 'audio' ),
        'parent'            => array( 'id'        => 'catalogo.prodotti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'catalogo.prodotti.form.audio.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.prodotti.form.audio.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'catalogo.prodotti.form' )
    );

    // gestione catalogo prodotti form audio
    $p['catalogo.categorie.prodotti.form.audio'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-volume-up" aria-hidden="true"></i>',
        'title'                => array( $l        => 'audio' ),
        'h1'                => array( $l        => 'audio' ),
        'parent'            => array( 'id'        => 'catalogo.categorie.prodotti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'catalogo.categorie.prodotti.form.audio.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.categorie.prodotti.form.audio.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'catalogo.categorie.prodotti.form' )
    );

    // gestione catalogo articoli form audio
    $p['catalogo.articoli.form.audio'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-volume-up" aria-hidden="true"></i>',
        'title'                => array( $l        => 'audio' ),
        'h1'                => array( $l        => 'audio' ),
        'parent'            => array( 'id'        => 'catalogo.articoli.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'catalogo.articoli.form.audio.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.articoli.form.audio.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'catalogo.articoli.form' )
    );

        // gestione catalogo marchi form audio
    $p['catalogo.marchi.form.audio'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-volume-up" aria-hidden="true"></i>',
        'title'                => array( $l        => 'audio' ),
        'h1'                => array( $l        => 'audio' ),
        'parent'            => array( 'id'        => 'catalogo.marchi.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'catalogo.marchi.form.audio.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.marchi.form.audio.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'catalogo.marchi.form' )
    );