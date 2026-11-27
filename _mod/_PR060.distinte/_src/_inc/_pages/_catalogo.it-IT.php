<?php

    /**
     * pagine del modulo distinte
     *
     * il modulo aggiunge alla scheda articolo del modulo PR000.prodotti la linguetta della distinta base, subito dopo
     * quella delle caratteristiche; senza PR000.prodotti la scheda articolo non c'e' e il modulo non dichiara niente
     *
     */

    // lingua di questo file
    $l = 'it-IT';

    // modulo di questo file
    $m = DIR_MOD . '_PR060.distinte/';

    // RELAZIONI CON IL MODULO PRODOTTI
    if( in_array( "PR000.prodotti", $cf['mods']['active']['array'] ) ) {

        // inserimento della linguetta distinta nella scheda articolo
        arrayInsertSeq( 'catalogo.articoli.form.caratteristiche', $p['catalogo.articoli.form']['etc']['tabs'], 'catalogo.articoli.form.distinta' );

        // gestione distinta base articoli
        $p['catalogo.articoli.form.distinta'] = array(
            'sitemap'            => false,
            'title'                => array( $l        => 'catalogo articoli form distinta' ),
            'h1'                => array( $l        => 'distinta' ),
            'parent'            => array( 'id'        => 'catalogo.articoli.view' ),
            'template'            => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'catalogo.articoli.form.distinta.twig' ),
            'macro'                => array( $m . '_src/_inc/_macro/_catalogo.articoli.form.distinta.php' ),
            'auth'                => array( 'groups'    => array(    'roots', 'staff' ) ),
            'etc'                => array( 'tabs'    => 'catalogo.articoli.form' )
        );

    }
