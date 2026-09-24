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
    $m = DIR_MOD . '_TE000.template/';

    // vista template mail
	$p['mail.template.view'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'template mail' ),
		'h1'		=> array( $l		=> 'template mail' ),
		'tab'		=> array( $l		=> 'template' ),
	    'template'	=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_mail.template.view.php' ),
		'parent'	=> array( 'id'		=> 'mail.out.view' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['mail.out.view']['etc']['tabs'] )
	);

	// gestione template mail
	$p['mail.template.form'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'gestione' ),
		'h1'		=> array( $l		=> 'gestione' ),
		'template'		=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'mail.template.form.twig' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_mail.template.form.php' ),
		'parent'		=> array( 'id'		=> 'mail.template.view' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> array(	'mail.template.form',
												// 'mail.template.form.contenuti',
												// 'mail.template.form.file',
												'mail.template.form.tools' ) ),
	);

    // RELAZIONI CON IL MODULO CONTENUTI
    if( in_array( "CO000.contenuti", $cf['mods']['active']['array'] ) ) {
        arrayInsertBefore( 'mail.template.form.tools', $p['mail.template.form']['etc']['tabs'], 'mail.template.form.contenuti' );
    }

    // RELAZIONI CON IL MODULO FILE
    if( in_array( "FI000.file", $cf['mods']['active']['array'] ) ) {
        arrayInsertBefore( 'mail.template.form.tools', $p['mail.template.form']['etc']['tabs'], 'mail.template.form.file' );
    }

	// gestione mail strumenti
	$p['mail.template.form.tools'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'azioni template mail' ),
	    'h1'		=> array( $l		=> 'azioni template mail' ),
		'parent'		=> array( 'id'		=> 'mail.template.view' ),
	    'template'		=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_mail.template.form.tools.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['mail.template.form']['etc']['tabs'] )
	);

