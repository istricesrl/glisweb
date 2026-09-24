<?php

    /**
     * pagine del modulo 03000.contenuti
     * 
     * Questo file contiene la definizione delle pagine del modulo "contenuti".
     * 
     * introduzione
     * ============
     * Il modulo contenuti è un modulo contenitore, che fornisce una dashboard e un archivio con le
     * rispettive pagine tools, in modo che altri moduli possano inserirvi le proprie sotto pagine.
     * 
     * pagina                           | genitore                  | descrizione
     * ---------------------------------|---------------------------|---------------------
     * contenuti                        | NULL                      | dashboard contenuti
     * contenuti.tools                  | contenuti                 | tools contenuti
     * contenuti.archivio               | contenuti                 | archivio contenuti
     * contenuti.archivio.tools         | contenuti.archivio        | tools archivio contenuti
     * 
     * Il modulo contiene inoltre le pagine di gestione dei template, che forniscono un'interfaccia 
     * per la creazione e la gestione dei template.
     * 
     * pagina                           | genitore                  | descrizione
     * ---------------------------------|---------------------------|---------------------
     * contenuti.template.view          | contenuti                 | visualizzazione template contenuti
     * contenuti.template.tools         | contenuti.template.view   | tools della vista template contenuti
     * contenuti.template.form          | contenuti.template.view   | form di gestione template contenuti
     * contenuti.template.form.editor   | contenuti.template.view   | editor del form di gestione template
     * contenuti.template.form.tools    | contenuti.template.view   | tools del form di gestione template
     * 
     */

    // lingua di questo file
    $l = 'it-IT';

    // modulo di questo file
    $m = DIR_MOD . '_03000.contenuti/';

    // dashboard contenuti
    $p['contenuti'] = array(
        'sitemap'        => false,
        'title'            => array( $l        => 'contenuti' ),
        'h1'            => array( $l        => 'contenuti' ),
        'parent'        => array( 'id'        => NULL ),
        'template'        => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'contenuti.twig' ),
        'macro'            => array( $m . '_src/_inc/_macro/_contenuti.php' ),
        'auth'            => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'            => array( 'tabs'    => array(    'contenuti',
                                                        'contenuti.tools'
                                                         ) ),
        'menu'                => array( 'admin'    => array(    '' =>     array(    'label'        => array( $l => 'contenuti' ),
                                                                        'priority'    => '9000' ) ) )                                                        
    );

    // tools della dashboard contenuti
    $p['contenuti.tools'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'                => array( $l        => 'azioni' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'        => 'contenuti' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.tools.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti' )
    );

    // archivio contenuti
    $p['contenuti.archivio'] = array(
        'sitemap'        => false,
        'title'            => array( $l        => 'archivio contenuti' ),
        'h1'            => array( $l        => 'archivio' ),
        'parent'        => array( 'id'        => 'contenuti' ),
        'template'        => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'contenuti.archivio.twig' ),
        'macro'            => array( $m . '_src/_inc/_macro/_contenuti.archivio.php' ),
        'auth'            => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'            => array( 'tabs'    => array(    'contenuti.archivio',
                                                        'contenuti.archivio.tools'
                                                         ) ),
        'menu'                => array( 'admin'    => array(    '' =>     array(    'label'        => array( $l => 'archivio' ),
                                                                        'priority'    => '9900' ) ) )                                                        
    );

    // tools archivio contenuti
    $p['contenuti.archivio.tools'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'                => array( $l        => 'azioni' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'        => 'contenuti.archivio' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.archivio.tools.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.archivio' )
    );

    // vista template contenuti
    $p['contenuti.template.view'] = array(
        'sitemap'        => false,
        'title'            => array( $l        => 'template contenuti' ),
        'h1'            => array( $l        => 'template' ),
        'parent'        => array( 'id'        => 'contenuti' ),
        'template'        => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
        'macro'            => array( $m . '_src/_inc/_macro/_contenuti.template.view.php' ),
        'auth'            => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'            => array( 'tabs'    => array(    'contenuti.template.view',
                                                        'contenuti.template.tools'
                                                         ) ),
        'menu'                => array( 'admin'    => array(    '' =>     array(    'label'        => array( $l => 'template' ),
                                                                        'priority'    => '9000' ) ) )                                                        
    );

    // tools della vista template contenuti
    $p['contenuti.template.tools'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'                => array( $l        => 'azioni' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'        => 'contenuti.template.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.template.tools.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.template.view' )
    );

    // form di gestione template
    $p['contenuti.template.form'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'gestione template' ),
        'h1'                => array( $l        => 'gestione' ),
        'parent'            => array( 'id'        => 'contenuti.template.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'contenuti.template.form.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.template.form.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => array( 'contenuti.template.form',
                                                            'contenuti.template.form.editor',
                                                            'contenuti.template.form.tools'
                                                        ) )
    );

    // editor della gestione template
    $p['contenuti.template.form.editor'] = array(
        'sitemap'            => false,
        'title'                => array( $l        => 'editor template' ),
        'h1'                => array( $l        => 'editor' ),
        'parent'            => array( 'id'        => 'contenuti.template.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'contenuti.template.form.editor.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.template.form.editor.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.template.form' )
    );

    // tools della gestione template
    $p['contenuti.template.form.tools'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'                => array( $l        => 'azioni template' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'        => 'contenuti.template.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_contenuti.template.form.tools.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'contenuti.template.form' )
    );
