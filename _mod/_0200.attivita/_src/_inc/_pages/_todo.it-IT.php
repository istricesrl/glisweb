<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0200.attivita/';

	// RELAZIONI CON IL MODULO TODO
	if( in_array( "1200.todo", $cf['mods']['active']['array'] ) ) {

		$p['todo.form.attivita'] = array(
			'sitemap'		=> false,
			'icon'			=> '<i class="fa fa-pencil-square-o" aria-hidden="true"></i>',
			'title'			=> array( $l		=> 'attivita' ),
			'h1'			=> array( $l		=> 'attivita' ),
			'parent'		=> array( 'id'		=> 'todo.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'todo.form.attivita.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_todo.form.attivita.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> 'todo.form' )
		);

	}
