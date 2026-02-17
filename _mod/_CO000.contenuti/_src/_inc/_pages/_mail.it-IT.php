<?php

    /** 
     * 
     * 
     * 
     * 
     * TODO documentare
     * 
     * 
     */

    // lingua di questo file
    $l = 'it-IT';

    // modulo di questo file
    $m = DIR_MOD . '_CO000.contenuti/';

	// form template mail contenuti
	$p['mail.template.form.contenuti'] = array(
	    'sitemap'		=> false,
		'icon'			=> '<i class="fa-regular fa-file-text" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'contenuti' ),
	    'h1'		=> array( $l		=> 'contenuti' ),
	    'parent'		=> array( 'id'		=> 'mail.template.view' ),
	    'template'		=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'mail.template.form.contenuti.twig' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_mail.template.form.contenuti.php' ),
		'etc'		=> array( 'tabs'	=> 'mail.template.form' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) )
	);
