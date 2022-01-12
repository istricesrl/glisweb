<?php

    // lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_6600.contratti/';

	// vista contratti
	$p['contratti.view'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'contratti' ),
	    'h1'		=> array( $l		=> 'contratti' ),
	    'parent'		=> array( 'id'		=> 'anagrafica.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'		=> array(  $m . '_src/_inc/_macro/_contratti.view.php' ),
	    'etc'		=> array( 'tabs'	=> array( 'contratti.view', 'contratti.scadenze.view', 'contratti.archivio.view' ) ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'contratti' ),
									'priority'	=> '200' ) ) )						
	);

	// vista archivio contratti
	$p['contratti.archivio.view'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-archive" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'archivio' ),
	    'h1'		=> array( $l		=> 'archivio' ),
	    'parent'		=> array( 'id'		=> 'contratti.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_contratti.archivio.view.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['contratti.view']['etc']['tabs'] )
	);

	// vista scadenze contratti
	$p['contratti.scadenze.view'] = array(
	    'sitemap'		=> false,
		'title'		=> array( $l		=> 'scadenze' ),
	    'h1'		=> array( $l		=> 'scadenze' ),
	    'parent'		=> array( 'id'		=> 'contratti.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_contratti.scadenze.view.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['contratti.view']['etc']['tabs'] )
	);

    // gestione contratti
	$p['contratti.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'contratti.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'contratti.form.html' ),
	    'macro'		=> array(  $m . '_src/_inc/_macro/_contratti.form.php' ),
		'etc'		=> array( 'tabs'	=> array( 'contratti.form'/*, 'contratti.form.amministrazione'*/ ) ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) )
	);



	foreach( range( 1, 9 ) as $i ) {
		$p['contratti.form']['etc']['tabs'][] = 'contratti.form.orari.'.  $i ;
	}

	$p['contratti.form']['etc']['tabs'][] = 'contratti.form.disponibilita';
	#$p['contratti.form']['etc']['tabs'][] = 'contratti.form.pianificazioni';
	$p['contratti.form']['etc']['tabs'][] = 'contratti.form.tools';


    // gestione contratti
	$p['contratti.form.amministrazione'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'amministrazione' ),
	    'h1'		=> array( $l		=> 'amministrazione' ),
	    'parent'		=> array( 'id'		=> 'contratti.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'contratti.form.amministrazione.html' ),
	    'macro'		=> array(  $m . '_src/_inc/_macro/_contratti.form.amministrazione.php' ),
		'etc'		=> array( 'tabs'	=> $p['contratti.form']['etc']['tabs'] ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) )
	);

	foreach( range( 1, 9 ) as $i ) {
		$p['contratti.form.orari.' . $i ] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'orari turno ' . $i ),
			'h1'			=> array( $l		=> 'turno ' . $i ),
			'parent'		=> array( 'id'		=> 'contratti.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'contratti.form.orari.html' ),
			'macro'			=> array(  $m . '_src/_inc/_macro/_contratti.form.orari.php' ),
			'etc'			=> array( 'tabs'	=>$p['contratti.form']['etc']['tabs'] ),
			'auth'			=> array( 'groups'	=> array(	'roots' ) ),
			'turno'			=> $i	// setto il numero del turno per ciascuna pagina
		);
	}

	// disponibilita
	$p['contratti.form.disponibilita' ] = array(
		'sitemap'		=> false,
		'title'			=> array( $l		=> 'disponibilita' ),
		'h1'			=> array( $l		=> 'disponibilità' ),
		'parent'		=> array( 'id'		=> 'contratti.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'contratti.form.disponibilita.html' ),
		'macro'			=> array(  $m . '_src/_inc/_macro/_contratti.form.disponibilita.php' ),
		'etc'			=> array( 'tabs'	=>$p['contratti.form']['etc']['tabs'] ),
		'auth'			=> array( 'groups'	=> array(	'roots' ) )
	);

	// gestione contratti tools
	$p['contratti.form.tools'] = array(
	    'sitemap'		=> false,
		'title'		=> array( $l		=> 'strumenti contratti' ),
		'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'h1'		=> array( $l		=> 'strumenti' ),
	    'parent'		=> array( 'id'		=> 'contratti.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'		=> array(  $m . '_src/_inc/_macro/_contratti.form.tools.php' ),
	    'etc'		=> array( 'tabs'	=>$p['contratti.form']['etc']['tabs'] ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) )
	);

	
	// vista tipologie contratti
	$p['tipologie.contratti.view'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'tipologie' ),
		'h1'		=> array( $l		=> 'tipologie' ),
		'parent'		=> array( 'id'		=> 'contratti.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'		=> array(  $m . '_src/_inc/_macro/_tipologie.contratti.view.php' ),
		'etc'		=> array( 'tabs'	=> array( 'tipologie.contratti.view' ) ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'menu'		=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'tipologie' ),
									'priority'	=> '120' ) ) )
	);

	// gestione tipologie contratti
	$p['tipologie.contratti.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'tipologie.contratti.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'tipologie.contratti.form.html' ),
		'macro'		=> array(  $m . '_src/_inc/_macro/_tipologie.contratti.form.php' ),
		'etc'		=> array( 'tabs'	=> array( 'tipologie.contratti.form' ) ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) )		
	);


	/* contratti produzione */
	// vista contratti
	$p['contratti.produzione.view'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'contratti' ),
	    'h1'		=> array( $l		=> 'contratti' ),
	    'parent'		=> array( 'id'		=> 'produzione' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'		=> array(  $m . '_src/_inc/_macro/_contratti.produzione.view.php' ),
	    'etc'		=> array( 'tabs'	=> array( 'contratti.produzione.view'/*, 'contratti.produzione.archivio.view'*/ ) ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'contratti' ),
									'priority'	=> '200' ) ) )						
	);

	// vista archivio contratti
