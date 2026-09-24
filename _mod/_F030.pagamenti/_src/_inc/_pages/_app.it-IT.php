<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
    $m = '_mod/_F030.pagamenti/';

    // pagina di scelta
	$p['app.pagamento.scelta'] = array(
	    'sitemap'		=> false,
	    'cacheable'		=> false,
	    'title'		=> array( $l		=> 'scelta pagamento app' ),
	    'h1'		=> array( $l		=> 'scelta pagamento' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_minerva/', 'schema' => 'app.pagamento.scelta.html' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_pagamento.scelta.php' )
	);

    // pagina di riepilogo
	$p['app.pagamento.riepilogo'] = array(
	    'sitemap'		=> false,
	    'cacheable'		=> false,
	    'title'		=> array( $l		=> 'riepilogo pagamento app' ),
	    'h1'		=> array( $l		=> 'riepilogo pagamento' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_minerva/', 'schema' => 'app.pagamento.riepilogo.html' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_pagamento.riepilogo.php' )
	);

    // pagina di esito
	$p['app.pagamento.esito'] = array(
	    'sitemap'		=> false,
	    'cacheable'		=> false,
	    'title'		=> array( $l		=> 'esito pagamento app' ),
	    'h1'		=> array( $l		=> 'esito pagamento' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_minerva/', 'schema' => 'app.pagamento.esito.html' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_pagamento.esito.php' )
	);
