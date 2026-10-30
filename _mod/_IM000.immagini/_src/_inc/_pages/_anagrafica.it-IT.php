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
    $m = DIR_MOD . '_IM000.immagini/';

    // RELAZIONI CON IL MODULO ANAGRAFICA
    // NOTA il template importa lib/anagrafica.form.sub.twig di AN000.anagrafica: senza quel modulo la linguetta va in
    // 'Unable to find template', e sulla scheda di 0010.anagrafica resta la linguetta immagini del modulo legacy
    if( in_array( "AN000.anagrafica", $cf['mods']['active']['array'] ) ) {

        // gestione anagrafica form immagini
        $p['anagrafica.form.immagini'] = array(
            'sitemap'            => false,
            'icon'                => '<i class="fa fa-image" aria-hidden="true"></i>',
            'title'                => array( $l        => 'immagini' ),
            'h1'                => array( $l        => 'immagini' ),
            'parent'            => array( 'id'        => 'anagrafica.view' ),
            'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'anagrafica.form.immagini.twig' ),
            'macro'                => array( $m . '_src/_inc/_macro/_anagrafica.form.immagini.php' ),
            'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
            'etc'                => array( 'tabs'    => 'anagrafica.form' )
        );

    }
