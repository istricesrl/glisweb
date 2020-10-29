<?php

    // lingua di questo file
	$l = 'it-IT';

    // vista anagrafica
	$p['anagrafica.view'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'anagrafica' ),
	    'h1'		=> array( $l		=> 'anagrafica' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_anagrafica.view.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'anagrafica.view',
									'anagrafica.archivio.view',
									'anagrafica.tools' ) ),
	    'menu'		=> array( 'admin'	=> array(	'label'		=> array( $l => 'anagrafica' ),
									'priority'	=> '050' ) )
	);

    // vista archivio anagrafica
	$p['anagrafica.archivio.view'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-archive" aria-hidden="true"></i>',
		'title'		=> array( $l		=> 'archivio' ),
	    'h1'		=> array( $l		=> 'archivio' ),
	    'parent'		=> array( 'id'		=> 'anagrafica.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_anagrafica.archivio.view.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['anagrafica.view']['etc']['tabs'] )
	);

    // tools anagrafica
	$p['anagrafica.tools'] = array(
		'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'azioni' ),
	    'h1'		=> array( $l		=> 'azioni' ),
	    'parent'		=> array( 'id'		=> 'anagrafica.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_anagrafica.tools.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['anagrafica.view']['etc']['tabs'] )
	);

    // gestione anagrafica
	$p['anagrafica.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'anagrafica.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'anagrafica.form.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_anagrafica.form.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> array(	'anagrafica.form',
									'anagrafica.form.informazioni',
									'anagrafica.form.amministrazione',
//									'anagrafica.form.collaboratori',
									'anagrafica.form.cliente',
//									'anagrafica.form.fornitore',
//									'anagrafica.form.struttura',
//									'anagrafica.form.attivita',
//									'anagrafica.form.promemoria',
									'anagrafica.form.immagini',
									'anagrafica.form.archiviazione',
									'anagrafica.form.stampe' ) )
	);

    // gestione anagrafica informazioni
	$p['anagrafica.form.informazioni'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'informazioni' ),
	    'h1'		=> array( $l		=> 'informazioni' ),
	    'parent'		=> array( 'id'		=> 'anagrafica.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'anagrafica.form.informazioni.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_anagrafica.form.informazioni.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['anagrafica.form']['etc']['tabs'] )
	);
	
	 // gestione anagrafica amministrazione
	 $p['anagrafica.form.amministrazione'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'amministrazione' ),
	    'h1'		=> array( $l		=> 'amministrazione' ),
	    'parent'		=> array( 'id'		=> 'anagrafica.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'anagrafica.form.amministrazione.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_anagrafica.form.amministrazione.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['anagrafica.form']['etc']['tabs'] )
	);

	// gestione anagrafica cliente
	$p['anagrafica.form.cliente'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'cliente' ),
	    'h1'		=> array( $l		=> 'cliente' ),
	    'parent'		=> array( 'id'		=> 'anagrafica.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'anagrafica.form.cliente.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_anagrafica.form.cliente.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['anagrafica.form']['etc']['tabs'] )
	);

	// gestione anagrafica archiviazione
	$p['anagrafica.form.archiviazione'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-archive" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'archiviazione' ),
	    'h1'		=> array( $l		=> 'archiviazione' ),
	    'parent'		=> array( 'id'		=> 'anagrafica.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'anagrafica.form.archiviazione.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_anagrafica.form.archiviazione.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['anagrafica.form']['etc']['tabs'] )
	);

	// gestione anagrafica stampe
	$p['anagrafica.form.stampe'] = array(
	    'sitemap'		=> false,
		'icon'		=> '<i class="fa fa-print" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'stampe' ),
	    'h1'		=> array( $l		=> 'stampe' ),
	    'parent'		=> array( 'id'		=> 'anagrafica.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_anagrafica.form.stampe.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['anagrafica.form']['etc']['tabs'] )
	);

	// gestione anagrafica immagini
	$p['anagrafica.form.immagini'] = array(
	    'sitemap'		=> false,
	    'icon'		=> '<i class="fa fa-picture-o" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'immagini' ),
	    'h1'		=> array( $l		=> 'immagini' ),
	    'parent'		=> array( 'id'		=> 'anagrafica.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'anagrafica.form.immagini.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_anagrafica.form.immagini.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> $p['anagrafica.form']['etc']['tabs'] )
	);

    // vista account
	$p['account.view'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'account' ),
	    'h1'		=> array( $l		=> 'account' ),
	    'parent'		=> array( 'id'		=> 'anagrafica.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_account.view.php' ),
	    'etc'		=> array( 'tabs'	=> array( 'account.view' ) ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'menu'		=> array( 'admin'	=> array(	'label'		=> array( $l => 'account' ),
									'priority'	=> '010' ) )
	);

    // gestione account
	$p['account.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'account.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'account.form.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_account.form.php' ),
	    'etc'		=> array( 'tabs'	=> array( 'account.form',
								  'account.form.attribuzione' ) ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) )
	);

	// gestione account attribuzione
	$p['account.form.attribuzione'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'attribuzione' ),
	    'h1'		=> array( $l		=> 'attribuzione' ),
	    'parent'		=> array( 'id'		=> 'gruppi.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'account.form.attribuzione.html' ),
		'macro'		=> array( '_src/_inc/_macro/_account.form.attribuzione.php' ),
		'etc'		=> array( 'tabs'	=> $p['account.form']['etc']['tabs'] ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) )
	);

	// vista gruppi
	 $p['gruppi.view'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gruppi' ),
	    'h1'		=> array( $l		=> 'gruppi' ),
	    'parent'		=> array( 'id'		=> 'account.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_gruppi.view.php' ),
	    'etc'		=> array( 'tabs'	=> array( 'gruppi.view' ) ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'menu'		=> array( 'admin'	=> array(	'label'		=> array( $l => 'gruppi' ),
									'priority'	=> '120' ) )
	);

    // gestione gruppi
	$p['gruppi.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'gruppi.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'gruppi.form.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_gruppi.form.php' ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) ),
		'etc'		=> array( 'tabs'	=> array( 'gruppi.form',
												'gruppi.form.membri'												
		) ),
		
	);

	// gestione membri gruppi
	$p['gruppi.form.membri'] = array(
		'sitemap'		=> false,
		'title'		=> array( $l		=> 'membri' ),
		'h1'		=> array( $l		=> 'membri' ),
		'parent'		=> array( 'id'		=> 'gruppi.view' ),
		'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'gruppi.form.membri.html' ),
		'macro'		=> array( '_src/_inc/_macro/_gruppi.form.membri.php' ),
		'etc'		=> array( 'tabs'	=> $p['gruppi.form']['etc']['tabs'] ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) )
	);

 	// vista categorie anagrafica
	$p['categorie.anagrafica.view'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'categorie' ),
	    'h1'		=> array( $l		=> 'categorie' ),
	    'parent'		=> array( 'id'		=> 'anagrafica.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'		=> array( '_src/_inc/_macro/_categorie.anagrafica.view.php' ),
		'etc'		=> array( 'tabs'	=> array( 'categorie.anagrafica.view' ) ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'menu'		=> array( 'admin'	=> array(	'label'		=> array( $l => 'categorie' ),
									'priority'	=> '010' ) )
	);

    // form categorie anagrafica
	$p['categorie.anagrafica.form'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'categorie.anagrafica.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.anagrafica.form.html' ),
		'macro'		=> array( '_src/_inc/_macro/_categorie.anagrafica.form.php' ),
		'etc'		=> array( 'tabs'	=> array( 'categorie.anagrafica.form',
													'categorie.anagrafica.form.membri' ) ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) )
	);
	
    // form categorie anagrafica membri
	$p['categorie.anagrafica.form.membri'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'membri' ),
	    'h1'		=> array( $l		=> 'membri' ),
	    'parent'		=> array( 'id'		=> 'categorie.anagrafica.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.anagrafica.form.membri.html' ),
		'macro'		=> array( '_src/_inc/_macro/_categorie.anagrafica.form.membri.php' ),
		'etc'		=> array( 'tabs'	=> $p['categorie.anagrafica.form']['etc']['tabs'] ),
		'auth'		=> array( 'groups'	=> array(	'roots' ) )
	);

?>
