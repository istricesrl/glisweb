<?php

    /**
     * definizione delle pagine per la gestione dell'anagrafica
     * 
     * 
     * 
     * 
     * 
     * TODO documentare
     * TODO finire di mettere tutte le schede dell'anagrafica
     * 
     */

    // lingua di questo file
    $l = 'it-IT';

    // modulo di questo file
    $m = DIR_MOD . '_AC000.account/';

    // vista account
    $p['account.view'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'account' ),
        'h1'                => array( $l        => 'account' ),
        'parent'            => array( 'id'        => 'anagrafica.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_account.view.php' ),
        'auth'                => array( 'groups'    => array(    'roots' ) ),
        'etc'                => array( 'tabs'    => array(    'account.view',
                                                            'gruppi.view',
                                                            'account.tools' ) ),
        'menu'                => array( 'admin'    => array(    '' =>     array(    'label'        => array( $l => 'account' ),
                                                                            'priority'    => '800' ) ) )
    );

    // tools account
    $p['account.tools'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'                => array( $l        => 'azioni' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'        => 'account.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_account.tools.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'account.view' )
    );

    // gestione account
    $p['account.form'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'gestione' ),
        'h1'                => array( $l        => 'gestione' ),
        'parent'            => array( 'id'        => 'account.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'account.form.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_account.form.php' ),
        'auth'                => array( 'groups'    => array(    'roots' ) ),
        'etc'                => array( 'tabs'    => array(    'account.form',
                                                            // 'account.form.attribuzione',
                                                            'account.form.tools' ) )
    );

    // tools account
    $p['account.form.tools'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'                => array( $l        => 'azioni account' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'        => 'account.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_account.form.tools.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'account.form' )
    );

    // tools account
    $p['gruppi.view'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'gruppi' ),
        'h1'                => array( $l        => 'gruppi' ),
        'parent'            => array( 'id'        => 'account.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_gruppi.view.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'account.view' )
    );

    // gestione account
    $p['gruppi.form'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'gestione gruppi' ),
        'h1'                => array( $l        => 'gestione' ),
        'parent'            => array( 'id'        => 'gruppi.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'gruppi.form.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_gruppi.form.php' ),
        'auth'                => array( 'groups'    => array(    'roots' ) ),
        'etc'                => array( 'tabs'    => array(    'gruppi.form',
                                                            // 'gruppi.form.attribuzione',
                                                            'gruppi.form.tools' ) )
    );

    // tools account
    $p['gruppi.form.tools'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'                => array( $l        => 'azioni gruppo' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'        => 'gruppi.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_gruppi.form.tools.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'gruppi.form' )
    );

