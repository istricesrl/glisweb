<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_7000.mailing/';

	// gestione mail strumenti
	$p['mail.form.iscrizioni'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'iscrizioni mail' ),
	    'h1'		=> array( $l		=> 'liste' ),
	    'parent'		=> array( 'id'		=> 'mail.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'mail.form.iscrizioni.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_mail.form.iscrizioni.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['mail.form']['etc']['tabs'] )
	);
