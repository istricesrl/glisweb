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

    // RELAZIONI CON IL MODULO ACQUISTI
    if( in_array( "06400.acquisti", $cf['mods']['active']['array'] ) ) {

        // tools archivio produzione
        $p['acquisti.listini.acquisto.view'] = array(
            'sitemap'            => false,
            'title'                => array( $l        => 'listini acquisto' ),
            'h1'                => array( $l        => 'listini acquisto' ),
            'parent'            => array( 'id'        => 'acquisti' ),
            'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
            'macro'                => array( $m . '_src/_inc/_macro/_acquisti.listini.acquisto.view.php' ),
            'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
            'etc'                => array( 'tabs'    => array(    'acquisti.listini.acquisto.view',
                                                                'acquisti.listini.acquisto.view.archiviati',
                                                                'acquisti.listini.acquisto.stampe',
                                                                'acquisti.listini.acquisto.tools' ) ),
            'menu'                => array( 'admin'    => array(    '' =>     array(    'label'        => array( $l => 'listini' ),
                                                                                'priority'    => '200' ) ) )
        );

        // tools listini acquisto archiviati
        $p['acquisti.listini.acquisto.view.archiviati'] = array(
            'sitemap'            => false,
            'icon'                => '<i class="fa fa-box-archive" aria-hidden="true"></i>',
            'title'                => array( $l        => 'listini acquisto archiviati' ),
            'h1'                => array( $l        => 'archiviati' ),
            'parent'            => array( 'id'        => 'acquisti.listini.acquisto.view' ),
            'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
            'macro'                => array( $m . '_src/_inc/_macro/_acquisti.listini.acquisto.view.archiviati.php' ),
            'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
            'etc'                => array( 'tabs'    => 'acquisti.listini.acquisto.view' )
        );

        // acquisti listini acquisto stampe
        $p['acquisti.listini.acquisto.stampe'] = array(
            'sitemap'            => false,
            'icon'                => '<i class="fa fa-print" aria-hidden="true"></i>',
            'title'                => array( $l        => 'acquisti listini acquisto stampe' ),
            'h1'                => array( $l        => 'stampe' ),
            'parent'            => array( 'id'        => 'acquisti.listini.acquisto.view' ),
            'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
            'macro'                => array( $m . '_src/_inc/_macro/_acquisti.listini.acquisto.stampe.php' ),
            'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
            'etc'                => array( 'tabs'    => 'acquisti.listini.acquisto.view' )
        );

        // tools acquisti listini acquisto
        $p['acquisti.listini.acquisto.tools'] = array(
            'sitemap'            => false,
            'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
            'title'                => array( $l        => 'azioni acquisti listini acquisto' ),
            'h1'                => array( $l        => 'azioni' ),
            'parent'            => array( 'id'        => 'acquisti.listini.acquisto.view' ),
            'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
            'macro'                => array( $m . '_src/_inc/_macro/_acquisti.listini.acquisto.tools.php' ),
            'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
            'etc'                => array( 'tabs'    => 'acquisti.listini.acquisto.view' )
        );

        // geatione listini acquisto
        $p['acquisti.listini.acquisto.form'] = array(
            'sitemap'            => false,
            'title'                => array( $l        => 'acquisti listini acquisto form' ),
            'h1'                => array( $l        => 'gestione' ),
            'parent'            => array( 'id'        => 'acquisti.listini.acquisto.view' ),
            'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'acquisti.listini.acquisto.form.twig' ),
            'macro'                => array( $m . '_src/_inc/_macro/_acquisti.listini.acquisto.form.php' ),
            'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
            'etc'                => array( 'tabs'    => array(    'acquisti.listini.acquisto.form',
                                                                'acquisti.listini.acquisto.form.tools' ) )
        );

    }
