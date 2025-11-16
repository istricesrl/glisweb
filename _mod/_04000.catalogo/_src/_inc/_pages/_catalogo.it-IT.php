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
    $m = DIR_MOD . '_04000.catalogo/';

    // dashboard catalogo
    $p['catalogo'] = array(
        'sitemap'        => false,
        'title'            => array( $l        => 'catalogo' ),
        'h1'            => array( $l        => 'catalogo' ),
        'parent'        => array( 'id'        => NULL ),
        'template'        => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'catalogo.twig' ),
        'macro'            => array( $m . '_src/_inc/_macro/_catalogo.php' ),
        'auth'            => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'            => array( 'tabs'    => array(    'catalogo',
                                                        'catalogo.tools'
                                                         ) ),
        'menu'                => array( 'admin'    => array(    '' =>     array(    'label'        => array( $l => 'catalogo' ),
                                                                        'priority'    => '4000' ) ) )                                                        
    );

    // tools catalogo
    $p['catalogo.tools'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'                => array( $l        => 'azioni' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'        => 'catalogo' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.tools.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'catalogo' )
    );

    // dashboard catalogo
    $p['catalogo.archivio'] = array(
        'sitemap'        => false,
        'title'            => array( $l        => 'archivio catalogo' ),
        'h1'            => array( $l        => 'archivio' ),
        'parent'        => array( 'id'        => 'catalogo' ),
        'template'        => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'catalogo.archivio.twig' ),
        'macro'            => array( $m . '_src/_inc/_macro/_catalogo.archivio.php' ),
        'auth'            => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'            => array( 'tabs'    => array(    'catalogo.archivio',
                                                        'catalogo.archivio.tools'
                                                         ) ),
        'menu'                => array( 'admin'    => array(    '' =>     array(    'label'        => array( $l => 'archivio' ),
                                                                        'priority'    => '4900' ) ) )                                                        
    );

    // tools archivio catalogo
    $p['catalogo.archivio.tools'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'                => array( $l        => 'azioni' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'        => 'catalogo.archivio' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.archivio.tools.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'catalogo.archivio' )
    );

