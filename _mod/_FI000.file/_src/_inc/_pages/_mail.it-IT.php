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
    $m = DIR_MOD . '_FI000.file/';

	// gestione file mail in uscita
	$p['mail.out.form.file'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa-regular fa-folder-open" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'file' ),
		'h1'		=> array( $l		=> 'file' ),
	    'template'		=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'mail.out.form.file.twig' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_mail.out.form.file.php' ),
	    'parent'		=> array( 'id'		=> 'mail.out.view' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> 'mail.out.form' )
	);

	// gestione file mail in uscita
	$p['mail.sent.form.file'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa-regular fa-folder-open" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'file' ),
		'h1'		=> array( $l		=> 'file' ),
	    'template'		=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'mail.sent.form.file.twig' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_mail.sent.form.file.php' ),
	    'parent'		=> array( 'id'		=> 'mail.sent.view' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> 'mail.sent.form' )
	);

	// gestione template file
	$p['mail.template.form.file'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa-regular fa-folder-open" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'file' ),
		'h1'		=> array( $l		=> 'file' ),
		'parent'		=> array( 'id'		=> 'mail.template.view' ),
		'template'		=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'mail.template.form.file.twig' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_mail.template.form.file.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> 'mail.template.form' )
	);

