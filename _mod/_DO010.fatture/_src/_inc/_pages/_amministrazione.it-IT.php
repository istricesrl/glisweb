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
    $m = DIR_MOD . '_DO010.fatture/';

    // tools archivio amministrazione
    $p['amministrazione.ciclo.attivo.fatture.view'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'amministrazione fatture attive' ),
        'h1'                => array( $l        => 'fatture' ),
        'parent'            => array( 'id'        => 'amministrazione.ciclo.attivo' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_amministrazione.ciclo.attivo.fatture.view.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => array(    'amministrazione.ciclo.attivo.fatture.view',
                                                            'amministrazione.ciclo.attivo.fatture.articoli.view',
                                                            'amministrazione.ciclo.attivo.fatture.pagamenti.view',
                                                            'amministrazione.ciclo.attivo.fatture.view.archiviate',
                                                            'amministrazione.ciclo.attivo.fatture.tools' ) ),
        'menu'                => array( 'admin'    => array(    '' =>     array(    'label'        => array( $l => 'fatture' ),
                                                                            'priority'    => '600' ) ) )
    );

    // tools archivio amministrazione
    $p['amministrazione.ciclo.attivo.fatture.articoli.view'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'fatture articoli' ),
        'h1'                => array( $l        => 'righe' ),
        'parent'            => array( 'id'        => 'amministrazione.ciclo.attivo.fatture.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_amministrazione.ciclo.attivo.fatture.articoli.view.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'amministrazione.ciclo.attivo.fatture.view' )
    );

    // tools archivio amministrazione
    $p['amministrazione.ciclo.attivo.fatture.pagamenti.view'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'fatture pagamenti' ),
        'h1'                => array( $l        => 'pagamenti' ),
        'parent'            => array( 'id'        => 'amministrazione.ciclo.attivo.fatture.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_amministrazione.ciclo.attivo.fatture.pagamenti.view.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'amministrazione.ciclo.attivo.fatture.view' )
    );

    // tools archivio amministrazione
    $p['amministrazione.ciclo.attivo.fatture.view.archiviate'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-box-archive" aria-hidden="true"></i>',
        'title'                => array( $l        => 'fatture archiviate' ),
        'h1'                => array( $l        => 'archiviate' ),
        'parent'            => array( 'id'        => 'amministrazione.ciclo.attivo.fatture.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_amministrazione.ciclo.attivo.fatture.view.archiviate.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'amministrazione.ciclo.attivo.fatture.view' )
    );

    // tools archivio amministrazione
    $p['amministrazione.ciclo.attivo.fatture.tools'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'                => array( $l        => 'azioni amministrazione fatture' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'        => 'amministrazione.ciclo.attivo.fatture.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_amministrazione.ciclo.attivo.fatture.tools.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'amministrazione.ciclo.attivo.fatture.view' )
    );

    // tools archivio amministrazione
    $p['amministrazione.ciclo.attivo.fatture.form'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'amministrazione fatture attive form' ),
        'h1'                => array( $l        => 'gestione' ),
        'parent'            => array( 'id'        => 'amministrazione.ciclo.attivo.fatture.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'amministrazione.ciclo.attivo.fatture.form.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_amministrazione.ciclo.attivo.fatture.form.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => array(    'amministrazione.ciclo.attivo.fatture.form',
                                                            'amministrazione.ciclo.attivo.fatture.form.documenti.articoli',
                                                            'amministrazione.ciclo.attivo.fatture.form.pagamenti',
                                                            'amministrazione.ciclo.attivo.fatture.form.relazioni',
                                                            'amministrazione.ciclo.attivo.fatture.form.archiviazione',
                                                            'amministrazione.ciclo.attivo.fatture.form.stampe',
                                                            'amministrazione.ciclo.attivo.fatture.form.tools' ) )
    );

    // tools archivio amministrazione
    $p['amministrazione.ciclo.attivo.fatture.form.relazioni'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-solid fa-diagram-project" aria-hidden="true"></i>',
        'title'                => array( $l        => 'amministrazione fatture attive form relazioni' ),
        'h1'                => array( $l        => 'relazioni' ),
        'parent'            => array( 'id'        => 'amministrazione.ciclo.attivo.fatture.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'amministrazione.ciclo.attivo.fatture.form.relazioni.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_amministrazione.ciclo.attivo.fatture.form.relazioni.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'amministrazione.ciclo.attivo.fatture.form' )
    );

    // tools archivio amministrazione
    $p['amministrazione.ciclo.attivo.fatture.form.documenti.articoli'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'amministrazione fatture attive form righe' ),
        'h1'                => array( $l        => 'righe' ),
        'parent'            => array( 'id'        => 'amministrazione.ciclo.attivo.fatture.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'amministrazione.ciclo.attivo.fatture.form.documenti.articoli.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_amministrazione.ciclo.attivo.fatture.form.documenti.articoli.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'amministrazione.ciclo.attivo.fatture.form' )
    );

    // tools archivio amministrazione
    $p['amministrazione.ciclo.attivo.fatture.form.pagamenti'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'amministrazione fatture attive form pagamenti' ),
        'h1'                => array( $l        => 'pagamenti' ),
        'parent'            => array( 'id'        => 'amministrazione.ciclo.attivo.fatture.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'amministrazione.ciclo.attivo.fatture.form.pagamenti.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_amministrazione.ciclo.attivo.fatture.form.pagamenti.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'amministrazione.ciclo.attivo.fatture.form' )
    );

    // tools archivio amministrazione
    $p['amministrazione.ciclo.attivo.fatture.form.archiviazione'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-box-archive" aria-hidden="true"></i>',
        'title'                => array( $l        => 'archiviazione amministrazione fatture attive form' ),
        'h1'                => array( $l        => 'archiviazione' ),
        'parent'            => array( 'id'        => 'amministrazione.ciclo.attivo.fatture.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'amministrazione.ciclo.attivo.fatture.form.archiviazione.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_amministrazione.ciclo.attivo.fatture.form.archiviazione.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'amministrazione.ciclo.attivo.fatture.form' )
    );

    // tools archivio amministrazione
    $p['amministrazione.ciclo.attivo.fatture.form.stampe'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-print" aria-hidden="true"></i>',
        'title'                => array( $l        => 'amministrazione fatture attive form stampe' ),
        'h1'                => array( $l        => 'stampe' ),
        'parent'            => array( 'id'        => 'amministrazione.ciclo.attivo.fatture.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_amministrazione.ciclo.attivo.fatture.form.stampe.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'amministrazione.ciclo.attivo.fatture.form' )
    );

    // tools archivio amministrazione
    $p['amministrazione.ciclo.attivo.fatture.form.tools'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'                => array( $l        => 'azioni amministrazione fatture attive form' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'        => 'amministrazione.ciclo.attivo.fatture.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_amministrazione.ciclo.attivo.fatture.form.tools.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'amministrazione.ciclo.attivo.fatture.form' )
    );
