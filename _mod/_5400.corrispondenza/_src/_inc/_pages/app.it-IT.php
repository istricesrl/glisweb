<?php

    // lingua di questo file
	$l = 'it-IT';

    /**
     * sezione corrispondenza
     * ----------------------
     * 
     * 
     */

    // pagina corrispondenza
	$p['corrispondenza'] = array(
	    'sitemap'		=> false,
	    'cacheable'		=> false,
	    'title'		=> array( $l		=> 'vista corrispondenza' ),
	    'h1'		=> array( $l		=> 'vista corrispondenza' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_minerva/', 'schema' => 'corrispondenza.html' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'macro'		=> array( '_src/_inc/_macro/_corrispondenza.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff', 'users' ) ),
		'menu'				=> array( 'app'	=> array(	'' => 	array(	'label'		=> array( $l => 'corrispondenza' ),
																	'priority'	=> '010' ) ) )
	);

