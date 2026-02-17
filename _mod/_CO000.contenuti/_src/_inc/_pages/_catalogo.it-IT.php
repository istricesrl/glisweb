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
    $m = DIR_MOD . '_CO000.contenuti/';

    // gestione prodotti form catalogo
    $p['catalogo.prodotti.form.web'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-brands fa-chrome" aria-hidden="true"></i>',
        'title'                => array( $l        => 'gestione web' ),
        'h1'                => array( $l        => 'web' ),
        'parent'            => array( 'id'        => 'catalogo.prodotti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'catalogo.prodotti.form.web.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.prodotti.form.web.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'catalogo.prodotti.form' )
    );

    // gestione prodotti form catalogo
    $p['catalogo.prodotti.form.sem'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-brands fa-google" aria-hidden="true"></i>',
        'title'                => array( $l        => 'seo/sem' ),
        'h1'                => array( $l        => 'SEO/SEM' ),
        'parent'            => array( 'id'        => 'catalogo.prodotti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'catalogo.prodotti.form.sem.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.prodotti.form.sem.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'catalogo.prodotti.form' )
    );

    // gestione prodotti form contenuti
    $p['catalogo.prodotti.form.contenuti'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-regular fa-file-lines" aria-hidden="true"></i>',
        'title'                => array( $l        => 'catalogo' ),
        'h1'                => array( $l        => 'catalogo' ),
        'parent'            => array( 'id'        => 'catalogo.prodotti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'catalogo.prodotti.form.contenuti.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.prodotti.form.contenuti.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'catalogo.prodotti.form' )
    );

    // gestione prodotti form catalogo
    $p['catalogo.categorie.prodotti.form.web'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-brands fa-chrome" aria-hidden="true"></i>',
        'title'                => array( $l        => 'gestione web' ),
        'h1'                => array( $l        => 'web' ),
        'parent'            => array( 'id'        => 'catalogo.categorie.prodotti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'catalogo.categorie.prodotti.form.web.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.categorie.prodotti.form.web.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'catalogo.categorie.prodotti.form' )
    );

    // gestione prodotti form catalogo
    $p['catalogo.categorie.prodotti.form.sem'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-brands fa-google" aria-hidden="true"></i>',
        'title'                => array( $l        => 'seo/sem' ),
        'h1'                => array( $l        => 'SEO/SEM' ),
        'parent'            => array( 'id'        => 'catalogo.categorie.prodotti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'catalogo.categorie.prodotti.form.sem.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.categorie.prodotti.form.sem.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'catalogo.categorie.prodotti.form' )
    );

    // gestione prodotti form contenuti
    $p['catalogo.categorie.prodotti.form.contenuti'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-regular fa-file-lines" aria-hidden="true"></i>',
        'title'                => array( $l        => 'catalogo' ),
        'h1'                => array( $l        => 'catalogo' ),
        'parent'            => array( 'id'        => 'catalogo.categorie.prodotti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'catalogo.categorie.prodotti.form.contenuti.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.categorie.prodotti.form.contenuti.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'catalogo.categorie.prodotti.form' )
    );

    // tools archivio produzione
    $p['catalogo.categorie.prodotti.form.menu'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-bars" aria-hidden="true"></i>',
        'title'                => array( $l        => 'catalogo categorie prodotti form menu' ),
        'h1'                => array( $l        => 'menu' ),
        'parent'            => array( 'id'        => 'catalogo.categorie.prodotti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'catalogo.categorie.prodotti.form.menu.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.categorie.prodotti.form.menu.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'catalogo.categorie.prodotti.form' )
    );
