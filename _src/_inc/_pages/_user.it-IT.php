<?php

    // lingua di questo file
	$l = 'it-IT';

	// carrello
	$p['user'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'area utente' ),
	    'h1'			=> array( $l		=> 'area utente' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'template'		=> array( 'path'	=> '_src/_templates/_lydia/', 'schema' => 'user.html' ),
	    'macro'			=> array( '_src/_inc/_macro/_user.php' ),
		'menu'			=> array( 'icons'	=> array(	'' => 	array(	'label'		=> array( $l => '<i class="fa fa-user" aria-hidden="true"></i>' ), 'priority'	=> '700' ) ) )
	);

