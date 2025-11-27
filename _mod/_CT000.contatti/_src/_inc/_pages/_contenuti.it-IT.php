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
    $m = DIR_MOD . '_CT000.contatti/';

    // tools archivio produzione
    $p['contenuti.contatti.view'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'contenuti contatti' ),
        'h1'                => array( $l        => 'contatti' ),
        'parent'            => array( 'id'        => 'contenuti' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.contatti.view.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => array(    'contenuti.contatti.view',
                                                            'contenuti.contatti.view.archiviati',
                                                            'contenuti.contatti.tools' ) ),
        'menu'                => array( 'admin'    => array(    '' =>     array(    'label'        => array( $l => 'contatti' ),
                                                                            'priority'    => '800' ) ) )
    );

    // tools archivio produzione
    $p['contenuti.contatti.view.archiviati'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-box-archive" aria-hidden="true"></i>',
        'title'                => array( $l        => 'contatti archiviati' ),
        'h1'                => array( $l        => 'archiviati' ),
        'parent'            => array( 'id'        => 'contenuti.contatti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.contatti.view.archiviati.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.contatti.view' )
    );

    // tools archivio produzione
    $p['contenuti.contatti.tools'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'                => array( $l        => 'azioni contenuti contatti' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'        => 'contenuti.contatti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.contatti.tools.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.contatti.view' )
    );

    // tools archivio produzione
    $p['contenuti.contatti.form'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'contenuti contatti form' ),
        'h1'                => array( $l        => 'gestione' ),
        'parent'            => array( 'id'        => 'contenuti.contatti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'contenuti.contatti.form.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.contatti.form.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => array(    'contenuti.contatti.form',
                                                            'contenuti.contatti.form.dati',
                                                            'contenuti.contatti.form.archiviazione',
                                                            'contenuti.contatti.form.tools' ) )
    );

    // tools archivio produzione
    $p['contenuti.contatti.form.dati'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'contenuti contatti form dati' ),
        'h1'                => array( $l        => 'dati' ),
        'parent'            => array( 'id'        => 'contenuti.contatti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'contenuti.contatti.form.dati.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.contatti.form.dati.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.contatti.form' )
    );

    // tools archivio produzione
    $p['contenuti.contatti.form.archiviazione'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-box-archive" aria-hidden="true"></i>',
        'title'                => array( $l        => 'archiviazione contenuti contatti form' ),
        'h1'                => array( $l        => 'archiviazione' ),
        'parent'            => array( 'id'        => 'contenuti.contatti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'contenuti.contatti.form.archiviazione.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.contatti.form.archiviazione.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.contatti.form' )
    );

    // tools archivio produzione
    $p['contenuti.contatti.form.tools'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'                => array( $l        => 'azioni contenuti contatti form' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'        => 'contenuti.contatti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.contatti.form.tools.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.contatti.form' )
    );

    // tools archivio produzione
    $p['contenuti.contatti.form.archiviazione'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-box-archive" aria-hidden="true"></i>',
        'title'                => array( $l        => 'archiviazione contenuti contatti form' ),
        'h1'                => array( $l        => 'archiviazione' ),
        'parent'            => array( 'id'        => 'contenuti.contatti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'contenuti.contatti.form.archiviazione.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.contatti.form.archiviazione.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.contatti.form' )
    );

    // tools archivio produzione
    $p['contenuti.contatti.form.tools'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'                => array( $l        => 'azioni contenuti contatti form' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'        => 'contenuti.contatti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.contatti.form.tools.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.contatti.form' )
    );
