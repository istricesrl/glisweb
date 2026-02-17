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
    $m = DIR_MOD . '_MA000.mail/';

    // vista mail in uscita
	$p['mail.out.view'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'mail in uscita' ),
	    'h1'			=> array( $l		=> 'mail' ),
	    'tab'			=> array( $l		=> 'in uscita' ),
	    'template'		=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
	    'macro'			=> array( $m . '_src/_inc/_macro/_mail.out.view.php' ),
	    'parent'		=> array( 'id'		=> 'strumenti' ),
	    'auth'			=> array( 'groups'	=> array(	'roots' ) ),
		'etc'			=> array( 'tabs'	=> array(	'mail.out.view',
													'mail.sent.view',
													// 'mail.template.view',
													'mail.tools'
												 ) ),
		'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'mail' ),
								'priority'	=> '950' ) ) )
	);

    // RELAZIONI CON IL MODULO TEMPLATE
    if( in_array( "TE000.template", $cf['mods']['active']['array'] ) ) {
        arrayInsertBefore( 'mail.tools', $p['mail.out.view']['etc']['tabs'], 'mail.template.view' );
    }

    // gestione mail in uscita
	$p['mail.out.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'template'		=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'mail.out.form.twig' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_mail.out.form.php' ),
	    'parent'		=> array( 'id'		=> 'mail.out.view' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> array(	'mail.out.form',
													// 'mail.out.form.file',
													'mail.out.form.tools'
												 ) ),
	);

    // RELAZIONI CON IL MODULO FILE
    if( in_array( "FI000.file", $cf['mods']['active']['array'] ) ) {
        arrayInsertBefore( 'mail.out.form.tools', $p['mail.out.form']['etc']['tabs'], 'mail.out.form.file' );
    }

    // gestione strumenti mail in uscita
	$p['mail.out.form.tools'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'strumenti code mail' ),
	    'h1'		=> array( $l		=> 'strumenti' ),
	    'template'		=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_mail.out.form.tools.php' ),
	    'parent'		=> array( 'id'		=> 'mail.out.view' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['mail.out.form']['etc']['tabs'] )
	);

    // vista mail inviate
	$p['mail.sent.view'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'mail inviate' ),
	    'h1'		=> array( $l		=> 'mail inviate' ),
	    'tab'		=> array( $l		=> 'inviate' ),
	    'template'		=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.view.twig' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_mail.sent.view.php' ),
	    'parent'		=> array( 'id'		=> 'mail.out.view' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['mail.out.view']['etc']['tabs'] )
	);

    // gestione mail inviate
	$p['mail.sent.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'template'		=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'mail.sent.form.twig' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_mail.sent.form.php' ),
	    'parent'		=> array( 'id'		=> 'mail.sent.view' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> array(	'mail.sent.form',
													'mail.sent.form.tools'
												 ) ),
	);

    // RELAZIONI CON IL MODULO FILE
    if( in_array( "FI000.file", $cf['mods']['active']['array'] ) ) {
        arrayInsertBefore( 'mail.sent.form.tools', $p['mail.sent.form']['etc']['tabs'], 'mail.sent.form.file' );
    }

    // gestione strumenti mail in uscita
	$p['mail.sent.form.tools'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'strumenti code mail' ),
	    'h1'		=> array( $l		=> 'strumenti' ),
	    'template'		=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_mail.sent.form.tools.php' ),
	    'parent'		=> array( 'id'		=> 'mail.sent.view' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['mail.sent.form']['etc']['tabs'] )
	);

	// strumenti mail
	$p['mail.tools'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'strumenti mail' ),
		'h1'		=> array( $l		=> 'strumenti mail' ),
		'template'		=> array( 'path'	=> '_src/_tpl/_athena/', 'schema' => 'default.tools.twig' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_mail.tools.php' ),
		'parent'		=> array( 'id'		=> 'mail.out.view' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['mail.out.view']['etc']['tabs'] )
	);

