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
    $m = DIR_MOD . '_VI000.video/';

    // RELAZIONI CON IL MODULO ANAGRAFICA
    if( in_array( "AN000.anagrafica", $cf['mods']['active']['array'] ) ) {
        arrayInsertBefore( 'anagrafica.form.archiviazione', $p['anagrafica.form']['etc']['tabs'], 'anagrafica.form.video' );
    }

    // gestione anagrafica form video
    $p['anagrafica.form.video'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-video" aria-hidden="true"></i>',
        'title'                => array( $l        => 'video' ),
        'h1'                => array( $l        => 'video' ),
        'parent'            => array( 'id'        => 'anagrafica.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'anagrafica.form.video.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_anagrafica.form.video.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'anagrafica.form' )
    );
