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

	// form template sms contenuti
	$p['sms.template.form.contenuti'] = array(
	    'sitemap'		=> false,
		'icon'			=> '<i class="fa-regular fa-file-text" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'contenuti' ),
	    'h1'		=> array( $l		=> 'contenuti' ),
	    'parent'		=> array( 'id'		=> 'sms.template.view' ),
	    'template'		=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'sms.template.form.contenuti.twig' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_sms.template.form.contenuti.php' ),
		'etc'		=> array( 'tabs'	=> 'sms.template.form' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) )
	);
