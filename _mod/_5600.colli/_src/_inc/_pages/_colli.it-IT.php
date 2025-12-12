<?php

	// lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_5600.colli/';

    // dashboard logistica doc. attivi
    $p['colli.view'] = array(
        'sitemap'		=> false,
        'title'		=> array( $l		=> 'colli' ),
        'h1'		=> array( $l		=> 'colli' ),
        'template'	=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
        'macro'		=> array( $m . '_src/_inc/_macro/_colli.view.php' ),
        'parent'	=> array( 'id'		=> 'logistica' ),
        'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
        'etc'		=> array( 'tabs'	=> array( 'colli.view', 'colli.stampe', 'colli.tools' ) ),
        'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'colli' ),
            'priority'	=> '120' ) ) )	
    );

	// stampe colli
	$p['colli.stampe'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-print" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'stampe' ),
	    'h1'		=> array( $l		=> 'stampe' ),
	    'parent'		=> array( 'id'		=> 'colli.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_colli.stampe.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['colli.view']['etc']['tabs'] )
	);

    // tools colli
    $p['colli.tools'] = array(
        'sitemap'			=> false,
        'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
        'title'				=> array( $l		=> 'azioni' ),
        'h1'				=> array( $l		=> 'azioni' ),
        'parent'			=> array( 'id'		=> 'colli.view' ),
        'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
        'macro'				=> array( $m . '_src/_inc/_macro/_colli.tools.php' ),
        'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
        'etc'				=> array( 'tabs'	=> $p['colli.view']['etc']['tabs'] )
    );

    // gestione ddt
    $p['colli.form'] = array(
        'sitemap'		=> false,
        'title'			=> array( $l		=> 'gestione' ),
        'h1'			=> array( $l		=> 'gestione' ),
        'parent'		=> array( 'id'		=> 'colli.view' ),
        'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'colli.form.html' ),
        'macro'			=> array( $m.'_src/_inc/_macro/_colli.form.php' ),
        'js'			=> array( 'internal' => array( $m . '_src/_templates/_athena/src/js/colli.js' ) ),
        'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
        'etc'			=> array( 'tabs'	=> array(	'colli.form',
                                                        // 'colli.form.contenuto',
                                                        // 'colli.form.evasione',
                                                        'colli.form.righe',
                                                        // 'colli.form.chiusura',
                                                        // 'colli.form.invio',
                                                        'colli.form.stampe',
                                                        // 'colli.form.tools' 
                                                    )
                                )
    );

	// stampe colli
	$p['colli.form.righe'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'righe collo' ),
	    'h1'		=> array( $l		=> 'righe' ),
	    'parent'		=> array( 'id'		=> 'colli.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'colli.form.righe.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_colli.form.righe.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['colli.form']['etc']['tabs'] )
	);

	// stampe colli
	$p['colli.form.stampe'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-print" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'stampe collo' ),
	    'h1'		=> array( $l		=> 'stampe' ),
	    'parent'		=> array( 'id'		=> 'colli.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_colli.form.stampe.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['colli.form']['etc']['tabs'] )
	);

    // debug
    // die( print_r( $p, true ) );
