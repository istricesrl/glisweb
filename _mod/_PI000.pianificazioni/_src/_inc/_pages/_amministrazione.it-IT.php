<?php

    /**
     * pagine del modulo pianificazioni nell'area amministrazione
     *
     * In questo file il modulo pianificazioni dichiara le schede che aggiunge ai form dei moduli documenti di nuova
     * generazione: la scheda pianificazione del form delle fatture di _DO010.fatture e quella del form dei documenti di
     * _DO000.documenti. Le schede compaiono nei form perché le pagine di quei moduli le inseriscono nelle loro linguette
     * con il blocco RELAZIONI CON IL MODULO PIANIFICAZIONI, quando _PI000.pianificazioni è attivo; è lo schema delle
     * schede che _AU000.audio dichiara per il form dell'anagrafica di _AN000.anagrafica.
     *
     */

    // lingua di questo file
    $l = 'it-IT';

    // modulo di questo file
    $m = DIR_MOD . '_PI000.pianificazioni/';

    // gestione fatture form pianificazione
    $p['amministrazione.ciclo.attivo.fatture.form.pianificazioni'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-calendar" aria-hidden="true"></i>',
        'title'                => array( $l        => 'amministrazione fatture attive form pianificazione' ),
        'h1'                => array( $l        => 'pianificazione' ),
        'parent'            => array( 'id'        => 'amministrazione.ciclo.attivo.fatture.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_amministrazione.ciclo.attivo.fatture.form.pianificazioni.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'amministrazione.ciclo.attivo.fatture.form' )
    );

    // gestione documenti form pianificazione
    $p['amministrazione.archivio.documenti.form.pianificazioni'] = array(
        'sitemap'            => false,
        'icon'                => '<i class="fa fa-calendar" aria-hidden="true"></i>',
        'title'                => array( $l        => 'amministrazione archivio documenti form pianificazione' ),
        'h1'                => array( $l        => 'pianificazione' ),
        'parent'            => array( 'id'        => 'amministrazione.archivio.documenti.view' ),
        'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
        'macro'                => array( $m . '_src/_inc/_macro/_amministrazione.archivio.documenti.form.pianificazioni.php' ),
        'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
        'etc'                => array( 'tabs'    => 'amministrazione.archivio.documenti.form' )
    );
