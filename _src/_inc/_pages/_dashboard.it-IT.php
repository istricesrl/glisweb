<?php

    // lingua di questo file
	$l = 'it-IT';

    // pagina principale
	$p['dashboard'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'admin' ),
	    'h1'		=> array( $l		=> 'dashboard' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'dashboard.html' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'macro'		=> array( '_src/_inc/_macro/_dashboard.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'dashboard', 'dashboard.tools' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'dashboard' ),
		'priority'	=> '010' ) ) )
	);

    // tools dashboard
	$p['dashboard.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'dashboard' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'				=> array( '_src/_inc/_macro/_dashboard.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['dashboard']['etc']['tabs'] )
	);

    // cancellazione
	$p['delete'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'cancellazione' ),
	    'h1'		=> array( $l		=> 'cancellazione' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'delete.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_delete.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) )
	);

    // file browser
	$p['browser'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'file browser' ),
	    'h1'		=> array( $l		=> 'file browser' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'browser.html' ),
		'contents'	=> array(
			'modals' => array(
				'browser' => array(
					array('id'=>'crea_cartella','schema'=>'inc/browser.modal.mkdir.html'),
					array('id'=>'carica_file','schema'=>'inc/browser.modal.upload.html'),
					array('id'=>'cancella_file','schema'=>'inc/browser.modal.unlink.html'),
					array('id'=>'sposta_file','schema'=>'inc/browser.modal.mvfile.html'),
					array('id'=>'sposta_file','schema'=>'inc/browser.modal.mvfolder.html'),
					array('id'=>'sposta_file','schema'=>'inc/browser.modal.rmfolder.html')
				)
			)
		),
	    'parent'		=> array( 'id'		=> NULL ),
	    'macro'		=> array( '_src/_inc/_macro/_browser.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) )
	);
