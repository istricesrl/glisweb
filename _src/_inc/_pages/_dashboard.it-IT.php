<?php

    // lingua di questo file
	$l = 'it-IT';

    // pagina principale
	$p['dashboard'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'admin' ),
	    'h1'		=> array( $l		=> 'dashboard' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'metro.html' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'macro'		=> array( '_src/_inc/_macro/_default.dashboard.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'dashboard' ) ),
	    'menu'		=> array( 'admin'	=> array(	'label'		=> array( $l => 'dashboard' ),
									'priority'	=> 10 ) )
	);

    // cancellazione
	$p['cancellazione'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'cancellazione' ),
	    'h1'		=> array( $l		=> 'cancellazione' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'delete.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_default.delete.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) )
	);

    // file browser
	$p['file_browser'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'file browser' ),
	    'h1'		=> array( $l		=> 'file browser' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'browser.html' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'macro'		=> array( '_src/_inc/_macro/_default.browser.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) )
	);

?>
