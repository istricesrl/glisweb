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
    $m = DIR_MOD . '_AT000.attivita/';

    // RELAZIONI CON IL MODULO ANAGRAFICA
    if( in_array( "AN000.anagrafica", $cf['mods']['active']['array'] ) ) {
        arrayInsertSeq( 'anagrafica.form', $p['anagrafica.form']['etc']['tabs'], 'anagrafica.form.attivita' );
        arrayInsertSeq( 'anagrafica.form', $p['anagrafica.form']['etc']['tabs'], 'anagrafica.form.lavoro' );
    }

    // gestione anagrafica form tools
    $p['anagrafica.form.lavoro'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-screwdriver-wrench" aria-hidden="true"></i>',
        'title'                => array( $l        => 'lavoro form anagrafica' ),
        'h1'                => array( $l        => 'lavoro' ),
        'parent'            => array( 'id'        => 'anagrafica.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'anagrafica.form.lavoro.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_anagrafica.form.lavoro.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'anagrafica.form' )
    );

    // gestione anagrafica form tools
    $p['anagrafica.form.attivita'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-pen-to-square" aria-hidden="true"></i>',
        'title'                => array( $l        => 'attivita form anagrafica' ),
        'h1'                => array( $l        => 'attivita' ),
        'parent'            => array( 'id'        => 'anagrafica.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'anagrafica.form.attivita.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_anagrafica.form.attivita.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'anagrafica.form' )
    );
