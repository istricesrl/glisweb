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
    $m = DIR_MOD . '_AU000.audio/';

    // gestione anagrafica form audio
    $p['anagrafica.form.audio'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-volume-up" aria-hidden="true"></i>',
        'title'                => array( $l        => 'audio' ),
        'h1'                => array( $l        => 'audio' ),
        'parent'            => array( 'id'        => 'anagrafica.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'anagrafica.form.audio.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_anagrafica.form.audio.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'anagrafica.form' )
    );
