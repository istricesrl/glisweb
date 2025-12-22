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
    $m = DIR_MOD . '_PA000.pagine/';

    // tools archivio produzione
    $p['contenuti.pagine.view'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'contenuti pagine' ),
        'h1'                => array( $l        => 'pagine' ),
        'parent'            => array( 'id'        => 'contenuti' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.pagine.view.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => array(    'contenuti.pagine.view',
                                                            'contenuti.pagine.view.archiviate',
                                                            'contenuti.pagine.tools' ) ),
        'menu'                => array( 'admin'    => array(    '' =>     array(    'label'        => array( $l => 'pagine' ),
                                                                            'priority'    => '100' ) ) )
    );

    // tools archivio produzione
    $p['contenuti.pagine.view.archiviate'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-box-archive" aria-hidden="true"></i>',
        'title'                => array( $l        => 'pagine archiviate' ),
        'h1'                => array( $l        => 'archiviate' ),
        'parent'            => array( 'id'        => 'contenuti.pagine.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.pagine.view.archiviate.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.pagine.view' )
    );

    // tools archivio produzione
    $p['contenuti.pagine.tools'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'                => array( $l        => 'azioni contenuti pagine' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'        => 'contenuti.pagine.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.pagine.tools.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.pagine.view' )
    );

    // tools archivio produzione
    $p['contenuti.pagine.form'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'contenuti pagine form' ),
        'h1'                => array( $l        => 'gestione' ),
        'parent'            => array( 'id'        => 'contenuti.pagine.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'contenuti.pagine.form.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.pagine.form.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => array(    'contenuti.pagine.form',
                                                            'contenuti.pagine.form.archiviazione',
                                                            'contenuti.pagine.form.tools' ) )
    );

    // RELAZIONI CON IL MODULO CONTENUTI
    if( in_array( "CO000.contenuti", $cf['mods']['active']['array'] ) ) {
        arrayInsertBefore( 'contenuti.pagine.form.archiviazione', $p['contenuti.pagine.form']['etc']['tabs'], 'contenuti.pagine.form.sem' );
        arrayInsertBefore( 'contenuti.pagine.form.archiviazione', $p['contenuti.pagine.form']['etc']['tabs'], 'contenuti.pagine.form.contenuti' );
        arrayInsertBefore( 'contenuti.pagine.form.archiviazione', $p['contenuti.pagine.form']['etc']['tabs'], 'contenuti.pagine.form.javascript' );
        arrayInsertBefore( 'contenuti.pagine.form.archiviazione', $p['contenuti.pagine.form']['etc']['tabs'], 'contenuti.pagine.form.menu' );
    }

    // RELAZIONI CON IL MODULO IMMAGINI
    if( in_array( "IM000.immagini", $cf['mods']['active']['array'] ) ) {
        arrayInsertBefore( 'contenuti.pagine.form.archiviazione', $p['contenuti.pagine.form']['etc']['tabs'], 'contenuti.pagine.form.immagini' );
    }

    // RELAZIONI CON IL MODULO VIDEO
    if( in_array( "VI000.video", $cf['mods']['active']['array'] ) ) {
        arrayInsertBefore( 'contenuti.pagine.form.archiviazione', $p['contenuti.pagine.form']['etc']['tabs'], 'contenuti.pagine.form.video' );
    }

    // tools archivio produzione
    $p['contenuti.pagine.form.menu'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-bars" aria-hidden="true"></i>',
        'title'                => array( $l        => 'contenuti pagine form menu' ),
        'h1'                => array( $l        => 'menu' ),
        'parent'            => array( 'id'        => 'contenuti.pagine.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'contenuti.pagine.form.menu.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.pagine.form.menu.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.pagine.form' )
    );

    // tools archivio produzione
    $p['contenuti.pagine.form.archiviazione'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-box-archive" aria-hidden="true"></i>',
        'title'                => array( $l        => 'archiviazione contenuti pagine form' ),
        'h1'                => array( $l        => 'archiviazione' ),
        'parent'            => array( 'id'        => 'contenuti.pagine.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'contenuti.pagine.form.archiviazione.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.pagine.form.archiviazione.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.pagine.form' )
    );

    // tools archivio produzione
    $p['contenuti.pagine.form.tools'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'                => array( $l        => 'azioni contenuti pagine form' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'        => 'contenuti.pagine.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.pagine.form.tools.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.pagine.form' )
    );

