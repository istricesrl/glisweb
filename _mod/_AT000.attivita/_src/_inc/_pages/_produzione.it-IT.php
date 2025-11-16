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
    $m = DIR_MOD . '_AT000.attivita/';

    /* RELAZIONI CON IL MODULO PRODUZIONE
    if( in_array( "01000.produzione", $cf['mods']['active']['array'] ) ) {
        arrayInsertSeq( 'produzione', $p['produzione']['etc']['tabs'], 'produzione.attivita' );
        arrayInsertSeq( 'produzione.attivita', $p['produzione']['etc']['tabs'], 'produzione.tipologie.attivita' );
    }*/

    // tools archivio produzione
    $p['produzione.attivita.view'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'produzione attivita' ),
        'h1'                => array( $l        => 'attivita' ),
        'parent'            => array( 'id'        => 'produzione' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_produzione.attivita.view.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => array(    'produzione.attivita.view',
                                                            'produzione.tipologie.attivita.view',
                                                            'produzione.attivita.view.archiviate',
                                                            'produzione.attivita.tools' ) ),
        'menu'                => array( 'admin'    => array(    '' =>     array(    'label'        => array( $l => 'attivita' ),
                                                                            'priority'    => '600' ) ) )
    );

    // tools archivio produzione
    $p['produzione.tipologie.attivita.view'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'tipologie attivita' ),
        'h1'                => array( $l        => 'tipologie' ),
        'parent'            => array( 'id'        => 'produzione.attivita.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_produzione.tipologie.attivita.view.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'produzione.attivita.view' )
    );

    // tools archivio produzione
    $p['produzione.attivita.view.archiviate'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-box-archive" aria-hidden="true"></i>',
        'title'                => array( $l        => 'attivita archiviate' ),
        'h1'                => array( $l        => 'archiviate' ),
        'parent'            => array( 'id'        => 'produzione.attivita.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_produzione.attivita.view.archiviate.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'produzione.attivita.view' )
    );

    // tools archivio produzione
    $p['produzione.attivita.tools'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'                => array( $l        => 'azioni produzione attivita' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'        => 'produzione.attivita.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_produzione.attivita.tools.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'produzione.attivita.view' )
    );

    // tools archivio produzione
    $p['produzione.attivita.form'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'produzione attivita form' ),
        'h1'                => array( $l        => 'gestione' ),
        'parent'            => array( 'id'        => 'produzione.attivita.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'produzione.attivita.form.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_produzione.attivita.form.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => array(    'produzione.attivita.form',
                                                            'produzione.attivita.form.archiviazione',
                                                            'produzione.attivita.form.tools' ) )
    );

    // tools archivio produzione
    $p['produzione.attivita.form.archiviazione'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-box-archive" aria-hidden="true"></i>',
        'title'                => array( $l        => 'archiviazione produzione attivita form' ),
        'h1'                => array( $l        => 'archiviazione' ),
        'parent'            => array( 'id'        => 'produzione.attivita.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'produzione.attivita.form.archiviazione.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_produzione.attivita.form.archiviazione.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'produzione.attivita.form' )
    );

    // tools archivio produzione
    $p['produzione.attivita.form.tools'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'                => array( $l        => 'azioni produzione attivita form' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'        => 'produzione.attivita.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_produzione.attivita.form.tools.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'produzione.attivita.form' )
    );

    // tools archivio produzione
    $p['produzione.tipologie.attivita.view'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'produzione tipologie attivita' ),
        'h1'                => array( $l        => 'tipologie attivita' ),
        'parent'            => array( 'id'        => 'produzione.attivita.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_produzione.tipologie.attivita.view.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'produzione.attivita.view' )
    );

    // tools archivio produzione
    $p['produzione.tipologie.attivita.form'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'produzione tipologie attivita form' ),
        'h1'                => array( $l        => 'gestione' ),
        'parent'            => array( 'id'        => 'produzione.tipologie.attivita.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'produzione.tipologie.attivita.form.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_produzione.tipologie.attivita.form.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => array(    'produzione.tipologie.attivita.form',
                                                            'produzione.tipologie.attivita.form.tools' ) )
    );

    // tools archivio produzione
    $p['produzione.tipologie.attivita.form.tools'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'                => array( $l        => 'azioni produzione tipologie attivita form' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'        => 'produzione.tipologie.attivita.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_produzione.tipologie.attivita.form.tools.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'produzione.tipologie.attivita.form' )
    );

