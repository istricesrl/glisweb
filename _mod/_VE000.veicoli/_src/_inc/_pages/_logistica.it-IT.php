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
    $m = DIR_MOD . '_VE000.veicoli/';

    // tools archivio produzione
    $p['logistica.veicoli.view'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'logistica veicoli' ),
        'h1'                => array( $l        => 'veicoli' ),
        'parent'            => array( 'id'        => 'logistica' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_logistica.veicoli.view.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => array(    'logistica.veicoli.view',
                                                            'logistica.tipologie.veicoli.view',
                                                            'logistica.veicoli.view.archiviate',
                                                            'logistica.veicoli.tools' ) ),
        'menu'                => array( 'admin'    => array(    '' =>     array(    'label'        => array( $l => 'veicoli' ),
                                                                            'priority'    => '800' ) ) )
    );

    // tools archivio produzione
    $p['logistica.tipologie.veicoli.view'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'veicoli tipologie' ),
        'h1'                => array( $l        => 'tipologie' ),
        'parent'            => array( 'id'        => 'logistica.veicoli.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_logistica.tipologie.veicoli.view.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'logistica.veicoli.view' )
    );

    // tools archivio produzione
    $p['logistica.tipologie.veicoli.form'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'logistica tipologie veicoli form' ),
        'h1'                => array( $l        => 'gestione' ),
        'parent'            => array( 'id'        => 'logistica.tipologie.veicoli.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'logistica.tipologie.veicoli.form.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_logistica.tipologie.veicoli.form.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => array(    'logistica.tipologie.veicoli.form',
                                                            'logistica.tipologie.veicoli.form.tools' ) )
    );

    // tools archivio produzione
    $p['logistica.tipologie.veicoli.form.tools'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'                => array( $l        => 'azioni logistica veicoli' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'        => 'logistica.tipologie.veicoli.form' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_logistica.tipologie.veicoli.tools.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'logistica.tipologie.veicoli.form' )
    );

    // tools archivio produzione
    $p['logistica.veicoli.view.archiviate'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-box-archive" aria-hidden="true"></i>',
        'title'                => array( $l        => 'veicoli archiviate' ),
        'h1'                => array( $l        => 'archiviate' ),
        'parent'            => array( 'id'        => 'logistica.veicoli.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_logistica.veicoli.view.archiviate.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'logistica.veicoli.view' )
    );

    // tools archivio produzione
    $p['logistica.veicoli.tools'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'                => array( $l        => 'azioni logistica veicoli' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'        => 'logistica.veicoli.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_logistica.veicoli.tools.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'logistica.veicoli.view' )
    );

    // tools archivio produzione
    $p['logistica.veicoli.form'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'logistica veicoli form' ),
        'h1'                => array( $l        => 'gestione' ),
        'parent'            => array( 'id'        => 'logistica.veicoli.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'logistica.veicoli.form.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_logistica.veicoli.form.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => array(    'logistica.veicoli.form',
                                                            'logistica.veicoli.form.archiviazione',
                                                            'logistica.veicoli.form.tools' ) )
    );

