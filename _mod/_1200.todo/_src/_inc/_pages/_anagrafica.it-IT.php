<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_1200.todo/';

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
