<?php

    /**
     * definizione delle pagine per la gestione della newsletter
     *
     * Le pagine sono quelle di `_mod/_7000.mailing`, portate al canone dei moduli nuovi: template in
     * `_src/_tpl/_athena/`, schede relazionali dichiarate dai moduli a cui appartengono ( il testo in
     * `_CO000.contenuti`, gli allegati in `_FI000.file` ) e aggiunte qui solo se quei moduli sono attivi.
     *
     * Rispetto al modulo vecchio mancano la dashboard `mailing`, che non conteneva niente, le pagine
     * `template.mailing.*`, che duplicavano i template mail di `_TE000.template`, e le schede metadati, che
     * puntavano a pagine mai dichiarate.
     *
     */

    // lingua di questo file
    $l = 'it-IT';

    // modulo di questo file
    $m = DIR_MOD . '_ML000.mailing/';

    // vista mailing
    $p['mailing.view'] = array(
        'sitemap'           => false,
        'title'             => array( $l        => 'mailing' ),
        'h1'                => array( $l        => 'mailing' ),
        'tab'               => array( $l        => 'invii' ),
        'parent'            => array( 'id'      => NULL ),
        'template'          => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
        'macro'             => array( $m . '_src/_inc/_macro/_mailing.view.php' ),
        'auth'              => array( 'groups'  => array(   'roots', 'staff' ) ),
        'etc'               => array( 'tabs'    => array(   'mailing.view',
                                                            'liste.view',
                                                            'mailing.tools' ) ),
        'menu'              => array( 'admin'   => array(   '' =>   array(  'label'     => array( $l => 'mailing' ),
                                                                            'priority'  => '800' ) ) )
    );

    // strumenti mailing
    $p['mailing.tools'] = array(
        'sitemap'           => false,
        'icon'              => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'             => array( $l        => 'azioni mailing' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'      => 'mailing.view' ),
        'template'          => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'             => array( $m . '_src/_inc/_macro/_mailing.tools.php' ),
        'auth'              => array( 'groups'  => array(   'roots', 'staff' ) ),
        'etc'               => array( 'tabs'    => 'mailing.view' )
    );

    // gestione mailing
    $p['mailing.form'] = array(
        'sitemap'           => false,
        'title'             => array( $l        => 'gestione' ),
        'h1'                => array( $l        => 'gestione' ),
        'parent'            => array( 'id'      => 'mailing.view' ),
        'template'          => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'mailing.form.twig' ),
        'macro'             => array( $m . '_src/_inc/_macro/_mailing.form.php' ),
        'auth'              => array( 'groups'  => array(   'roots', 'staff' ) ),
        'etc'               => array( 'tabs'    => array(   'mailing.form',
                                                            // 'mailing.form.promemoria',
                                                            // 'mailing.form.contenuti',
                                                            'mailing.form.invio',
                                                            // 'mailing.form.file',
                                                            'mailing.form.tools' ) )
    );

    // RELAZIONI CON IL MODULO ATTIVITA
    if( in_array( "AT000.attivita", $cf['mods']['active']['array'] ) ) {
        arrayInsertBefore( 'mailing.form.invio', $p['mailing.form']['etc']['tabs'], 'mailing.form.promemoria' );
    }

    // RELAZIONI CON IL MODULO CONTENUTI
    if( in_array( "CO000.contenuti", $cf['mods']['active']['array'] ) ) {
        arrayInsertBefore( 'mailing.form.invio', $p['mailing.form']['etc']['tabs'], 'mailing.form.contenuti' );
    }

    // RELAZIONI CON IL MODULO FILE
    if( in_array( "FI000.file", $cf['mods']['active']['array'] ) ) {
        arrayInsertBefore( 'mailing.form.tools', $p['mailing.form']['etc']['tabs'], 'mailing.form.file' );
    }

    // gestione follow-up mailing
    $p['mailing.form.promemoria'] = array(
        'sitemap'           => false,
        'icon'              => '<i class="fa fa-calendar-plus-o" aria-hidden="true"></i>',
        'title'             => array( $l        => 'follow-up' ),
        'h1'                => array( $l        => 'follow-up' ),
        'parent'            => array( 'id'      => 'mailing.view' ),
        'template'          => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'mailing.form.promemoria.twig' ),
        'macro'             => array( $m . '_src/_inc/_macro/_mailing.form.promemoria.php' ),
        'auth'              => array( 'groups'  => array(   'roots' ) ),
        'etc'               => array( 'tabs'    => 'mailing.form' )
    );

    // gestione invio mailing
    $p['mailing.form.invio'] = array(
        'sitemap'           => false,
        'title'             => array( $l        => 'invio' ),
        'h1'                => array( $l        => 'invio' ),
        'parent'            => array( 'id'      => 'mailing.view' ),
        'template'          => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'mailing.form.invio.twig' ),
        'macro'             => array( $m . '_src/_inc/_macro/_mailing.form.invio.php' ),
        'auth'              => array( 'groups'  => array(   'roots' ) ),
        'etc'               => array( 'tabs'    => 'mailing.form' )
    );

    // strumenti gestione mailing
    $p['mailing.form.tools'] = array(
        'sitemap'           => false,
        'icon'              => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'             => array( $l        => 'azioni invio' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'      => 'mailing.view' ),
        'template'          => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'             => array( $m . '_src/_inc/_macro/_mailing.form.tools.php' ),
        'auth'              => array( 'groups'  => array(   'roots' ) ),
        'etc'               => array( 'tabs'    => 'mailing.form' )
    );

    // gestione destinatario mailing
    $p['mailing.mail.form'] = array(
        'sitemap'           => false,
        'title'             => array( $l        => 'gestione invio' ),
        'h1'                => array( $l        => 'gestione invio' ),
        'parent'            => array( 'id'      => 'mailing.view' ),
        'template'          => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'mailing.mail.form.twig' ),
        'macro'             => array( $m . '_src/_inc/_macro/_mailing.mail.form.php' ),
        'auth'              => array( 'groups'  => array(   'roots', 'staff' ) ),
        'etc'               => array( 'tabs'    => array(   'mailing.mail.form',
                                                            'mailing.mail.form.tools' ) )
    );

    // strumenti destinatario mailing
    $p['mailing.mail.form.tools'] = array(
        'sitemap'           => false,
        'icon'              => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'             => array( $l        => 'azioni mail mailing' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'      => 'mailing.view' ),
        'template'          => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'             => array( $m . '_src/_inc/_macro/_mailing.mail.form.tools.php' ),
        'auth'              => array( 'groups'  => array(   'roots' ) ),
        'etc'               => array( 'tabs'    => 'mailing.mail.form' )
    );

    // vista liste
    $p['liste.view'] = array(
        'sitemap'           => false,
        'title'             => array( $l        => 'liste' ),
        'h1'                => array( $l        => 'liste' ),
        'parent'            => array( 'id'      => 'mailing.view' ),
        'template'          => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
        'macro'             => array( $m . '_src/_inc/_macro/_liste.view.php' ),
        'auth'              => array( 'groups'  => array(   'roots', 'staff' ) ),
        'etc'               => array( 'tabs'    => 'mailing.view' ),
        'menu'              => array( 'admin'   => array(   '' =>   array(  'label'     => array( $l => 'liste' ),
                                                                            'priority'  => '030' ) ) )
    );

    // gestione liste
    $p['liste.form'] = array(
        'sitemap'           => false,
        'title'             => array( $l        => 'gestione' ),
        'h1'                => array( $l        => 'gestione' ),
        'parent'            => array( 'id'      => 'liste.view' ),
        'template'          => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'liste.form.twig' ),
        'macro'             => array( $m . '_src/_inc/_macro/_liste.form.php' ),
        'auth'              => array( 'groups'  => array(   'roots', 'staff' ) ),
        'etc'               => array( 'tabs'    => array(   'liste.form',
                                                            'liste.form.iscritti',
                                                            'liste.form.tools' ) )
    );

    // iscritti alla lista
    $p['liste.form.iscritti'] = array(
        'sitemap'           => false,
        'title'             => array( $l        => 'iscritti' ),
        'h1'                => array( $l        => 'iscritti' ),
        'parent'            => array( 'id'      => 'liste.view' ),
        'template'          => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'liste.form.iscritti.twig' ),
        'macro'             => array( $m . '_src/_inc/_macro/_liste.form.iscritti.php' ),
        'auth'              => array( 'groups'  => array(   'roots' ) ),
        'etc'               => array( 'tabs'    => 'liste.form' )
    );

    // strumenti gestione liste
    $p['liste.form.tools'] = array(
        'sitemap'           => false,
        'icon'              => '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'             => array( $l        => 'azioni gestione liste' ),
        'h1'                => array( $l        => 'azioni' ),
        'parent'            => array( 'id'      => 'liste.view' ),
        'template'          => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'             => array( $m . '_src/_inc/_macro/_liste.form.tools.php' ),
        'auth'              => array( 'groups'  => array(   'roots', 'staff' ) ),
        'etc'               => array( 'tabs'    => 'liste.form' )
    );

    // gestione iscrizione
    $p['liste.mail.form'] = array(
        'sitemap'           => false,
        'title'             => array( $l        => 'gestione liste mail' ),
        'h1'                => array( $l        => 'gestione' ),
        'parent'            => array( 'id'      => 'liste.form' ),
        'template'          => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'liste.mail.form.twig' ),
        'macro'             => array( $m . '_src/_inc/_macro/_liste.mail.form.php' ),
        'auth'              => array( 'groups'  => array(   'roots', 'staff' ) ),
        'etc'               => array( 'tabs'    => array(   'liste.mail.form' ) )
    );

    // iscrizioni di un indirizzo
    $p['anagrafica.archivio.mail.form.liste'] = array(
        'sitemap'           => false,
        'title'             => array( $l        => 'iscrizioni mail' ),
        'h1'                => array( $l        => 'liste' ),
        'parent'            => array( 'id'      => 'anagrafica.archivio.mail.view' ),
        'template'          => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'anagrafica.archivio.mail.form.liste.twig' ),
        'macro'             => array( $m . '_src/_inc/_macro/_anagrafica.archivio.mail.form.liste.php' ),
        'auth'              => array( 'groups'  => array(   'roots', 'staff' ) ),
        'etc'               => array( 'tabs'    => 'anagrafica.archivio.mail.form' )
    );

    // RELAZIONI CON IL MODULO ANAGRAFICA
    if( in_array( "AN000.anagrafica", $cf['mods']['active']['array'] ) ) {
        arrayInsertBefore( 'anagrafica.archivio.mail.form.tools', $p['anagrafica.archivio.mail.form']['etc']['tabs'], 'anagrafica.archivio.mail.form.liste' );
    }

    // disiscrizione dalla newsletter
    $p['disiscrizione'] = array(
        'sitemap'           => false,
        'title'             => array( $l        => 'disiscrizione' ),
        'h1'                => array( $l        => 'disiscrizione' ),
        'parent'            => array( 'id'      => NULL ),
        'template'          => array( 'path'    => '_src/_tpl/_aurora/', 'schema' => 'disiscrizione.twig' ),
        'macro'             => array( $m . '_src/_inc/_macro/_disiscrizione.php' ),
        'auth'              => array( 'groups'  => array(   'roots', 'staff', 'guest' ) )
    );
