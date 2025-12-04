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
    $m = DIR_MOD . '_VI000.video/';

    // RELAZIONI CON IL MODULO contenuti
    if( in_array( "03000.contenuti", $cf['mods']['active']['array'] ) ) {
        arrayInsertSeq( 'contenuti.archivio', $p['contenuti.archivio']['etc']['tabs'], 'contenuti.archivio.video.view' );
    }

    // tools archivio contenuti
    $p['contenuti.archivio.video.view'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'contenuti video' ),
        'h1'                => array( $l        => 'video' ),
        'parent'            => array( 'id'        => 'contenuti.archivio' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.archivio.video.view.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.archivio' )
    );

    // tools archivio contenuti
    $p['contenuti.archivio.video.tools'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'                => array( $l        => 'azioni contenuti video' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'        => 'contenuti.archivio.video.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.archivio.video.tools.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.archivio.video.view' )
    );

    // tools archivio contenuti
    $p['contenuti.archivio.video.form'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'contenuti video form' ),
        'h1'                => array( $l        => 'gestione' ),
        'parent'            => array( 'id'        => 'contenuti.archivio.video.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'contenuti.archivio.video.form.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.archivio.video.form.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => array(    'contenuti.archivio.video.form',
                                                            'contenuti.archivio.video.form.tools' ) )
    );

    // tools archivio contenuti
    $p['contenuti.archivio.video.form.tools'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'                => array( $l        => 'azioni contenuti video form' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'        => 'contenuti.archivio.video.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.archivio.video.form.tools.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.archivio.video.form' )
    );

    // gestione pagine form video
    $p['contenuti.pagine.form.video'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-video" aria-hidden="true"></i>',
        'title'                => array( $l        => 'video' ),
        'h1'                => array( $l        => 'video' ),
        'parent'            => array( 'id'        => 'contenuti.pagine.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'contenuti.pagine.form.video.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.pagine.form.video.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.pagine.form' )
    );

    // gestione pagine form video
    $p['contenuti.notizie.form.video'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-video" aria-hidden="true"></i>',
        'title'                => array( $l        => 'video' ),
        'h1'                => array( $l        => 'video' ),
        'parent'            => array( 'id'        => 'contenuti.notizie.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'contenuti.notizie.form.video.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.notizie.form.video.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.notizie.form' )
    );

    // gestione pagine form video
    $p['contenuti.categorie.notizie.form.video'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-video" aria-hidden="true"></i>',
        'title'                => array( $l        => 'video' ),
        'h1'                => array( $l        => 'video' ),
        'parent'            => array( 'id'        => 'contenuti.categorie.notizie.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'contenuti.categorie.notizie.form.video.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.categorie.notizie.form.video.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.categorie.notizie.form' )
    );
