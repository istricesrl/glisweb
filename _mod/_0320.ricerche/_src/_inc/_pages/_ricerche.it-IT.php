<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_0320.ricerche/';

    // pagina per i risultati della ricerca
    $p['ricerche.avanzate'] = array(
        'sitemap'		    => false,
        'title'		        => array( $l		=> 'ricerca avanzata' ),
        'h1'		        => array( $l		=> 'ricerca avanzata' ),
        'template'		    => array( 'path'	=> '_src/_templates/_aurora/', 'schema' => 'ricerche.avanzate.html' ),
        'macro'		        => array( $m . '_src/_inc/_macro/_ricerche.avanzate.php' ),
        'parent'		    => array( 'id'		=> NULL )
    );

    // pagina per i risultati della ricerca
    $p['ricerche.risultati'] = array(
        'sitemap'		    => false,
        'title'		        => array( $l		=> 'risultati ricerca' ),
        'h1'		        => array( $l		=> 'risultati ricerca' ),
        'template'		    => array( 'path'	=> '_src/_templates/_aurora/', 'schema' => 'ricerche.risultati.html' ),
        'macro'		        => array( $m . '_src/_inc/_macro/_ricerche.risultati.php' ),
        'parent'		    => array( 'id'		=> NULL )
    );
