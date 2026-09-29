<?php

    /**
     * pagine del modulo pianificazioni nell'area produzione
     *
     * In questo file il modulo pianificazioni dichiara la scheda pianificazione che aggiunge al form delle attività di
     * _AT000.attivita, che la inserisce nelle sue linguette con il blocco RELAZIONI CON IL MODULO PIANIFICAZIONI quando
     * _PI000.pianificazioni è attivo ( vedi _amministrazione.it-IT.php di questo modulo ).
     *
     */

    // lingua di questo file
    $l = 'it-IT';

    // modulo di questo file
    $m = DIR_MOD . '_PI000.pianificazioni/';

    // gestione attività form pianificazione
    $p['produzione.attivita.form.pianificazioni'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-calendar" aria-hidden="true"></i>',
        'title'                => array( $l        => 'produzione attivita form pianificazione' ),
        'h1'                => array( $l        => 'pianificazione' ),
        'parent'            => array( 'id'        => 'produzione.attivita.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_produzione.attivita.form.pianificazioni.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'produzione.attivita.form' )
    );
