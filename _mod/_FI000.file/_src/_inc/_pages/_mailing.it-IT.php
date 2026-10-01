<?php

    /**
     * scheda file dei mailing
     *
     * La scheda del mailing di `_ML000.mailing` che contiene gli allegati; la dichiara questo modulo, che possiede la tabella
     * `file`, e la inserisce fra le schede del mailing la pagina `mailing.form` di `_ML000.mailing`, come per le
     * schede dei template mail. Si dichiara solo se `_ML000.mailing` è attivo, perché altrimenti la pagina padre
     * non esiste.
     *
     */

    // lingua di questo file
    $l = 'it-IT';

    // modulo di questo file
    $m = DIR_MOD . '_FI000.file/';

    // solo se il modulo mailing è attivo
    if( in_array( "ML000.mailing", $cf['mods']['active']['array'] ) ) {

        // form mailing file
        $p['mailing.form.file'] = array(
            'sitemap'		=> false,
            'icon'		=> '<i class="fa-regular fa-folder-open" aria-hidden="true"></i>',
            'title'		=> array( $l		=> 'file' ),
            'h1'		=> array( $l		=> 'file' ),
            'parent'		=> array( 'id'		=> 'mailing.view' ),
            'template'		=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'mailing.form.file.twig' ),
            'macro'		=> array( $m . '_src/_inc/_macro/_mailing.form.file.php' ),
            'etc'		=> array( 'tabs'	=> 'mailing.form' ),
            'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) )
        );

    }
