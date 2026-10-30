<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_1200.todo/';

	// RELAZIONI CON IL MODULO PRODUZIONE
	// NOTA la linguetta apre todo.form, che _todo.it-IT.php dichiara solo se 1000.produzione è attivo: senza, il
	// framework rispondeva 'la pagina di gestione todo.form non è stata definita'
	if( in_array( "1000.produzione", $cf['mods']['active']['array'] ) ) {

		// subview attività dell'anagrafica 
	    $p['anagrafica.form.todo'] = array(
	    	'sitemap'		=> false,
	        'icon'			=> '<i class="fa fa-tasks" aria-hidden="true"></i>',
	        'title'			=> array( $l		=> 'todo' ),
	        'h1'			=> array( $l		=> 'to-do' ),
	        'parent'		=> array( 'id'		=> 'anagrafica.view' ),
	        'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'anagrafica.form.todo.html' ),
	        'macro'			=> array( $m . '_src/_inc/_macro/_anagrafica.form.todo.php' ),
	        'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	        'etc'			=> array( 'tabs'	=> 'anagrafica.form' )
	    );

	}
