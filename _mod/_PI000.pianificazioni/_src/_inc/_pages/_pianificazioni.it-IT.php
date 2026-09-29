<?php

    /**
     * pagine del modulo pianificazioni
     *
     * Le pagine delle pianificazioni stanno sotto strumenti, nel menu admin, accanto a quelle dei task e dei job
     * ( _mod/_0030.strumenti/_src/_inc/_pages/_strumenti.it-IT.php ), perché sono la terza automazione del framework:
     * la vista è una sola per tutte le entità pianificabili, e il form del modello cambia secondo l'entità.
     *
     * Gli id sono gli stessi delle pagine di _0100.pianificazioni, che è della generazione precedente: una pagina
     * dichiarata da due moduli di generazione diversa non è un doppione ( vedi _etc/_claude/_claude.framework.md ).
     * Le pagine sono aperte a roots e staff, i due gruppi che hanno il privilegio GESTIONE_PIANIFICAZIONI con cui si
     * eseguono i task del modulo.
     *
     */

    // lingua di questo file
    $l = 'it-IT';

    // modulo di questo file
    $m = DIR_MOD . '_PI000.pianificazioni/';

    // vista pianificazioni
    $p['pianificazioni.view'] = array(
        'sitemap'		=> false,
        'title'			=> array( $l		=> 'pianificazioni' ),
        'h1'			=> array( $l		=> 'pianificazioni' ),
        'template'		=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
        'macro'			=> array( $m . '_src/_inc/_macro/_pianificazioni.view.php' ),
        'parent'		=> array( 'id'		=> 'strumenti' ),
        'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
        'etc'			=> array( 'tabs'	=> array(	'pianificazioni.view',
                                                        'pianificazioni.tools'
                                                     ) ),
        'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'pianificazioni' ),
                                                                        'priority'	=> '980' ) ) )
    );

    // strumenti pianificazioni
    $p['pianificazioni.tools'] = array(
        'sitemap'		=> false,
        'icon'			=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'			=> array( $l		=> 'strumenti pianificazioni' ),
        'h1'			=> array( $l		=> 'strumenti' ),
        'template'		=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'			=> array( $m . '_src/_inc/_macro/_pianificazioni.tools.php' ),
        'parent'		=> array( 'id'		=> 'pianificazioni.view' ),
        'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
        'etc'			=> array( 'tabs'	=> $p['pianificazioni.view']['etc']['tabs'] )
    );

    // gestione pianificazioni
    $p['pianificazioni.form'] = array(
        'sitemap'		=> false,
        'title'			=> array( $l		=> 'gestione' ),
        'h1'			=> array( $l		=> 'gestione' ),
        'template'		=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'pianificazioni.form.twig' ),
        'macro'			=> array( $m . '_src/_inc/_macro/_pianificazioni.form.php' ),
        'parent'		=> array( 'id'		=> 'pianificazioni.view' ),
        'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
        'etc'			=> array( 'tabs'	=> array(	'pianificazioni.form',
                                                        'pianificazioni.form.modello',
                                                        'pianificazioni.form.oggetti',
                                                        'pianificazioni.form.tools'
                                                     ) )
    );

    // gestione modello pianificazioni
    $p['pianificazioni.form.modello'] = array(
        'sitemap'		=> false,
        'icon'			=> '<i class="fa fa-clone" aria-hidden="true"></i>',
        'title'			=> array( $l		=> 'modello' ),
        'h1'			=> array( $l		=> 'modello' ),
        'template'		=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'pianificazioni.form.modello.twig' ),
        'macro'			=> array( $m . '_src/_inc/_macro/_pianificazioni.form.modello.php' ),
        'parent'		=> array( 'id'		=> 'pianificazioni.view' ),
        'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
        'etc'			=> array( 'tabs'	=> $p['pianificazioni.form']['etc']['tabs'] )
    );

    // gestione oggetti creati dalle pianificazioni
    $p['pianificazioni.form.oggetti'] = array(
        'sitemap'		=> false,
        'title'			=> array( $l		=> 'oggetti creati' ),
        'h1'			=> array( $l		=> 'oggetti creati' ),
        'template'		=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'pianificazioni.form.oggetti.twig' ),
        'macro'			=> array( $m . '_src/_inc/_macro/_pianificazioni.form.oggetti.php' ),
        'parent'		=> array( 'id'		=> 'pianificazioni.view' ),
        'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
        'etc'			=> array( 'tabs'	=> $p['pianificazioni.form']['etc']['tabs'] )
    );

    // gestione strumenti pianificazioni
    $p['pianificazioni.form.tools'] = array(
        'sitemap'		=> false,
        'icon'			=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'			=> array( $l		=> 'strumenti pianificazione' ),
        'h1'			=> array( $l		=> 'strumenti' ),
        'template'		=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'			=> array( $m . '_src/_inc/_macro/_pianificazioni.form.tools.php' ),
        'parent'		=> array( 'id'		=> 'pianificazioni.view' ),
        'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
        'etc'			=> array( 'tabs'	=> $p['pianificazioni.form']['etc']['tabs'] )
    );
