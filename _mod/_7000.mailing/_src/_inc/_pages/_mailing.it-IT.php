<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_7000.mailing/';

    // dashboard mailing
	$p['mailing'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'mailing' ),
	    'h1'		=> array( $l		=> 'mailing' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'mailing.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_mailing.php' ),
	    'parent'		=> array( 'id'		=> NULL ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> array(	'mailing' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'mailing' ),
									'priority'	=> '800' ) ) )	
	);

    // vista mailing
	$p['mailing.view'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'invii' ),
	    'h1'		=> array( $l		=> 'invii' ),
	    'parent'		=> array( 'id'		=> 'mailing' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_mailing.view.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'mailing.view',
									'mailing.tools' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'invii' ),
									'priority'	=> '010' ) ) )	
    );

    // tools mailing
	$p['mailing.tools'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'azioni' ),
	    'h1'		=> array( $l		=> 'azioni' ),
	    'parent'		=> array( 'id'		=> 'mailing' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_mailing.tools.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['mailing.view']['etc']['tabs'] )
    );

    // form mailing
	$p['mailing.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'mailing.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'mailing.form.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_mailing.form.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'mailing.form',
													'mailing.form.testo',
													'mailing.form.destinatari',
													'mailing.form.file',
													'mailing.form.metadati',
													'mailing.form.tools'
												) )
	);

    // vista liste
	$p['liste.view'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'liste' ),
	    'h1'		=> array( $l		=> 'liste' ),
	    'parent'		=> array( 'id'		=> 'mailing' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_liste.view.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'liste.view',
									'liste.tools' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'liste' ),
									'priority'	=> '030' ) ) )	
    );

    // tools liste
	$p['liste.tools'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'azioni' ),
	    'h1'		=> array( $l		=> 'azioni' ),
	    'parent'		=> array( 'id'		=> 'mailing' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_liste.tools.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['liste.view']['etc']['tabs'] )
    );

    // form liste
	$p['liste.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'liste.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'liste.form.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_liste.form.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'liste.form',
													'liste.form.metadati',
													'liste.form.tools'
												) )
	);
