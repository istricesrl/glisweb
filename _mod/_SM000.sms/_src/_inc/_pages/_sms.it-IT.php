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
    $m = DIR_MOD . '_SM000.sms/';

    // vista sms in uscita
	$p['sms.out.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'sms in uscita' ),
	    'h1'			=> array( $l		=> 'sms' ),
	    'tab'			=> array( $l		=> 'in uscita' ),
	    'template'		=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_sms.out.view.php' ),
	    'parent'		=> array( 'id'		=> 'strumenti' ),
	    'auth'			=> array( 'groups'	=> array(	'roots' ) ),
		'etc'			=> array( 'tabs'	=> array(	'sms.out.view',
													'sms.sent.view',
													// 'sms.template.view',
													'sms.tools'
												 ) ),
		'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'sms' ),
								'priority'	=> '950' ) ) )
	);

    // RELAZIONI CON IL MODULO TEMPLATE
    if( in_array( "TE000.template", $cf['mods']['active']['array'] ) ) {
        arrayInsertBefore( 'sms.tools', $p['sms.out.view']['etc']['tabs'], 'sms.template.view' );
    }

    // gestione sms in uscita
	$p['sms.out.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'template'		=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'sms.out.form.twig' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_sms.out.form.php' ),
	    'parent'		=> array( 'id'		=> 'sms.out.view' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> array(	'sms.out.form',
													// 'sms.out.form.file',
													'sms.out.form.tools'
												 ) ),
	);

    // gestione strumenti sms in uscita
	$p['sms.out.form.tools'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'strumenti code sms' ),
	    'h1'		=> array( $l		=> 'strumenti' ),
	    'template'		=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_sms.out.form.tools.php' ),
	    'parent'		=> array( 'id'		=> 'sms.out.view' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['sms.out.form']['etc']['tabs'] )
	);

    // vista sms inviati
	$p['sms.sent.view'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'sms inviati' ),
	    'h1'		=> array( $l		=> 'sms inviati' ),
	    'tab'		=> array( $l		=> 'inviati' ),
	    'template'		=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_sms.sent.view.php' ),
	    'parent'		=> array( 'id'		=> 'sms.out.view' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['sms.out.view']['etc']['tabs'] )
	);

    // gestione sms inviati
	$p['sms.sent.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'template'		=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'sms.sent.form.twig' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_sms.sent.form.php' ),
	    'parent'		=> array( 'id'		=> 'sms.sent.view' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> array(	'sms.sent.form',
													'sms.sent.form.tools'
												 ) ),
	);

    // gestione strumenti sms inviati
	$p['sms.sent.form.tools'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'strumenti code sms' ),
	    'h1'		=> array( $l		=> 'strumenti' ),
	    'template'		=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_sms.sent.form.tools.php' ),
	    'parent'		=> array( 'id'		=> 'sms.sent.view' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['sms.sent.form']['etc']['tabs'] )
	);

	// strumenti sms
	$p['sms.tools'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'strumenti sms' ),
		'h1'		=> array( $l		=> 'strumenti sms' ),
		'template'		=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_sms.tools.php' ),
		'parent'		=> array( 'id'		=> 'sms.out.view' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['sms.out.view']['etc']['tabs'] )
	);

