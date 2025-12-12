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
    $m = DIR_MOD . '_IM000.immagini/';

    // RELAZIONI CON IL MODULO CONTENUTI
    if( in_array( "03000.contenuti", $cf['mods']['active']['array'] ) ) {
        arrayInsertSeq( 'contenuti.archivio', $p['contenuti.archivio']['etc']['tabs'], 'contenuti.archivio.immagini.view' );
    }

    // tools archivio contenuti
    $p['contenuti.archivio.immagini.view'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'contenuti immagini' ),
        'h1'                => array( $l        => 'immagini' ),
        'parent'            => array( 'id'        => 'contenuti.archivio' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.archivio.immagini.view.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.archivio' )
    );

    // tools archivio contenuti
    $p['contenuti.archivio.immagini.tools'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'                => array( $l        => 'azioni contenuti immagini' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'        => 'contenuti.archivio.immagini.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.archivio.immagini.tools.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.archivio.immagini.view' )
    );

    // tools archivio contenuti
    $p['contenuti.archivio.immagini.form'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'contenuti immagini form' ),
        'h1'                => array( $l        => 'gestione' ),
        'parent'            => array( 'id'        => 'contenuti.archivio.immagini.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'contenuti.archivio.immagini.form.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.archivio.immagini.form.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => array(    'contenuti.archivio.immagini.form',
                                                            'contenuti.archivio.immagini.form.tools' ) )
    );

    // tools archivio contenuti
    $p['contenuti.archivio.immagini.form.tools'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'                => array( $l        => 'azioni contenuti immagini form' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'        => 'contenuti.archivio.immagini.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.archivio.immagini.form.tools.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.archivio.immagini.form' )
    );

    // gestione pagine form immagini
    $p['contenuti.pagine.form.immagini'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-image" aria-hidden="true"></i>',
        'title'                => array( $l        => 'immagini' ),
        'h1'                => array( $l        => 'immagini' ),
        'parent'            => array( 'id'        => 'contenuti.pagine.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'contenuti.pagine.form.immagini.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.pagine.form.immagini.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.pagine.form' )
    );

    // gestione pagine form immagini
    $p['contenuti.notizie.form.immagini'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-image" aria-hidden="true"></i>',
        'title'                => array( $l        => 'immagini' ),
        'h1'                => array( $l        => 'immagini' ),
        'parent'            => array( 'id'        => 'contenuti.notizie.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'contenuti.notizie.form.immagini.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.notizie.form.immagini.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.notizie.form' )
    );

    // gestione pagine form immagini
    $p['contenuti.categorie.notizie.form.immagini'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-image" aria-hidden="true"></i>',
        'title'                => array( $l        => 'immagini' ),
        'h1'                => array( $l        => 'immagini' ),
        'parent'            => array( 'id'        => 'contenuti.categorie.notizie.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'contenuti.categorie.notizie.form.immagini.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.categorie.notizie.form.immagini.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.categorie.notizie.form' )
    );
