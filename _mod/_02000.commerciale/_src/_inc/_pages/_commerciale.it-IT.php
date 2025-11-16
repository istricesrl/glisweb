<?php

    /**
     * pagine del modulo 02000.commerciale
     * 
     * questo file contiene la definizione delle pagine del modulo 'commerciale'
     * 
     * introduzione
     * ============
     * Il modulo commerciale è un modulo contenitore, che fornisce una dashboard e un archivio con le
     * rispettive pagine tools, oltre a una sotto pagina per il ciclo attivo e una per il ciclo passivo,
     * in modo che altri moduli possano inserirvi le proprie sotto pagine.
     * 
     * pagina                            | genitore                    | descrizione
     * ---------------------------------|---------------------------|---------------------
     * commerciale                        | NULL                        | dashboard del modulo commerciale
     * commerciale.tools                | commerciale                | strumenti per la gestione del commerciale
     * commerciale.archivio                | commerciale                | archivio commerciale
     * commerciale.archivio.tools        | commerciale.archivio        | strumenti per la gestione dell'archivio commerciale
     * commerciale.ciclo.attivo            | commerciale                | ciclo attivo commerciale
     * commerciale.ciclo.attivo.tools    | commerciale.ciclo.attivo    | strumenti per la gestione del ciclo attivo commerciale
     * commerciale.ciclo.passivo        | commerciale                | ciclo passivo commerciale
     * commerciale.ciclo.passivo.tools    | commerciale.ciclo.passivo    | strumenti per la gestione del ciclo passivo commerciale
     * 
     */

    // lingua di questo file
    $l = 'it-IT';

    // modulo di questo file
    $m = DIR_MOD . '_02000.commerciale/';

    // dashboard commerciale
    $p['commerciale'] = array(
        'sitemap'        => false,
        'title'            => array( $l        => 'commerciale' ),
        'h1'            => array( $l        => 'commerciale' ),
        'parent'        => array( 'id'        => NULL ),
        'template'        => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'commerciale.twig' ),
        'macro'            => array( $m . '_src/_inc/_macro/_commerciale.php' ),
        'auth'            => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'            => array( 'tabs'    => array(    'commerciale',
                                                        'commerciale.tools'
                                                         ) ),
        'menu'                => array( 'admin'    => array(    '' =>     array(    'label'        => array( $l => 'commerciale' ),
                                                                        'priority'    => '2000' ) ) )                                                        
    );

    // tools commerciale
    $p['commerciale.tools'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'                => array( $l        => 'azioni' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'        => 'commerciale' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_commerciale.tools.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'commerciale' )
    );

    // dashboard commerciale
    $p['commerciale.archivio'] = array(
        'sitemap'        => false,
        'title'            => array( $l        => 'archivio commerciale' ),
        'h1'            => array( $l        => 'archivio' ),
        'parent'        => array( 'id'        => 'commerciale' ),
        'template'        => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'commerciale.archivio.twig' ),
        'macro'            => array( $m . '_src/_inc/_macro/_commerciale.archivio.php' ),
        'auth'            => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'            => array( 'tabs'    => array(    'commerciale.archivio',
                                                        'commerciale.archivio.tools'
                                                         ) ),
        'menu'                => array( 'admin'    => array(    '' =>     array(    'label'        => array( $l => 'archivio' ),
                                                                        'priority'    => '9900' ) ) )                                                        
    );

    // tools archivio commerciale
    $p['commerciale.archivio.tools'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'                => array( $l        => 'azioni' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'        => 'commerciale.archivio' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_commerciale.archivio.tools.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'commerciale.archivio' )
    );

    // dashboard commerciale
    $p['commerciale.ciclo.attivo'] = array(
        'sitemap'        => false,
        'title'            => array( $l        => 'commerciale ciclo attivo' ),
        'h1'            => array( $l        => 'ciclo attivo' ),
        'parent'        => array( 'id'        => 'commerciale' ),
        'template'        => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'commerciale.ciclo.attivo.twig' ),
        'macro'            => array( $m . '_src/_inc/_macro/_commerciale.ciclo.attivo.php' ),
        'auth'            => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'            => array( 'tabs'    => array(    'commerciale.ciclo.attivo',
                                                        'commerciale.ciclo.attivo.tools'
                                                         ) ),
        'menu'                => array( 'admin'    => array(    '' =>     array(    'label'        => array( $l => 'ciclo attivo' ),
                                                                        'priority'    => '1100' ) ) )                                                        
    );

    // tools archivio commerciale
    $p['commerciale.ciclo.attivo.tools'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'                => array( $l        => 'azioni commerciale ciclo attivo' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'        => 'commerciale.ciclo.attivo' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_commerciale.ciclo.attivo.tools.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'commerciale.ciclo.attivo' )
    );

    // dashboard commerciale
    $p['commerciale.ciclo.passivo'] = array(
        'sitemap'        => false,
        'title'            => array( $l        => 'commerciale ciclo passivo' ),
        'h1'            => array( $l        => 'ciclo passivo' ),
        'parent'        => array( 'id'        => 'commerciale' ),
        'template'        => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'commerciale.ciclo.passivo.twig' ),
        'macro'            => array( $m . '_src/_inc/_macro/_commerciale.ciclo.passivo.php' ),
        'auth'            => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'            => array( 'tabs'    => array(    'commerciale.ciclo.passivo',
                                                        'commerciale.ciclo.passivo.tools'
                                                         ) ),
        'menu'                => array( 'admin'    => array(    '' =>     array(    'label'        => array( $l => 'ciclo passivo' ),
                                                                        'priority'    => '2100' ) ) )                                                        
    );

    // tools archivio commerciale
    $p['commerciale.ciclo.passivo.tools'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'                => array( $l        => 'azioni commerciale ciclo passivo' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'        => 'commerciale.ciclo.passivo' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_commerciale.ciclo.passivo.tools.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'commerciale.ciclo.passivo' )
    );
