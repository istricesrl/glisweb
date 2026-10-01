<?php

    /**
     * scheda contenuti dei mailing
     *
     * La scheda del mailing di `_ML000.mailing` che contiene mittente, oggetto e testo per lingua; la dichiara questo modulo, che possiede la tabella
     * `contenuti`, e la inserisce fra le schede del mailing la pagina `mailing.form` di `_ML000.mailing`, come per le
     * schede dei template mail. Si dichiara solo se `_ML000.mailing` è attivo, perché altrimenti la pagina padre
     * non esiste.
     *
     */

    // lingua di questo file
    $l = 'it-IT';

    // modulo di questo file
    $m = DIR_MOD . '_CO000.contenuti/';

    // solo se il modulo mailing è attivo
    if( in_array( "ML000.mailing", $cf['mods']['active']['array'] ) ) {

        // form mailing contenuti
        $p['mailing.form.contenuti'] = array(
            'sitemap'		=> false,
            'icon'		=> '<i class="fa-regular fa-file-text" aria-hidden="true"></i>',
            'title'		=> array( $l		=> 'contenuti' ),
            'h1'		=> array( $l		=> 'contenuti' ),
            'parent'		=> array( 'id'		=> 'mailing.view' ),
            'template'		=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'mailing.form.contenuti.twig' ),
            'macro'		=> array( $m . '_src/_inc/_macro/_mailing.form.contenuti.php' ),
            'js'		=> array( 'internal' => array( '_src/_js/_lib/_codemirror.js' ) ),
            'etc'		=> array( 'tabs'	=> 'mailing.form' ),
            'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) )
        );

    }
