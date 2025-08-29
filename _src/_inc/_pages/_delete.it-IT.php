<?php

    /**
     * definizione delle pagine generali del CMS per la lingua italiana
     *
     *
     *
     * TODO commentare
     *
     *
     */

    // lingua di questo file
    $l = 'it-IT';

    /**
     * pagine di servizio
     * ==================
     * 
     * 
     * 
     */

    // cancellazione
    $p['delete'] = array(
        'sitemap'       => false,
        'title'         => array( $l        => 'cancellazione' ),
        'h1'            => array( $l        => 'cancellazione' ),
        'parent'        => array( 'id'      => NULL ),
        'template'      => array( 'path'    => '_src/_templates/_athena/', 'schema' => 'delete.html' ),
        'macro'         => array( '_src/_inc/_macro/_delete.php' ),
        'auth'          => array( 'groups'  => array( 'roots', 'staff' ) )
    );
