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

    // gestione pagine form file
    $p['catalogo.marchi.form.file'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa-regular fa-folder-open" aria-hidden="true"></i>',
        'title'                => array( $l        => 'file' ),
        'h1'                => array( $l        => 'file' ),
        'parent'            => array( 'id'        => 'catalogo.marchi.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'catalogo.marchi.form.file.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_catalogo.marchi.form.file.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'catalogo.marchi.form' )
    );