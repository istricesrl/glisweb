<?php

	// lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0200.attivita/';

	// RELAZIONI CON IL MODULO DOCUMENTI
	if( in_array( "0400.documenti", $cf['mods']['active']['array'] ) ) {

        // gestione pagamenti fatture
        $p['documenti.form.attivita'] = array(
            'sitemap'		=> false,
            'icon'			=> '<i class="fa fa-pencil-square-o" aria-hidden="true"></i>',
            'title'			=> array( $l		=> 'attività' ),
            'h1'			=> array( $l		=> 'attività' ),
            'parent'		=> array( 'id'		=> 'documenti.view' ),
            'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'documenti.form.attivita.html' ),
            'macro'			=> array( $m.'_src/_inc/_macro/_documenti.form.attivita.php' ),
            'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
            'etc'			=> array( 'tabs'	=> 'documenti.form' )
        );

    }
