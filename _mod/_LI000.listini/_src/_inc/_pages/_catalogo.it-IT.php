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
    $m = DIR_MOD . '_LI000.listini/';

    // RELAZIONI CON IL MODULO CATALOGO
    if( in_array( "04000.catalogo", $cf['mods']['active']['array'] ) ) {

        // tools archivio produzione
        $p['catalogo.listini.vendita.view'] = array(
            'sitemap'            => false,
            'title'                => array( $l        => 'listini vendita' ),
            'h1'                => array( $l        => 'listini vendita' ),
            'parent'            => array( 'id'        => 'catalogo' ),
            'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
            'macro'                => array( $m . '_src/_inc/_macro/_catalogo.listini.vendita.view.php' ),
            'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
            'etc'                => array( 'tabs'    => array(    'catalogo.listini.vendita.view',                                
                                                                'catalogo.listini.vendita.view.archiviati',
                                                                'catalogo.listini.vendita.stampe',
                                                                'catalogo.listini.vendita.tools' ) ),
            'menu'                => array( 'admin'    => array(    '' =>     array(    'label'        => array( $l => 'listini' ),
                                                                                'priority'    => '200' ) ) )
        );

        // tools listini vendita archiviati
        $p['catalogo.listini.vendita.view.archiviati'] = array(
            'sitemap'            => false,
            'icon'                => '<i class="fa fa-box-archive" aria-hidden="true"></i>',
            'title'                => array( $l        => 'listini vendita archiviati' ),
            'h1'                => array( $l        => 'archiviati' ),
            'parent'            => array( 'id'        => 'catalogo.listini.vendita.view' ),
            'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
            'macro'                => array( $m . '_src/_inc/_macro/_catalogo.listini.vendita.view.archiviati.php' ),
            'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
            'etc'                => array( 'tabs'    => 'catalogo.listini.vendita.view' )
        );

        // catalogo listini vendita stampe
        $p['catalogo.listini.vendita.stampe'] = array(
            'sitemap'            => false,
            'icon'                => '<i class="fa fa-print" aria-hidden="true"></i>',
            'title'                => array( $l        => 'catalogo listini vendita stampe' ),
            'h1'                => array( $l        => 'stampe' ),
            'parent'            => array( 'id'        => 'catalogo.listini.vendita.view' ),
            'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
            'macro'                => array( $m . '_src/_inc/_macro/_catalogo.listini.vendita.stampe.php' ),
            'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
            'etc'                => array( 'tabs'    => 'catalogo.listini.vendita.view' )
        );

        // tools catalogo listini vendita
        $p['catalogo.listini.vendita.tools'] = array(
            'sitemap'            => false,
            'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
            'title'                => array( $l        => 'azioni catalogo listini vendita' ),
            'h1'                => array( $l        => 'azioni' ),
            'parent'            => array( 'id'        => 'catalogo.listini.vendita.view' ),
            'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
            'macro'                => array( $m . '_src/_inc/_macro/_catalogo.listini.vendita.tools.php' ),
            'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
            'etc'                => array( 'tabs'    => 'catalogo.listini.vendita.view' )
        );

    // geatione listini vendita
    $p['catalogo.listini.vendita.form'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'catalogo listini vendita form' ),
        'h1'                => array( $l        => 'gestione' ),
        'parent'            => array( 'id'        => 'catalogo.listini.vendita.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'catalogo.listini.vendita.form.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.listini.vendita.form.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => array(    'catalogo.listini.vendita.form',
                                                            'catalogo.listini.vendita.form.archiviazione',
                                                            'catalogo.listini.vendita.form.stampe',
                                                            'catalogo.listini.vendita.form.tools' ) )
    );

    // catalogo listini vendita form archiviazione
    $p['catalogo.listini.vendita.form.archiviazione'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-box-archive" aria-hidden="true"></i>',
        'title'                => array( $l        => 'archiviazione catalogo listini vendita form' ),
        'h1'                => array( $l        => 'archiviazione' ),
        'parent'            => array( 'id'        => 'catalogo.listini.vendita.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'catalogo.listini.vendita.form.archiviazione.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.listini.vendita.form.archiviazione.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'catalogo.listini.vendita.form' )
    );


    // catalogo listini vendita form stampe
    $p['catalogo.listini.vendita.form.stampe'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-print" aria-hidden="true"></i>',
        'title'                => array( $l        => 'gestione catalogo listini vendita stampe' ),
        'h1'                => array( $l        => 'stampe' ),
        'parent'            => array( 'id'        => 'catalogo.listini.vendita.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.listini.vendita.form.stampe.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'catalogo.listini.vendita.form' )
    );


    // tools listini vendita form
    $p['catalogo.listini.vendita.form.tools'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'                => array( $l        => 'azioni catalogo listini vendita form' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'        => 'catalogo.listini.vendita.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.listini.vendita.form.tools.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'catalogo.listini.vendita.form' )
    );

    }
