<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_9000.agenda/';
    
    // dashboard contenuti
	$p['agenda'] = array(
	    'sitemap'	=> false,
	    'title'		=> array( $l		=> 'agenda' ),
	    'h1'		=> array( $l		=> 'agenda' ),
	    'template'	=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'agenda.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_agenda.php' ),
	    'parent'	=> array( 'id'		=> NULL ),
		'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'		=> array( 'tabs'	=> array(	'agenda', 'agenda.stampe' ) ),
		'menu'		=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'agenda' ),
									'priority'	=> '040' ) ) )	
	);

    // stampe agenda
	$p['agenda.stampe'] = array(
	    'sitemap'	=> false,
		'icon'		=> '<i class="fa fa-print" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'stampe_agenda' ),
	    'h1'		=> array( $l		=> 'stampe' ),
	    'parent'	=> array( 'id'		=> 'agenda' ),
	    'template'	=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_agenda.stampe.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['agenda']['etc']['tabs'] )
	);

	// gestione attivita
	$p['agenda.form'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'gestione' ),
	    'h1'			=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'agenda' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'agenda.form.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_agenda.form.php' ),
		'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> array(	'agenda.form', 'agenda.form.feedback' ) )
	);

	// gestione agenda - feedback
	$p['agenda.form.feedback'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'feedback' ),
	    'h1'			=> array( $l		=> 'feedback' ),
	    'parent'		=> array( 'id'		=> 'agenda' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'agenda.form.feedback.html' ),
	    'macro'			=> array( $m.'_src/_inc/_macro/_agenda.form.feedback.php' ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'etc'			=> array( 'tabs'	=> $p['agenda.form']['etc']['tabs'] )
	);
