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

    // tools archivio contenuti
    $p['contenuti.archivio.contenuti.view'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'contenuti' ),
        'h1'                => array( $l        => 'contenuti' ),
        'parent'            => array( 'id'        => 'contenuti.archivio' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.archivio.contenuti.view.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.archivio' )
    );

    // gestione pagine form contenuti
    $p['contenuti.archivio.contenuti.form'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'gestione contenuti' ),
        'h1'                => array( $l        => 'gestione' ),
        'parent'            => array( 'id'        => 'contenuti.archivio.contenuti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'contenuti.archivio.contenuti.form.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.archivio.contenuti.form.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => array(   'contenuti.archivio.contenuti.form',
                                                            'contenuti.archivio.contenuti.form.testo',
                                                            'contenuti.archivio.contenuti.form.tools' ) )
    );

    // gestione pagine form contenuti
    $p['contenuti.archivio.contenuti.form.testo'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'gestione testo' ),
        'h1'                => array( $l        => 'testo' ),
        'parent'            => array( 'id'        => 'contenuti.archivio.contenuti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'contenuti.archivio.contenuti.form.testo.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.archivio.contenuti.form.testo.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.archivio.contenuti.form' )
    );

    // gestione pagine form contenuti
    $p['contenuti.archivio.contenuti.form.sem'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'gestione SEO/SEM' ),
        'h1'                => array( $l        => 'SEO/SEM' ),
        'parent'            => array( 'id'        => 'contenuti.archivio.contenuti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'contenuti.archivio.contenuti.form.sem.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.archivio.contenuti.form.sem.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.archivio.contenuti.form' )
    );

    // tools archivio contenuti
    $p['contenuti.archivio.contenuti.form.tools'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'                => array( $l        => 'azioni archivio contenuti form' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'        => 'contenuti.archivio' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.archivio.contenuti.form.tools.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.archivio.contenuti.form' )
    );
    // RELAZIONI CON IL MODULO CONTENUTI
    if( in_array( "03000.contenuti", $cf['mods']['active']['array'] ) ) {
        arrayInsertBefore( 'contenuti.archivio.tools', $p['contenuti.archivio']['etc']['tabs'], 'contenuti.archivio.contenuti.view' );
    }

    // gestione pagine form contenuti
    $p['contenuti.pagine.form.sem'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-brands fa-google" aria-hidden="true"></i>',
        'title'                => array( $l        => 'seo/sem' ),
        'h1'                => array( $l        => 'SEO/SEM' ),
        'parent'            => array( 'id'        => 'contenuti.pagine.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'contenuti.pagine.form.sem.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.pagine.form.sem.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.pagine.form' )
    );

    // gestione pagine form contenuti
    $p['contenuti.pagine.form.contenuti'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-regular fa-file-lines" aria-hidden="true"></i>',
        'title'                => array( $l        => 'contenuti' ),
        'h1'                => array( $l        => 'contenuti' ),
        'parent'            => array( 'id'        => 'contenuti.pagine.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'contenuti.pagine.form.contenuti.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.pagine.form.contenuti.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.pagine.form' )
    );

    // gestione pagine form contenuti
    $p['contenuti.pagine.form.javascript'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-brands fa-square-js" aria-hidden="true"></i>',
        'title'                => array( $l        => 'javascript' ),
        'h1'                => array( $l        => 'javascript' ),
        'parent'            => array( 'id'        => 'contenuti.pagine.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'contenuti.pagine.form.javascript.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.pagine.form.javascript.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.pagine.form' )
    );

    // gestione notizie form contenuti
    $p['contenuti.notizie.form.web'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-brands fa-chrome" aria-hidden="true"></i>',
        'title'                => array( $l        => 'gestione web' ),
        'h1'                => array( $l        => 'web' ),
        'parent'            => array( 'id'        => 'contenuti.notizie.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'contenuti.notizie.form.web.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.notizie.form.web.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.notizie.form' )
    );

    // gestione notizie form contenuti
    $p['contenuti.notizie.form.sem'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-brands fa-google" aria-hidden="true"></i>',
        'title'                => array( $l        => 'seo/sem' ),
        'h1'                => array( $l        => 'SEO/SEM' ),
        'parent'            => array( 'id'        => 'contenuti.notizie.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'contenuti.notizie.form.sem.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.notizie.form.sem.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.notizie.form' )
    );

    // gestione notizie form contenuti
    $p['contenuti.notizie.form.contenuti'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-regular fa-file-lines" aria-hidden="true"></i>',
        'title'                => array( $l        => 'contenuti' ),
        'h1'                => array( $l        => 'contenuti' ),
        'parent'            => array( 'id'        => 'contenuti.notizie.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'contenuti.notizie.form.contenuti.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.notizie.form.contenuti.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.notizie.form' )
    );

    // gestione notizie form contenuti
    $p['contenuti.categorie.notizie.form.web'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-brands fa-chrome" aria-hidden="true"></i>',
        'title'                => array( $l        => 'gestione web' ),
        'h1'                => array( $l        => 'web' ),
        'parent'            => array( 'id'        => 'contenuti.categorie.notizie.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'contenuti.categorie.notizie.form.web.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.categorie.notizie.form.web.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.categorie.notizie.form' )
    );

    // tools archivio produzione
    $p['contenuti.categorie.notizie.form.menu'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-bars" aria-hidden="true"></i>',
        'title'                => array( $l        => 'contenuti categorie notizie form menu' ),
        'h1'                => array( $l        => 'menu' ),
        'parent'            => array( 'id'        => 'contenuti.categorie.notizie.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'contenuti.categorie.notizie.form.menu.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.categorie.notizie.form.menu.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.categorie.notizie.form' )
    );

    // gestione notizie form contenuti
    $p['contenuti.categorie.notizie.form.sem'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-brands fa-google" aria-hidden="true"></i>',
        'title'                => array( $l        => 'seo/sem' ),
        'h1'                => array( $l        => 'SEO/SEM' ),
        'parent'            => array( 'id'        => 'contenuti.categorie.notizie.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'contenuti.categorie.notizie.form.sem.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.categorie.notizie.form.sem.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.categorie.notizie.form' )
    );

    // gestione notizie form contenuti
    $p['contenuti.categorie.notizie.form.contenuti'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-regular fa-file-lines" aria-hidden="true"></i>',
        'title'                => array( $l        => 'contenuti' ),
        'h1'                => array( $l        => 'contenuti' ),
        'parent'            => array( 'id'        => 'contenuti.categorie.notizie.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'contenuti.categorie.notizie.form.contenuti.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.categorie.notizie.form.contenuti.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.categorie.notizie.form' )
    );
