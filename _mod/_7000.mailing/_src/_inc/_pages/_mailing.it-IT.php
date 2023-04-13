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
	    'title'		=> array( $l		=> 'azioni invii' ),
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
													'mailing.form.invio',
													'mailing.form.file',
													'mailing.form.metadati',
													'mailing.form.tools'
												) )
	);

	// form mailing testo
	$p['mailing.form.testo'] = array(
	    'sitemap'		=> false,
		'icon'			=> '<i class="fa fa-file-text-o" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'testo' ),
	    'h1'		=> array( $l		=> 'testo' ),
	    'parent'		=> array( 'id'		=> 'mailing.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'mailing.form.testo.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_mailing.form.testo.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['mailing.form']['etc']['tabs'] )
	);

	// gestione invio
	$p['mailing.form.invio'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'invio' ),
		'h1'		=> array( $l		=> 'invio' ),
		'parent'		=> array( 'id'		=> 'mailing.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'mailing.form.invio.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_mailing.form.invio.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['mailing.form']['etc']['tabs'] )
	);

	// gestione file
	$p['mailing.form.file'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-folder-open-o" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'file' ),
		'h1'		=> array( $l		=> 'file' ),
		'parent'		=> array( 'id'		=> 'mailing.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'mailing.form.file.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_mailing.form.file.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['mailing.form']['etc']['tabs'] )
	);

	// gestione file
	$p['mailing.form.tools'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'azioni invio' ),
		'h1'		=> array( $l		=> 'azioni' ),
		'parent'		=> array( 'id'		=> 'mailing.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_mailing.form.tools.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['mailing.form']['etc']['tabs'] )
	);

	// form mailing
	$p['mailing.mail.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione invio' ),
	    'h1'		=> array( $l		=> 'gestione invio' ),
	    'parent'		=> array( 'id'		=> 'mailing.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'mailing.mail.form.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_mailing.mail.form.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'mailing.mail.form',
													'mailing.mail.form.tools'
												) )
	);

	// gestione file
	$p['mailing.mail.form.tools'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'azioni mail mailing' ),
		'h1'		=> array( $l		=> 'azioni' ),
		'parent'		=> array( 'id'		=> 'mailing.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_mailing.mail.form.tools.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['mailing.mail.form']['etc']['tabs'] )
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
	    'title'		=> array( $l		=> 'azioni liste' ),
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
													'liste.form.iscritti',
													'liste.form.metadati',
													'liste.form.tools'
												) )
	);

	// gestione invio
	$p['liste.form.iscritti'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'iscritti' ),
		'h1'		=> array( $l		=> 'iscritti' ),
	    'parent'		=> array( 'id'		=> 'liste.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'liste.form.iscritti.html' ),
		'macro'		=> array( $m . '_src/_inc/_macro/_liste.form.iscritti.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> $p['liste.form']['etc']['tabs'] )
	);

    // tools liste
	$p['liste.form.tools'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'azioni gestione liste' ),
	    'h1'		=> array( $l		=> 'azioni' ),
	    'parent'		=> array( 'id'		=> 'liste.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_liste.form.tools.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['liste.form']['etc']['tabs'] )
    );

    // form liste
	$p['liste.mail.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione liste mail' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'liste.form' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'liste.mail.form.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_liste.mail.form.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'liste.mail.form'
												) )
	);
