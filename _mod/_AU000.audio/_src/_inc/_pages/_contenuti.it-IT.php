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
    $m = DIR_MOD . '_AU000.audio/';

    // RELAZIONI CON IL MODULO contenuti
    if( in_array( "03000.contenuti", $cf['mods']['active']['array'] ) ) {
        arrayInsertSeq( 'contenuti.archivio', $p['contenuti.archivio']['etc']['tabs'], 'contenuti.archivio.audio.view' );
    }

    // tools archivio contenuti
    $p['contenuti.archivio.audio.view'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'contenuti audio' ),
        'h1'                => array( $l        => 'audio' ),
        'parent'            => array( 'id'        => 'contenuti.archivio' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.archivio.audio.view.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.archivio' )
    );

    // tools archivio contenuti
    $p['contenuti.archivio.audio.tools'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'                => array( $l        => 'azioni contenuti audio' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'        => 'contenuti.archivio.audio.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.archivio.audio.tools.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.archivio.audio.view' )
    );

    // tools archivio contenuti
    $p['contenuti.archivio.audio.form'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'contenuti audio form' ),
        'h1'                => array( $l        => 'gestione' ),
        'parent'            => array( 'id'        => 'contenuti.archivio.audio.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'contenuti.archivio.audio.form.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.archivio.audio.form.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => array(    'contenuti.archivio.audio.form',
                                                            'contenuti.archivio.audio.form.collegamenti',
                                                            'contenuti.archivio.audio.form.tools' ) )
    );

    // niente relazione con il modulo immagini, a differenza di _VI000.video: la tabella immagini ha id_video
    // ma non id_audio, e la scheda contenuti.archivio.audio.form.immagini non esiste ( 2026-09-25 )

    // tools archivio contenuti
    $p['contenuti.archivio.audio.form.tools'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'                => array( $l        => 'azioni contenuti audio form' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'        => 'contenuti.archivio.audio.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.archivio.audio.form.tools.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.archivio.audio.form' )
    );

    // archivio audio form collegamenti
    $p['contenuti.archivio.audio.form.collegamenti'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'contenuti audio form collegamenti' ),
        'h1'                => array( $l        => 'collegamenti' ),
        'parent'            => array( 'id'        => 'contenuti.archivio.audio.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'contenuti.archivio.audio.form.collegamenti.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.archivio.audio.form.collegamenti.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.archivio.audio.form' )
    );

    // gestione pagine form audio
    $p['contenuti.pagine.form.audio'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-volume-up" aria-hidden="true"></i>',
        'title'                => array( $l        => 'audio' ),
        'h1'                => array( $l        => 'audio' ),
        'parent'            => array( 'id'        => 'contenuti.pagine.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'contenuti.pagine.form.audio.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.pagine.form.audio.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.pagine.form' )
    );

    // gestione pagine form audio
    $p['contenuti.notizie.form.audio'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-volume-up" aria-hidden="true"></i>',
        'title'                => array( $l        => 'audio' ),
        'h1'                => array( $l        => 'audio' ),
        'parent'            => array( 'id'        => 'contenuti.notizie.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'contenuti.notizie.form.audio.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.notizie.form.audio.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.notizie.form' )
    );

    // gestione pagine form audio
    $p['contenuti.categorie.notizie.form.audio'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-volume-up" aria-hidden="true"></i>',
        'title'                => array( $l        => 'audio' ),
        'h1'                => array( $l        => 'audio' ),
        'parent'            => array( 'id'        => 'contenuti.categorie.notizie.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'contenuti.categorie.notizie.form.audio.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.categorie.notizie.form.audio.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.categorie.notizie.form' )
    );
