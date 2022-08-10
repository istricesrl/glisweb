<?php

    // lingua di questo file
	$l = 'it-IT';
	$m = '_mod/_0350.registrazione/';

    // pagina principale
	$p['registrazione'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'registrazione' ),
	    'h1'		=> array( $l		=> 'registrazione' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'registrazione.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_registrazione.php' )
	);

    // pagina principale
	$p['profilo'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'profilo' ),
	    'h1'		=> array( $l		=> 'il tuo profilo' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'template'		=> array( 'path'	=> '_src/_templates/_arianna/', 'schema' => 'profilo.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_profilo.php' ),
		'menu'			=> array( 'icons'	=> array(	'' => 	array(	'label'		=> array( $l => '<i class="fa fa-user" aria-hidden="true"></i>' ), 'priority'	=> '900' ) ) )
	);
