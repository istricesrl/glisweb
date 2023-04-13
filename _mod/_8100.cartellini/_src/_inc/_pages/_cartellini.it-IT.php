<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_1120.cartellini/';

    // tools attività
	$p['attivita.tools']['macro'][]		= $m . '_src/_inc/_macro/_attivita.tools.php';

	// vista cartellini
	$p['cartellini'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'cartellini' ),
	    'h1'		=> array( $l		=> 'cartellini' ),
	    'parent'		=> array( 'id'		=> 'produzione' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'cartellini.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_cartellini.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['attivita.view']['etc']['tabs'] )
    );


	
