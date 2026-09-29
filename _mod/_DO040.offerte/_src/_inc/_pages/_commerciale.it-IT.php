<?php

    /**
     * pagine del modulo DO040.offerte
     * 
     * Questo file dichiara le pagine delle offerte nel ciclo attivo dell'area commerciale, sul modello
     * delle fatture del modulo DO010.fatture: un'offerta è un documento la cui tipologia ha se_offerta = 1.
     * 
     * pagina                                               | genitore                              | descrizione
     * -----------------------------------------------------|---------------------------------------|---------------------
     * commerciale.ciclo.attivo.offerte.view                | commerciale.ciclo.attivo              | vista offerte
     * commerciale.ciclo.attivo.offerte.articoli.view       | commerciale.ciclo.attivo.offerte.view | vista righe delle offerte
     * commerciale.ciclo.attivo.offerte.view.archiviate     | commerciale.ciclo.attivo.offerte.view | vista offerte archiviate
     * commerciale.ciclo.attivo.offerte.tools               | commerciale.ciclo.attivo.offerte.view | tools vista offerte
     * commerciale.ciclo.attivo.offerte.form                | commerciale.ciclo.attivo.offerte.view | form offerte
     * commerciale.ciclo.attivo.offerte.form.documenti.articoli | commerciale.ciclo.attivo.offerte.view | righe dell'offerta
     * commerciale.ciclo.attivo.offerte.form.archiviazione  | commerciale.ciclo.attivo.offerte.view | archiviazione dell'offerta
     * commerciale.ciclo.attivo.offerte.form.stampe         | commerciale.ciclo.attivo.offerte.view | stampe dell'offerta
     * commerciale.ciclo.attivo.offerte.form.tools          | commerciale.ciclo.attivo.offerte.view | tools form offerte
     * 
     * Le righe si aprono e si inseriscono con la scheda riga del modulo DO000.documenti
     * ( amministrazione.archivio.documenti.articoli.form ).
     * 
     */

    // lingua di questo file
    $l = 'it-IT';

    // modulo di questo file
    $m = DIR_MOD . '_DO040.offerte/';

    // vista offerte
    $p['commerciale.ciclo.attivo.offerte.view'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'commerciale offerte' ),
        'h1'                => array( $l        => 'offerte' ),
        'parent'            => array( 'id'        => 'commerciale.ciclo.attivo' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_commerciale.ciclo.attivo.offerte.view.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => array(    'commerciale.ciclo.attivo.offerte.view',
                                                            'commerciale.ciclo.attivo.offerte.articoli.view',
                                                            'commerciale.ciclo.attivo.offerte.view.archiviate',
                                                            'commerciale.ciclo.attivo.offerte.tools' ) ),
        'menu'                => array( 'admin'    => array(    '' =>     array(    'label'        => array( $l => 'offerte' ),
                                                                            'priority'    => '600' ) ) )
    );

    // vista righe delle offerte
    $p['commerciale.ciclo.attivo.offerte.articoli.view'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'offerte articoli' ),
        'h1'                => array( $l        => 'righe' ),
        'parent'            => array( 'id'        => 'commerciale.ciclo.attivo.offerte.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_commerciale.ciclo.attivo.offerte.articoli.view.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'commerciale.ciclo.attivo.offerte.view' )
    );

    // vista offerte archiviate
    $p['commerciale.ciclo.attivo.offerte.view.archiviate'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-box-archive" aria-hidden="true"></i>',
        'title'                => array( $l        => 'offerte archiviate' ),
        'h1'                => array( $l        => 'archiviate' ),
        'parent'            => array( 'id'        => 'commerciale.ciclo.attivo.offerte.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_commerciale.ciclo.attivo.offerte.view.archiviate.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'commerciale.ciclo.attivo.offerte.view' )
    );

    // tools vista offerte
    $p['commerciale.ciclo.attivo.offerte.tools'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'                => array( $l        => 'azioni commerciale offerte' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'        => 'commerciale.ciclo.attivo.offerte.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_commerciale.ciclo.attivo.offerte.tools.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'commerciale.ciclo.attivo.offerte.view' )
    );

    // form offerte
    $p['commerciale.ciclo.attivo.offerte.form'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'commerciale offerte form' ),
        'h1'                => array( $l        => 'gestione' ),
        'parent'            => array( 'id'        => 'commerciale.ciclo.attivo.offerte.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'commerciale.ciclo.attivo.offerte.form.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_commerciale.ciclo.attivo.offerte.form.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => array(    'commerciale.ciclo.attivo.offerte.form',
                                                            'commerciale.ciclo.attivo.offerte.form.documenti.articoli',
                                                            'commerciale.ciclo.attivo.offerte.form.archiviazione',
                                                            'commerciale.ciclo.attivo.offerte.form.stampe',
                                                            'commerciale.ciclo.attivo.offerte.form.tools' ) )
    );

    // righe dell'offerta
    $p['commerciale.ciclo.attivo.offerte.form.documenti.articoli'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'commerciale offerte form righe' ),
        'h1'                => array( $l        => 'righe' ),
        'parent'            => array( 'id'        => 'commerciale.ciclo.attivo.offerte.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'commerciale.ciclo.attivo.offerte.form.documenti.articoli.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_commerciale.ciclo.attivo.offerte.form.documenti.articoli.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'commerciale.ciclo.attivo.offerte.form' )
    );

    // archiviazione dell'offerta
    $p['commerciale.ciclo.attivo.offerte.form.archiviazione'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-box-archive" aria-hidden="true"></i>',
        'title'                => array( $l        => 'archiviazione commerciale offerte form' ),
        'h1'                => array( $l        => 'archiviazione' ),
        'parent'            => array( 'id'        => 'commerciale.ciclo.attivo.offerte.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'commerciale.ciclo.attivo.offerte.form.archiviazione.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_commerciale.ciclo.attivo.offerte.form.archiviazione.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'commerciale.ciclo.attivo.offerte.form' )
    );

    // stampe dell'offerta
    $p['commerciale.ciclo.attivo.offerte.form.stampe'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-print" aria-hidden="true"></i>',
        'title'                => array( $l        => 'commerciale offerte form stampe' ),
        'h1'                => array( $l        => 'stampe' ),
        'parent'            => array( 'id'        => 'commerciale.ciclo.attivo.offerte.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_commerciale.ciclo.attivo.offerte.form.stampe.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'commerciale.ciclo.attivo.offerte.form' )
    );

    // tools form offerte
    $p['commerciale.ciclo.attivo.offerte.form.tools'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'                => array( $l        => 'azioni commerciale offerte form' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'        => 'commerciale.ciclo.attivo.offerte.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_commerciale.ciclo.attivo.offerte.form.tools.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'commerciale.ciclo.attivo.offerte.form' )
    );
