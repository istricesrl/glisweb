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
    $m = DIR_MOD . '_DO000.documenti/';

    // RELAZIONI CON IL MODULO AMMINISTRAZIONE
    if( in_array( "06000.amministrazione", $cf['mods']['active']['array'] ) ) {
        arrayInsertSeq( 'amministrazione.archivio', $p['amministrazione.archivio']['etc']['tabs'], 'amministrazione.archivio.documenti.pagamenti.view' );
        arrayInsertSeq( 'amministrazione.archivio', $p['amministrazione.archivio']['etc']['tabs'], 'amministrazione.archivio.documenti.articoli.view' );
        arrayInsertSeq( 'amministrazione.archivio', $p['amministrazione.archivio']['etc']['tabs'], 'amministrazione.archivio.documenti.view' );
    }

    // tools archivio amministrazione
    $p['amministrazione.archivio.documenti.view'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'amministrazione archivio documenti' ),
        'h1'                => array( $l        => 'documenti' ),
        'parent'            => array( 'id'        => 'amministrazione.archivio' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_amministrazione.archivio.documenti.view.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
#        'etc'                => array( 'tabs'    => array(    'amministrazione.archivio.documenti.view',
#                                                            'amministrazione.archivio.documenti.articoli.view',
#                                                            'amministrazione.archivio.documenti.pagamenti.view',
#                                                            'amministrazione.archivio.documenti.tools' ) ),
        'etc'                => array( 'tabs'    => 'amministrazione.archivio' ),
#        'menu'                => array( 'admin'    => array(    '' =>     array(    'label'        => array( $l => 'documenti' ),
#                                                                            'priority'    => '600' ) ) )
    );

    // tools archivio amministrazione
    $p['amministrazione.archivio.documenti.articoli.view'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'documenti articoli' ),
        'h1'                => array( $l        => 'righe' ),
        'parent'            => array( 'id'        => 'amministrazione.archivio.documenti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_amministrazione.archivio.documenti.articoli.view.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'amministrazione.archivio' ),
    );

    // tools archivio amministrazione
    $p['amministrazione.archivio.documenti.pagamenti.view'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'documenti pagamenti' ),
        'h1'                => array( $l        => 'pagamenti' ),
        'parent'            => array( 'id'        => 'amministrazione.archivio.documenti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_amministrazione.archivio.documenti.pagamenti.view.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'amministrazione.archivio' ),
    );

    // tools archivio amministrazione
    $p['amministrazione.archivio.documenti.form'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'amministrazione archivio documenti form' ),
        'h1'                => array( $l        => 'gestione' ),
        'parent'            => array( 'id'        => 'amministrazione.archivio.documenti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'amministrazione.archivio.documenti.form.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_amministrazione.archivio.documenti.form.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => array(    'amministrazione.archivio.documenti.form',
                                                            'amministrazione.archivio.documenti.form.relazioni',
                                                            'amministrazione.archivio.documenti.form.documenti.articoli',
                                                            'amministrazione.archivio.documenti.form.pagamenti',
                                                            'amministrazione.archivio.documenti.form.archiviazione',
                                                            'amministrazione.archivio.documenti.form.stampe',
                                                            'amministrazione.archivio.documenti.form.tools' ) )
    );

    // tools archivio amministrazione
    $p['amministrazione.archivio.documenti.form.relazioni'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'amministrazione archivio documenti form relazioni' ),
        'h1'                => array( $l        => 'relazioni' ),
        'parent'            => array( 'id'        => 'amministrazione.archivio.documenti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'amministrazione.archivio.documenti.form.relazioni.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_amministrazione.archivio.documenti.form.relazioni.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'amministrazione.archivio.documenti.form' )
    );

    // tools archivio amministrazione
    $p['amministrazione.archivio.documenti.form.documenti.articoli'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'amministrazione archivio documenti form righe' ),
        'h1'                => array( $l        => 'righe' ),
        'parent'            => array( 'id'        => 'amministrazione.archivio.documenti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'amministrazione.archivio.documenti.form.documenti.articoli.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_amministrazione.archivio.documenti.form.documenti.articoli.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'amministrazione.archivio.documenti.form' )
    );

    // tools archivio amministrazione
    $p['amministrazione.archivio.documenti.form.pagamenti'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'amministrazione archivio documenti form pagamenti' ),
        'h1'                => array( $l        => 'pagamenti' ),
        'parent'            => array( 'id'        => 'amministrazione.archivio.documenti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'amministrazione.archivio.documenti.form.pagamenti.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_amministrazione.archivio.documenti.form.pagamenti.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'amministrazione.archivio.documenti.form' )
    );

    // tools archivio amministrazione
    $p['amministrazione.archivio.documenti.form.archiviazione'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-box-archive" aria-hidden="true"></i>',
        'title'                => array( $l        => 'archiviazione amministrazione archivio documenti form' ),
        'h1'                => array( $l        => 'archiviazione' ),
        'parent'            => array( 'id'        => 'amministrazione.archivio.documenti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'amministrazione.archivio.documenti.form.archiviazione.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_amministrazione.archivio.documenti.form.archiviazione.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'amministrazione.archivio.documenti.form' )
    );

    // tools archivio amministrazione
    $p['amministrazione.archivio.documenti.form.stampe'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-print" aria-hidden="true"></i>',
        'title'                => array( $l        => 'amministrazione archivio documenti form stampe' ),
        'h1'                => array( $l        => 'stampe' ),
        'parent'            => array( 'id'        => 'amministrazione.archivio.documenti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_amministrazione.archivio.documenti.form.stampe.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'amministrazione.archivio.documenti.form' )
    );

    // tools archivio amministrazione
    $p['amministrazione.archivio.documenti.form.tools'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'                => array( $l        => 'azioni amministrazione archivio documenti form' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'        => 'amministrazione.archivio.documenti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_amministrazione.archivio.documenti.form.tools.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'amministrazione.archivio.documenti.form' )
    );

    // tools archivio amministrazione
    $p['amministrazione.archivio.documenti.articoli.form'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'amministrazione archivio documenti articoli form' ),
        'h1'                => array( $l        => 'gestione' ),
        'parent'            => array( 'id'        => 'amministrazione.archivio.documenti.articoli.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'amministrazione.archivio.documenti.articoli.form.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_amministrazione.archivio.documenti.articoli.form.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => array(    'amministrazione.archivio.documenti.articoli.form',
                                                            'amministrazione.archivio.documenti.articoli.form.tools' ) )
    );

    // tools archivio amministrazione
    $p['amministrazione.archivio.documenti.articoli.form.tools'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'                => array( $l        => 'azioni amministrazione archivio documenti articoli form' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'        => 'amministrazione.archivio.documenti.articoli.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_amministrazione.archivio.documenti.articoli.form.tools.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'amministrazione.archivio.documenti.articoli.form' )
    );

    // tools archivio amministrazione
    $p['amministrazione.archivio.documenti.pagamenti.form'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'amministrazione archivio documenti pagamenti form' ),
        'h1'                => array( $l        => 'gestione' ),
        'parent'            => array( 'id'        => 'amministrazione.archivio.documenti.pagamenti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'amministrazione.archivio.documenti.pagamenti.form.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_amministrazione.archivio.documenti.pagamenti.form.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => array(    'amministrazione.archivio.documenti.pagamenti.form',
                                                            'amministrazione.archivio.documenti.pagamenti.form.stampe',
                                                            'amministrazione.archivio.documenti.pagamenti.form.tools' ) )
    );

    // tools archivio amministrazione
    $p['amministrazione.archivio.documenti.pagamenti.form.stampe'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-print" aria-hidden="true"></i>',
        'title'                => array( $l        => 'amministrazione archivio documenti pagamenti form stampe' ),
        'h1'                => array( $l        => 'stampe' ),
        'parent'            => array( 'id'        => 'amministrazione.archivio.documenti.pagamenti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_amministrazione.archivio.documenti.pagamenti.form.stampe.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'amministrazione.archivio.documenti.pagamenti.form' )
    );

    // tools archivio amministrazione
    $p['amministrazione.archivio.documenti.pagamenti.form.tools'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'                => array( $l        => 'azioni amministrazione archivio documenti pagamenti form' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'        => 'amministrazione.archivio.documenti.pagamenti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_amministrazione.archivio.documenti.pagamenti.form.tools.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'amministrazione.archivio.documenti.pagamenti.form' )
    );
