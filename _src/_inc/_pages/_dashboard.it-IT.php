<?php

    /**
     * definizione delle pagine generali del CMS per la lingua italiana
     *
     *
     *
     * TODO documentare
     *
     *
     */

    // lingua di questo file
    $l = 'it-IT';

    /**
     * dashboard e pagine collegate
     * ============================
     * 
     * 
     */

    // pagina principale
    $p['dashboard'] = array(
        'sitemap'       => false,
        'title'         => array( $l        => 'admin' ),
        'h1'            => array( $l        => 'dashboard' ),
        'template'      => array( 'path'    => '_src/_templates/_athena/', 'schema' => 'dashboard.html' ),
        'parent'        => array( 'id'      => NULL ),
        'macro'         => array( '_src/_inc/_macro/_dashboard.php' ),
        'auth'          => array( 'groups'  => array( 'roots', 'staff' ) ),
        'etc'           => array( 'tabs'    => array( 'dashboard', 'dashboard.tools' ) ),
        'menu'          => array( 'admin'   => array( '' => array( 'label' => array( $l => 'dashboard' ), 'priority' => '000' ) ) )
    );

    // tools dashboard
    $p['dashboard.tools'] = array(
        'sitemap'       => false,
        'icon'          => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'         => array( $l        => 'azioni' ),
        'h1'            => array( $l        => 'azioni' ),
        'parent'        => array( 'id'      => 'dashboard' ),
        'template'      => array( 'path'    => '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
        'macro'         => array( '_src/_inc/_macro/_dashboard.tools.php' ),
        'auth'          => array( 'groups'  => array( 'roots', 'staff' ) ),
        'etc'           => array( 'tabs'    => $p['dashboard']['etc']['tabs'] )
    );
