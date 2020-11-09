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
	    'etc'		=> array( 'tabs'	=> array(	'dashboard' ) ),
	    'menu'		=> array( 'admin'	=> array(	'label'		=> array( $l => 'dashboard' ),
									'priority'	=> '010' ) )
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
					array('id'=>'carica_file','schema'=>'inc/browser.modal.upload.html')
				)
			)
		),
	    'parent'		=> array( 'id'		=> NULL ),
	    'macro'		=> array( '_src/_inc/_macro/_browser.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) )
	);

?>
