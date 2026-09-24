<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0100.pianificazioni/';

	// RELAZIONI CON IL MODULO PRODUZIONE
	if( in_array( "1000.produzione", $cf['mods']['active']['array'] ) ) {

		// gestione progetti pianificazioni
		$p['progetti.produzione.form.pianificazioni'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'pianificazione' ),
			'icon'			=> '<i class="fa fa-clock-o" aria-hidden="true"></i>',
			'h1'			=> array( $l		=> 'pianificazione' ),
			'parent'		=> array( 'id'		=> 'progetti.produzione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.produzione.form.pianificazioni.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_progetti.produzione.form.pianificazioni.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> 'progetti.produzione.form' )
		);

	}
