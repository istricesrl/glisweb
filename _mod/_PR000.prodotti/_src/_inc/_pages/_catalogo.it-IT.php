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
    $m = DIR_MOD . '_PR000.prodotti/';

    // tools archivio produzione
    $p['catalogo.prodotti.view'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'catalogo prodotti' ),
        'h1'                => array( $l        => 'prodotti' ),
        'parent'            => array( 'id'        => 'catalogo' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.prodotti.view.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => array(    'catalogo.prodotti.view',
                                                            'catalogo.articoli.view',
                                                            'catalogo.prodotti.view.archiviati',
                                                            'catalogo.prodotti.tools' ) ),
        'menu'                => array( 'admin'    => array(    '' =>     array(    'label'        => array( $l => 'prodotti' ),
                                                                            'priority'    => '100' ) ) )
    );

    // tools archivio produzione
    $p['catalogo.prodotti.view.archiviati'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-box-archive" aria-hidden="true"></i>',
        'title'                => array( $l        => 'prodotti archiviati' ),
        'h1'                => array( $l        => 'archiviati' ),
        'parent'            => array( 'id'        => 'catalogo.prodotti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.prodotti.view.archiviati.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'catalogo.prodotti.view' )
    );

    // tools archivio produzione
    $p['catalogo.prodotti.tools'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'                => array( $l        => 'azioni catalogo prodotti' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'        => 'catalogo.prodotti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.prodotti.tools.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'catalogo.prodotti.view' )
    );

    // tools archivio produzione
    $p['catalogo.prodotti.form'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'catalogo prodotti form' ),
        'h1'                => array( $l        => 'gestione' ),
        'parent'            => array( 'id'        => 'catalogo.prodotti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'catalogo.prodotti.form.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.prodotti.form.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => array(    'catalogo.prodotti.form',
                                                            'catalogo.prodotti.form.caratteristiche',
                                                            'catalogo.prodotti.form.articoli',
                                                            'catalogo.prodotti.form.relazioni',
                                                            'catalogo.prodotti.form.archiviazione',
                                                            'catalogo.prodotti.form.tools' ) )
    );

    // RELAZIONI CON IL MODULO CONTENUTI
    if( in_array( "CO000.contenuti", $cf['mods']['active']['array'] ) ) {
        arrayInsertBefore( 'catalogo.prodotti.form.relazioni', $p['catalogo.prodotti.form']['etc']['tabs'], 'catalogo.prodotti.form.web' );
        arrayInsertBefore( 'catalogo.prodotti.form.relazioni', $p['catalogo.prodotti.form']['etc']['tabs'], 'catalogo.prodotti.form.sem' );
        arrayInsertBefore( 'catalogo.prodotti.form.relazioni', $p['catalogo.prodotti.form']['etc']['tabs'], 'catalogo.prodotti.form.contenuti' );
    }

    // RELAZIONI CON IL MODULO IMMAGINI
    if( in_array( "IM000.immagini", $cf['mods']['active']['array'] ) ) {
        arrayInsertBefore( 'catalogo.prodotti.form.relazioni', $p['catalogo.prodotti.form']['etc']['tabs'], 'catalogo.prodotti.form.immagini' );
    }

    // RELAZIONI CON IL MODULO VIDEO
    if( in_array( "VI000.video", $cf['mods']['active']['array'] ) ) {
        arrayInsertBefore( 'catalogo.prodotti.form.relazioni', $p['catalogo.prodotti.form']['etc']['tabs'], 'catalogo.prodotti.form.video' );
    }

    // tools archivio produzione
    $p['catalogo.prodotti.form.categorie'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'catalogo prodotti form categorie' ),
        'h1'                => array( $l        => 'categorie' ),
        'parent'            => array( 'id'        => 'catalogo.prodotti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'catalogo.prodotti.form.categorie.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.prodotti.form.categorie.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'catalogo.prodotti.form' )
    );

    // tools archivio produzione
    $p['catalogo.prodotti.form.caratteristiche'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'catalogo prodotti form caratteristiche' ),
        'h1'                => array( $l        => 'caratteristiche' ),
        'parent'            => array( 'id'        => 'catalogo.prodotti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'catalogo.prodotti.form.caratteristiche.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.prodotti.form.caratteristiche.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'catalogo.prodotti.form' )
    );

    // tools archivio produzione
    $p['catalogo.prodotti.form.relazioni'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-solid fa-diagram-project" aria-hidden="true"></i>',
        'title'                => array( $l        => 'catalogo prodotti form relazioni' ),
        'h1'                => array( $l        => 'relazioni' ),
        'parent'            => array( 'id'        => 'catalogo.prodotti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'catalogo.prodotti.form.relazioni.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.prodotti.form.relazioni.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'catalogo.prodotti.form' )
    );

    // tools archivio produzione
    $p['catalogo.prodotti.form.articoli'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'catalogo prodotti form articoli' ),
        'h1'                => array( $l        => 'articoli' ),
        'parent'            => array( 'id'        => 'catalogo.prodotti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'catalogo.prodotti.form.articoli.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.prodotti.form.articoli.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'catalogo.prodotti.form' )
    );

    // tools archivio produzione
    $p['catalogo.prodotti.form.archiviazione'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-box-archive" aria-hidden="true"></i>',
        'title'                => array( $l        => 'archiviazione catalogo prodotti form' ),
        'h1'                => array( $l        => 'archiviazione' ),
        'parent'            => array( 'id'        => 'catalogo.prodotti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'catalogo.prodotti.form.archiviazione.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.prodotti.form.archiviazione.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'catalogo.prodotti.form' )
    );

    // tools archivio produzione
    $p['catalogo.prodotti.form.tools'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'                => array( $l        => 'azioni catalogo prodotti form' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'        => 'catalogo.prodotti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.prodotti.form.tools.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'catalogo.prodotti.form' )
    );

    // tools archivio produzione
    $p['catalogo.categorie.prodotti.view'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'catalogo categorie prodotti' ),
        'h1'                => array( $l        => 'categorie' ),
        'parent'            => array( 'id'        => 'catalogo.prodotti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.categorie.prodotti.view.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => array(    'catalogo.categorie.prodotti.view',
                                                            'catalogo.categorie.prodotti.view.archiviati',
                                                            'catalogo.categorie.prodotti.tools' ) ),
        'menu'                => array( 'admin'    => array(    '' =>     array(    'label'        => array( $l => 'categorie' ),
                                                                            'priority'    => '200' ) ) )
    );

    // tools archivio produzione
    $p['catalogo.categorie.prodotti.view.archiviati'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-box-archive" aria-hidden="true"></i>',
        'title'                => array( $l        => 'categorie prodotti archiviati' ),
        'h1'                => array( $l        => 'archiviati' ),
        'parent'            => array( 'id'        => 'catalogo.categorie.prodotti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.categorie.prodotti.view.archiviati.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'catalogo.categorie.prodotti.view' )
    );

    // tools archivio produzione
    $p['catalogo.categorie.prodotti.tools'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'                => array( $l        => 'azioni catalogo categorie prodotti' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'        => 'catalogo.categorie.prodotti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.categorie.prodotti.tools.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'catalogo.categorie.prodotti.view' )
    );

    // tools archivio produzione
    $p['catalogo.categorie.prodotti.form'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'catalogo categorie prodotti form' ),
        'h1'                => array( $l        => 'gestione' ),
        'parent'            => array( 'id'        => 'catalogo.categorie.prodotti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'catalogo.categorie.prodotti.form.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.categorie.prodotti.form.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => array(    'catalogo.categorie.prodotti.form',
                                                            'catalogo.categorie.prodotti.form.prodotti',
                                                            'catalogo.categorie.prodotti.form.archiviazione',
                                                            'catalogo.categorie.prodotti.form.tools' ) )
    );

    // RELAZIONI CON IL MODULO catalogo
    if( in_array( "CO000.contenuti", $cf['mods']['active']['array'] ) ) {
        arrayInsertBefore( 'catalogo.categorie.prodotti.form.archiviazione', $p['catalogo.categorie.prodotti.form']['etc']['tabs'], 'catalogo.categorie.prodotti.form.web' );
        arrayInsertBefore( 'catalogo.categorie.prodotti.form.archiviazione', $p['catalogo.categorie.prodotti.form']['etc']['tabs'], 'catalogo.categorie.prodotti.form.sem' );
        arrayInsertBefore( 'catalogo.categorie.prodotti.form.archiviazione', $p['catalogo.categorie.prodotti.form']['etc']['tabs'], 'catalogo.categorie.prodotti.form.contenuti' );
        arrayInsertBefore( 'catalogo.categorie.prodotti.form.archiviazione', $p['catalogo.categorie.prodotti.form']['etc']['tabs'], 'catalogo.categorie.prodotti.form.menu' );
    }

    // RELAZIONI CON IL MODULO IMMAGINI
    if( in_array( "IM000.immagini", $cf['mods']['active']['array'] ) ) {
        arrayInsertBefore( 'catalogo.categorie.prodotti.form.archiviazione', $p['catalogo.categorie.prodotti.form']['etc']['tabs'], 'catalogo.categorie.prodotti.form.immagini' );
    }

    // RELAZIONI CON IL MODULO VIDEO
    if( in_array( "VI000.video", $cf['mods']['active']['array'] ) ) {
        arrayInsertBefore( 'catalogo.categorie.prodotti.form.archiviazione', $p['catalogo.categorie.prodotti.form']['etc']['tabs'], 'catalogo.categorie.prodotti.form.video' );
    }

    // tools archivio produzione
    $p['catalogo.categorie.prodotti.form.prodotti'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'catalogo categorie prodotti form prodotti' ),
        'h1'                => array( $l        => 'prodotti' ),
        'parent'            => array( 'id'        => 'catalogo.categorie.prodotti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'catalogo.categorie.prodotti.form.prodotti.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.categorie.prodotti.form.prodotti.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'catalogo.categorie.prodotti.form' )
    );

    // tools archivio produzione
    $p['catalogo.categorie.prodotti.form.archiviazione'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-box-archive" aria-hidden="true"></i>',
        'title'                => array( $l        => 'archiviazione catalogo categorie prodotti form' ),
        'h1'                => array( $l        => 'archiviazione' ),
        'parent'            => array( 'id'        => 'catalogo.categorie.prodotti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'catalogo.categorie.prodotti.form.archiviazione.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.categorie.prodotti.form.archiviazione.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'catalogo.categorie.prodotti.form' )
    );

    // tools archivio produzione
    $p['catalogo.categorie.prodotti.form.tools'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'                => array( $l        => 'azioni catalogo categorie prodotti form' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'        => 'catalogo.categorie.prodotti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.categorie.prodotti.form.tools.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'catalogo.categorie.prodotti.form' )
    );

    // tools archivio produzione
    $p['catalogo.articoli.view'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'catalogo articoli' ),
        'h1'                => array( $l        => 'articoli' ),
        'parent'            => array( 'id'        => 'catalogo.prodotti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.articoli.view.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'catalogo.prodotti.view' )
    );

    // tools archivio produzione
    $p['catalogo.articoli.form'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'catalogo articoli form' ),
        'h1'                => array( $l        => 'gestione' ),
        'parent'            => array( 'id'        => 'catalogo.articoli.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'catalogo.articoli.form.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.articoli.form.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => array(    'catalogo.articoli.form',
                                                            'catalogo.articoli.form.caratteristiche',
                                                            'catalogo.articoli.form.distinta',
                                                            'catalogo.articoli.form.relazioni',
                                                            'catalogo.articoli.form.archiviazione',
                                                            'catalogo.articoli.form.tools' ) )
    );

    // RELAZIONI CON IL MODULO IMMAGINI
    if( in_array( "IM000.immagini", $cf['mods']['active']['array'] ) ) {
        arrayInsertBefore( 'catalogo.articoli.form.relazioni', $p['catalogo.articoli.form']['etc']['tabs'], 'catalogo.articoli.form.immagini' );
    }

    // RELAZIONI CON IL MODULO VIDEO
    if( in_array( "VI000.video", $cf['mods']['active']['array'] ) ) {
        arrayInsertBefore( 'catalogo.articoli.form.relazioni', $p['catalogo.articoli.form']['etc']['tabs'], 'catalogo.articoli.form.video' );
    }

    // tools archivio produzione
    $p['catalogo.articoli.form.caratteristiche'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'catalogo articoli form caratteristiche' ),
        'h1'                => array( $l        => 'caratteristiche' ),
        'parent'            => array( 'id'        => 'catalogo.articoli.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'catalogo.articoli.form.caratteristiche.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.articoli.form.caratteristiche.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'catalogo.articoli.form' )
    );

    // tools archivio produzione
    $p['catalogo.articoli.form.relazioni'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-solid fa-diagram-project" aria-hidden="true"></i>',
        'title'                => array( $l        => 'catalogo articoli form relazioni' ),
        'h1'                => array( $l        => 'relazioni' ),
        'parent'            => array( 'id'        => 'catalogo.articoli.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'catalogo.articoli.form.relazioni.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.articoli.form.relazioni.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'catalogo.articoli.form' )
    );

    // tools archivio produzione
    $p['catalogo.articoli.form.distinta'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'catalogo articoli form distinta' ),
        'h1'                => array( $l        => 'distinta' ),
        'parent'            => array( 'id'        => 'catalogo.articoli.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'catalogo.articoli.form.distinta.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.articoli.form.distinta.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'catalogo.articoli.form' )
    );

    // tools archivio produzione
    $p['catalogo.articoli.form.archiviazione'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-box-archive" aria-hidden="true"></i>',
        'title'                => array( $l        => 'archiviazione catalogo articoli form' ),
        'h1'                => array( $l        => 'archiviazione' ),
        'parent'            => array( 'id'        => 'catalogo.articoli.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'catalogo.articoli.form.archiviazione.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.articoli.form.archiviazione.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'catalogo.articoli.form' )
    );

    // tools archivio produzione
    $p['catalogo.articoli.form.tools'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'                => array( $l        => 'azioni catalogo articoli form' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'        => 'catalogo.articoli.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.articoli.form.tools.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'catalogo.articoli.form' )
    );


    // tools archivio produzione
    $p['catalogo.marchi.view'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'catalogo marchi' ),
        'h1'                => array( $l        => 'marchi' ),
        'parent'            => array( 'id'        => 'catalogo' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.marchi.view.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => array(    'catalogo.marchi.view',
                                                            'catalogo.marchi.view.archiviati',
                                                            'catalogo.marchi.tools' ) ),
        'menu'                => array( 'admin'    => array(    '' =>     array(    'label'        => array( $l => 'marchi' ),
                                                                            'priority'    => '200' ) ) )
    );

    // tools archivio produzione
    $p['catalogo.marchi.view.archiviati'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-box-archive" aria-hidden="true"></i>',
        'title'                => array( $l        => 'marchi archiviati' ),
        'h1'                => array( $l        => 'archiviati' ),
        'parent'            => array( 'id'        => 'catalogo.marchi.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.marchi.view.archiviati.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'catalogo.marchi.view' )
    );

    // tools archivio produzione
    $p['catalogo.marchi.tools'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'                => array( $l        => 'azioni catalogo marchi' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'        => 'catalogo.marchi.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.marchi.tools.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'catalogo.marchi.view' )
    );

    // tools archivio produzione
    $p['catalogo.marchi.form'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'catalogo marchi form' ),
        'h1'                => array( $l        => 'gestione' ),
        'parent'            => array( 'id'        => 'catalogo.marchi.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'catalogo.marchi.form.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.marchi.form.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => array(    'catalogo.marchi.form',
                                                              'catalogo.marchi.form.archiviazione',
                                                              'catalogo.marchi.form.tools' ) )
    );

    // tools archivio produzione
    $p['catalogo.marchi.form.tools'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'                => array( $l        => 'azioni catalogo marchi form' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'        => 'catalogo.marchi.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.marchi.form.tools.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'catalogo.marchi.form' )
    );

// tools archivio produzione
    $p['catalogo.marchi.form.archiviazione'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-box-archive" aria-hidden="true"></i>',
        'title'                => array( $l        => 'archiviazione catalogo marchi form' ),
        'h1'                => array( $l        => 'archiviazione' ),
        'parent'            => array( 'id'        => 'catalogo.marchi.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'catalogo.marchi.form.archiviazione.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.marchi.form.archiviazione.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'catalogo.marchi.form' )
    );
