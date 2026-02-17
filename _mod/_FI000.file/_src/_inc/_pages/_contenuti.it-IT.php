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

    // RELAZIONI CON IL MODULO contenuti
    if( in_array( "03000.contenuti", $cf['mods']['active']['array'] ) ) {
        arrayInsertSeq( 'contenuti.archivio', $p['contenuti.archivio']['etc']['tabs'], 'contenuti.archivio.file.view' );
    }

    // tools archivio contenuti
    $p['contenuti.archivio.file.view'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'contenuti file' ),
        'h1'                => array( $l        => 'file' ),
        'parent'            => array( 'id'        => 'contenuti.archivio' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.archivio.file.view.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.archivio' )
    );

    // tools archivio contenuti
    $p['contenuti.archivio.file.tools'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'                => array( $l        => 'azioni contenuti file' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'        => 'contenuti.archivio.file.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.archivio.file.tools.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.archivio.file.view' )
    );

    // tools archivio contenuti
    $p['contenuti.archivio.file.form'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'contenuti file form' ),
        'h1'                => array( $l        => 'gestione' ),
        'parent'            => array( 'id'        => 'contenuti.archivio.file.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'contenuti.archivio.file.form.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.archivio.file.form.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => array(    'contenuti.archivio.file.form',
                                                            'contenuti.archivio.file.form.tools' ) )
    );

    // tools archivio contenuti
    $p['contenuti.archivio.file.form.tools'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'                => array( $l        => 'azioni contenuti file form' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'        => 'contenuti.archivio.file.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.archivio.file.form.tools.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.archivio.file.form' )
    );

    // gestione pagine form file
    $p['contenuti.pagine.form.file'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-image" aria-hidden="true"></i>',
        'title'                => array( $l        => 'file' ),
        'h1'                => array( $l        => 'file' ),
        'parent'            => array( 'id'        => 'contenuti.pagine.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'contenuti.pagine.form.file.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.pagine.form.file.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.pagine.form' )
    );

    // gestione pagine form file
    $p['contenuti.notizie.form.file'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-image" aria-hidden="true"></i>',
        'title'                => array( $l        => 'file' ),
        'h1'                => array( $l        => 'file' ),
        'parent'            => array( 'id'        => 'contenuti.notizie.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'contenuti.notizie.form.file.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.notizie.form.file.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.notizie.form' )
    );

    // gestione pagine form file
    $p['contenuti.categorie.notizie.form.file'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-image" aria-hidden="true"></i>',
        'title'                => array( $l        => 'file' ),
        'h1'                => array( $l        => 'file' ),
        'parent'            => array( 'id'        => 'contenuti.categorie.notizie.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'contenuti.categorie.notizie.form.file.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.categorie.notizie.form.file.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.categorie.notizie.form' )
    );