/*	$p['contratti.produzione.archivio.view'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-archive" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'archivio' ),
	    'h1'		=> array( $l		=> 'archivio' ),
	    'parent'		=> array( 'id'		=> 'contratti.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_contratti.produzione.archivio.view.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['contratti.produzione.view']['etc']['tabs'] )
	);
*/
	// gestione contratti
	$p['contratti.produzione.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'contratti.produzione.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'contratti.produzione.form.html' ),
	    'macro'		=> array(  $m . '_src/_inc/_macro/_contratti.produzione.form.php' ),
		'etc'		=> array( 'tabs'	=> array( 'contratti.produzione.form', 'contratti.produzione.form.pianificazioni' ) ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) )
	);

	// gestione contratti pianificazioni
	$p['contratti.produzione.form.pianificazioni'] = array(
	    'sitemap'		=> false,
		'title'		=> array( $l		=> 'pianificazioni contratti' ),
		'icon'		=> '<i class="fa fa-calendar-o" aria-hidden="true"></i>',
	    'h1'		=> array( $l		=> 'pianificazioni' ),
	    'parent'		=> array( 'id'		=> 'contratti.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'contratti.produzione.form.pianificazioni.html' ),
	    'macro'		=> array(  $m . '_src/_inc/_macro/_contratti.produzione.form.pianificazioni.php' ),
	    'etc'		=> array( 'tabs'	=> $p['contratti.produzione.form']['etc']['tabs'] ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) )
	);


	// vista tipologie contratti
	$p['tipologie.contratti.produzione.view'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'tipologie' ),
		'h1'		=> array( $l		=> 'tipologie' ),
		'parent'		=> array( 'id'		=> 'contratti.produzione.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'		=> array(  $m . '_src/_inc/_macro/_tipologie.contratti.produzione.view.php' ),
		'etc'		=> array( 'tabs'	=> array( 'tipologie.contratti.produzione.view' ) ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'menu'		=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'tipologie' ),
									'priority'	=> '120' ) ) )
	);

	// gestione tipologie contratti
	$p['tipologie.contratti.produzione.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'tipologie.contratti.produzione.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'tipologie.contratti.produzione.form.html' ),
		'macro'		=> array(  $m . '_src/_inc/_macro/_tipologie.contratti.produzione.form.php' ),
		'etc'		=> array( 'tabs'	=> array( 'tipologie.contratti.produzione.form' ) ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) )		
	);

	// gestione contratti relativi al progetto
	if( in_array( "6600.contratti", $cf['mods']['active']['array'] ) ){

		arrayInsertSeq( 'progetti.produzione.form.pause', $p['progetti.produzione.form']['etc']['tabs'], 'progetti.produzione.form.contratti' );
		
		foreach( $p['progetti.produzione.form']['etc']['tabs'] as $t ){
			$p[ $t ]['etc']['tabs'] = $p['progetti.produzione.form']['etc']['tabs'];
		}
		
		// gestione contratti progetti
		$p['progetti.produzione.form.contratti'] = array(
			'sitemap'		=> false,
			'title'			=> array( $l		=> 'contratti' ),
			'h1'			=> array( $l		=> 'contratti' ),
			'parent'		=> array( 'id'		=> 'progetti.produzione.view' ),
			'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'progetti.produzione.form.contratti.html' ),
			'macro'			=> array( $m.'_src/_inc/_macro/_progetti.produzione.form.contratti.php' ),
			'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
			'etc'			=> array( 'tabs'	=> $p['progetti.produzione.form']['etc']['tabs'] )
		);
	}