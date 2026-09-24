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
    $m = DIR_MOD . '_CO000.contenuti/';

    // gestione anagrafica metadati
    $p['anagrafica.form.metadati'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-solid fa-tags" aria-hidden="true"></i>',
        'title'                => array( $l        => 'metadati' ),
        'h1'                => array( $l        => 'metadati' ),
        'parent'            => array( 'id'        => 'anagrafica.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'anagrafica.form.metadati.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_anagrafica.form.metadati.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'anagrafica.form' )
    );
