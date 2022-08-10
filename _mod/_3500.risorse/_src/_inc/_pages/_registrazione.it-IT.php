<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_3500.risorse/';
	
    // pagina principale
	$p['profilo.risorse'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'le mie risorse' ),
	    'h1'		=> array( $l		=> 'le mie risorse' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'template'		=> array( 'path'	=> '_src/_templates/_arianna/', 'schema' => 'profilo.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_profilo.risorse.php' ),
		'menu'			=> array( 'profilo'	=> array(	'' => 	array(	'label'		=> array( $l => 'le mie risorse' ), 'priority'	=> '900' ) ) )
	);
