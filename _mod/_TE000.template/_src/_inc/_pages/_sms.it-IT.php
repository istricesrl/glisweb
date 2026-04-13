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

    // vista template sms
	$p['sms.template.view'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'template sms' ),
		'h1'		=> array( $l		=> 'template sms' ),
		'tab'		=> array( $l		=> 'template' ),
	    'template'	=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_sms.template.view.php' ),
		'parent'	=> array( 'id'		=> 'sms.out.view' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['sms.out.view']['etc']['tabs'] )
	);

	// gestione template sms
	$p['sms.template.form'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'gestione' ),
		'h1'		=> array( $l		=> 'gestione' ),
		'template'		=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'sms.template.form.twig' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_sms.template.form.php' ),
		'parent'		=> array( 'id'		=> 'sms.template.view' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> array(	'sms.template.form',
												// 'sms.template.form.contenuti',
												// 'sms.template.form.file',
												'sms.template.form.tools' ) ),
	);

    // RELAZIONI CON IL MODULO CONTENUTI
    if( in_array( "CO000.contenuti", $cf['mods']['active']['array'] ) ) {
        arrayInsertBefore( 'sms.template.form.tools', $p['sms.template.form']['etc']['tabs'], 'sms.template.form.contenuti' );
    }

	// gestione sms strumenti
	$p['sms.template.form.tools'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'azioni template sms' ),
	    'h1'		=> array( $l		=> 'azioni template sms' ),
		'parent'		=> array( 'id'		=> 'sms.template.view' ),
	    'template'		=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_sms.template.form.tools.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['sms.template.form']['etc']['tabs'] )
	);
