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
    $m = DIR_MOD . '_FI000.file/';

    // gestione anagrafica form file
    $p['anagrafica.form.file'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa-regular fa-folder-open" aria-hidden="true"></i>',
        'title'                => array( $l        => 'file' ),
        'h1'                => array( $l        => 'file' ),
        'parent'            => array( 'id'        => 'anagrafica.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'anagrafica.form.file.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_anagrafica.form.file.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'anagrafica.form' )
    );   