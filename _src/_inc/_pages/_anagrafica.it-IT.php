<?php

    // lingua di questo file
	$l = 'it-IT';

    // vista anagrafica
	$p['anagrafica.view']	= array(
	    'sitemap'			=> false,
	    'title'				=> array( $l		=> 'anagrafica' ),
	    'h1'				=> array( $l		=> 'anagrafica' ),
	    'parent'			=> array( 'id'		=> NULL ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'				=> array( '_src/_inc/_macro/_anagrafica.view.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> array(	'anagrafica.view',
															'anagrafica.archivio.view',
															'anagrafica.stampe',
															'anagrafica.tools' ) ),
	    'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'anagrafica' ),
																			'priority'	=> '050' ) ) )
	);

    // vista archivio anagrafica
	$p['anagrafica.archivio.view'] = array(
	    'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-archive" aria-hidden="true"></i>',
		'title'				=> array( $l		=> 'archivio' ),
	    'h1'				=> array( $l		=> 'archivio' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'				=> array( '_src/_inc/_macro/_anagrafica.archivio.view.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['anagrafica.view']['etc']['tabs'] )
	);

	// stampe anagrafica
	$p['anagrafica.stampe'] = array(
	    'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-print" aria-hidden="true"></i>',
		'title'				=> array( $l		=> 'stampe' ),
	    'h1'				=> array( $l		=> 'stampe' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'				=> array( '_src/_inc/_macro/_anagrafica.stampe.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['anagrafica.view']['etc']['tabs'] )
	);

    // tools anagrafica
	$p['anagrafica.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'				=> array( '_src/_inc/_macro/_anagrafica.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['anagrafica.view']['etc']['tabs'] )
	);

    // gestione anagrafica
	$p['anagrafica.form'] = array(
	    'sitemap'			=> false,
	    'title'				=> array( $l		=> 'gestione' ),
	    'h1'				=> array( $l		=> 'gestione' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'anagrafica.form.html' ),
	    'macro'				=> array( '_src/_inc/_macro/_anagrafica.form.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> array(	'anagrafica.form',
															'anagrafica.form.informazioni',
															'anagrafica.form.relazioni',
// questa scheda va attivata se è attivo il modulo certificazioni
//															'anagrafica.form.certificazioni',
															'anagrafica.form.amministrazione',
//															'anagrafica.form.collaboratori',
// questa scheda va attivata se è attivo il modulo contratti
//															'anagrafica.form.contratti',
															'anagrafica.form.cliente',
															'anagrafica.form.fornitore',
															'anagrafica.form.collaboratore',
//															'anagrafica.form.struttura',
//															'anagrafica.form.attivita',
//															'anagrafica.form.promemoria',
															'anagrafica.form.immagini',
															'anagrafica.form.video',
															'anagrafica.form.audio',
															'anagrafica.form.file',
															'anagrafica.form.metadati',
															'anagrafica.form.archiviazione',
															'anagrafica.form.stampe',
															'anagrafica.form.tools' ) )
	);

	// RELAZIONI CON IL MODULO CERTIFICAZIONI
	if( in_array( "6700.certificazioni", $cf['mods']['active']['array'] ) ) {
		arrayInsertSeq( 'anagrafica.form.relazioni', $p['anagrafica.form']['etc']['tabs'], 'anagrafica.form.certificazioni' );
	}

	// RELAZIONI CON IL MODULO TESSERAMENTI
	if( in_array( "0620.tesseramenti", $cf['mods']['active']['array'] ) ) {
		arrayInsertBefore( 'anagrafica.form.immagini', $p['anagrafica.form']['etc']['tabs'], 'anagrafica.form.tesseramenti' );
	}

	// RELAZIONI CON IL MODULO ISCRIZIONI
	if( in_array( "0630.iscrizioni", $cf['mods']['active']['array'] ) ) {
		arrayInsertBefore( 'anagrafica.form.immagini', $p['anagrafica.form']['etc']['tabs'], 'anagrafica.form.iscrizioni' );
	}

	// RELAZIONI CON IL MODULO ABBONAMENTI
	if( in_array( "0640.abbonamenti", $cf['mods']['active']['array'] ) ) {
		arrayInsertBefore( 'anagrafica.form.immagini', $p['anagrafica.form']['etc']['tabs'], 'anagrafica.form.abbonamenti' );
	}

	// RELAZIONI CON IL MODULO AGENDA
	if( in_array( "0200.attivita", $cf['mods']['active']['array'] ) ) {
		arrayInsertBefore( 'anagrafica.form.immagini', $p['anagrafica.form']['etc']['tabs'], 'anagrafica.form.attivita' );
	}

    // gestione anagrafica informazioni
	$p['anagrafica.form.informazioni'] = array(
	    'sitemap'			=> false,
	    'title'				=> array( $l		=> 'informazioni' ),
	    'h1'				=> array( $l		=> 'informazioni' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'anagrafica.form.informazioni.html' ),
	    'macro'				=> array( '_src/_inc/_macro/_anagrafica.form.informazioni.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['anagrafica.form']['etc']['tabs'] )
	);

	 // gestione anagrafica amministrazione
	 $p['anagrafica.form.amministrazione'] = array(
	    'sitemap'			=> false,
	    'title'				=> array( $l		=> 'amministrazione' ),
	    'h1'				=> array( $l		=> 'amministrazione' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'anagrafica.form.amministrazione.html' ),
	    'macro'				=> array( '_src/_inc/_macro/_anagrafica.form.amministrazione.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['anagrafica.form']['etc']['tabs'] )
	);

	// gestione anagrafica cliente
	$p['anagrafica.form.cliente'] = array(
	    'sitemap'			=> false,
	    'title'				=> array( $l		=> 'cliente' ),
	    'h1'				=> array( $l		=> 'cliente' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'anagrafica.form.cliente.html' ),
	    'macro'				=> array( '_src/_inc/_macro/_anagrafica.form.cliente.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['anagrafica.form']['etc']['tabs'] )
	);

	// gestione anagrafica contratti
	$p['anagrafica.form.contratti'] = array(
	    'sitemap'			=> false,
	    'title'				=> array( $l		=> 'elenco contratti' ),
	    'h1'				=> array( $l		=> 'contratti' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'anagrafica.form.contratti.html' ),
	    'macro'				=> array( '_src/_inc/_macro/_anagrafica.form.contratti.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['anagrafica.form']['etc']['tabs'] )
	);

	// gestione anagrafica fornitore
	$p['anagrafica.form.fornitore'] = array(
	    'sitemap'			=> false,
	    'title'				=> array( $l		=> 'fornitore' ),
	    'h1'				=> array( $l		=> 'fornitore' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'anagrafica.form.fornitore.html' ),
	    'macro'				=> array( '_src/_inc/_macro/_anagrafica.form.fornitore.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['anagrafica.form']['etc']['tabs'] )
	);

	// gestione anagrafica collaboratore
	$p['anagrafica.form.collaboratore'] = array(
	    'sitemap'			=> false,
	    'title'				=> array( $l		=> 'collaboratore' ),
	    'h1'				=> array( $l		=> 'collaboratore' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'anagrafica.form.collaboratore.html' ),
	    'macro'				=> array( '_src/_inc/_macro/_anagrafica.form.collaboratore.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['anagrafica.form']['etc']['tabs'] )
	);

	// gestione anagrafica dipendente
	$p['anagrafica.form.dipendente'] = array(
	    'sitemap'			=> false,
	    'title'				=> array( $l		=> 'dipendente' ),
	    'h1'				=> array( $l		=> 'dipendente' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'anagrafica.form.dipendente.html' ),
	    'macro'				=> array( '_src/_inc/_macro/_anagrafica.form.dipendente.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['anagrafica.form']['etc']['tabs'] )
	);

	// gestione anagrafica dipendente
	$p['anagrafica.form.relazioni'] = array(
	    'sitemap'			=> false,
	    'title'				=> array( $l		=> 'relazioni' ),
	    'h1'				=> array( $l		=> 'relazioni' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'anagrafica.form.relazioni.html' ),
	    'macro'				=> array( '_src/_inc/_macro/_anagrafica.form.relazioni.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['anagrafica.form']['etc']['tabs'] )
	);

	// gestione anagrafica metadati
	$p['anagrafica.form.metadati'] = array(
	    'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-code" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'metadati' ),
	    'h1'				=> array( $l		=> 'metadati' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'anagrafica.form.metadati.html' ),
	    'macro'				=> array( '_src/_inc/_macro/_anagrafica.form.metadati.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['anagrafica.form']['etc']['tabs'] )
	);

	// gestione anagrafica archiviazione
	$p['anagrafica.form.archiviazione'] = array(
	    'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-archive" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'archiviazione' ),
	    'h1'				=> array( $l		=> 'archiviazione' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'anagrafica.form.archiviazione.html' ),
	    'macro'				=> array( '_src/_inc/_macro/_anagrafica.form.archiviazione.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['anagrafica.form']['etc']['tabs'] )
	);

	// gestione anagrafica stampe
	$p['anagrafica.form.stampe'] = array(
	    'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-print" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'stampe_anagrafica' ),
	    'h1'				=> array( $l		=> 'stampe' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'				=> array( '_src/_inc/_macro/_anagrafica.form.stampe.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['anagrafica.form']['etc']['tabs'] )
	);

    // gestione tools anagrafica
	$p['anagrafica.form.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni anagrafica' ),
	    'h1'				=> array( $l		=> 'azioni anagrafica' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'				=> array( '_src/_inc/_macro/_anagrafica.form.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['anagrafica.form']['etc']['tabs'] )
	);

	// gestione anagrafica file
	$p['anagrafica.form.file'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-folder-open-o" aria-hidden="true"></i>',
		'title'				=> array( $l		=> 'file' ),
		'h1'				=> array( $l		=> 'file' ),
		'parent'			=> array( 'id'		=> 'anagrafica.view' ),
		'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'anagrafica.form.file.html' ),
		'macro'				=> array( '_src/_inc/_macro/_anagrafica.form.file.php' ),
		'auth'				=> array( 'groups'	=> array(	'roots' ) ),
		'etc'				=> array( 'tabs'	=> $p['anagrafica.form']['etc']['tabs'] )
	);

	// gestione anagrafica video
	$p['anagrafica.form.video'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-video-camera" aria-hidden="true"></i>',
		'title'				=> array( $l		=> 'video' ),
		'h1'				=> array( $l		=> 'video' ),
		'parent'			=> array( 'id'		=> 'anagrafica.view' ),
		'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'anagrafica.form.video.html' ),
		'macro'				=> array( '_src/_inc/_macro/_anagrafica.form.video.php' ),
		'auth'				=> array( 'groups'	=> array(	'roots' ) ),
		'etc'				=> array( 'tabs'	=> $p['anagrafica.form']['etc']['tabs'] )
	);

	// gestione anagrafica audio
	$p['anagrafica.form.audio'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-volume-up" aria-hidden="true"></i>',
		'title'				=> array( $l		=> 'audio' ),
		'h1'				=> array( $l		=> 'audio' ),
		'parent'			=> array( 'id'		=> 'anagrafica.view' ),
		'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'anagrafica.form.audio.html' ),
		'macro'				=> array( '_src/_inc/_macro/_anagrafica.form.audio.php' ),
		'auth'				=> array( 'groups'	=> array(	'roots' ) ),
		'etc'				=> array( 'tabs'	=> $p['anagrafica.form']['etc']['tabs'] )
	);

	// gestione anagrafica immagini
	$p['anagrafica.form.immagini'] = array(
	    'sitemap'			=> false,
	    'icon'				=> '<i class="fa fa-picture-o" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'immagini' ),
	    'h1'				=> array( $l		=> 'immagini' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'anagrafica.form.immagini.html' ),
	    'macro'				=> array( '_src/_inc/_macro/_anagrafica.form.immagini.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'				=> array( 'tabs'	=> $p['anagrafica.form']['etc']['tabs'] )
	);

    // vista account
	$p['account.view'] = array(
	    'sitemap'			=> false,
	    'title'				=> array( $l		=> 'account' ),
	    'h1'				=> array( $l		=> 'account' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'				=> array( '_src/_inc/_macro/_account.view.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'				=> array( 'tabs'	=> array(	'account.view' ) ),
	    'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'account' ),
																			'priority'	=> '010' ) ) )
	);

    // gestione account
	$p['account.form'] = array(
	    'sitemap'			=> false,
	    'title'				=> array( $l		=> 'gestione' ),
	    'h1'				=> array( $l		=> 'gestione' ),
	    'parent'			=> array( 'id'		=> 'account.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'account.form.html' ),
	    'macro'				=> array( '_src/_inc/_macro/_account.form.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'				=> array( 'tabs'	=> array(	'account.form',
															'account.form.attribuzione',
															'crediti.account.view' ) )
	);

	// RELAZIONI CON IL MODULO CREDITI
	if( in_array( "0530.crediti", $cf['mods']['active']['array'] ) ) {
		
		// vista crediti account
		$p['crediti.account.view'] = array(
			'sitemap'			=> false,
			'title'				=> array( $l		=> 'crediti' ),
			'h1'				=> array( $l		=> 'crediti' ),
			'parent'			=> array( 'id'		=> 'account.form' ),
			'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
			'macro'				=> array( '_src/_inc/_macro/_crediti.account.view.php' ),
			'auth'				=> array( 'groups'	=> array(	'roots' ) ),
			'etc'				=> array( 'tabs'	=> $p['account.form']['etc']['tabs'] )
		);

	}

	// gestione account attribuzione
	$p['account.form.attribuzione'] = array(
	    'sitemap'			=> false,
	    'title'				=> array( $l		=> 'attribuzione' ),
	    'h1'				=> array( $l		=> 'attribuzione' ),
	    'parent'			=> array( 'id'		=> 'gruppi.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'account.form.attribuzione.html' ),
		'macro'				=> array( '_src/_inc/_macro/_account.form.attribuzione.php' ),
		'auth'				=> array( 'groups'	=> array(	'roots' ) ),
		'etc'				=> array( 'tabs'	=> $p['account.form']['etc']['tabs'] )
	);

	// vista gruppi
	 $p['gruppi.view'] = array(
	    'sitemap'			=> false,
	    'title'				=> array( $l		=> 'gruppi' ),
	    'h1'				=> array( $l		=> 'gruppi' ),
	    'parent'			=> array( 'id'		=> 'account.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'				=> array( '_src/_inc/_macro/_gruppi.view.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'				=> array( 'tabs'	=> array(	'gruppi.view' ) ),
	    'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'gruppi' ),
																			'priority'	=> '120' ) ) )
	);

    // gestione gruppi
	$p['gruppi.form'] = array(
	    'sitemap'			=> false,
	    'title'				=> array( $l		=> 'gestione' ),
	    'h1'				=> array( $l		=> 'gestione' ),
	    'parent'			=> array( 'id'		=> 'gruppi.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'gruppi.form.html' ),
	    'macro'				=> array( '_src/_inc/_macro/_gruppi.form.php' ),
		'auth'				=> array( 'groups'	=> array(	'roots' ) ),
		'etc'				=> array( 'tabs'	=> array(	'gruppi.form',
															'gruppi.form.membri' ) )
	);

	// gestione membri gruppi
	$p['gruppi.form.membri'] = array(
		'sitemap'			=> false,
		'title'				=> array( $l		=> 'membri' ),
		'h1'				=> array( $l		=> 'membri' ),
		'parent'			=> array( 'id'		=> 'gruppi.view' ),
		'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'gruppi.form.membri.html' ),
		'macro'				=> array( '_src/_inc/_macro/_gruppi.form.membri.php' ),
		'auth'				=> array( 'groups'	=> array(	'roots' ) ),
		'etc'				=> array( 'tabs'	=> $p['gruppi.form']['etc']['tabs'] )
	);

 	// vista categorie anagrafica
	$p['categorie.anagrafica.view'] = array(
	    'sitemap'			=> false,
	    'title'				=> array( $l		=> 'categorie' ),
	    'h1'				=> array( $l		=> 'categorie' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'				=> array( '_src/_inc/_macro/_categorie.anagrafica.view.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots' ) ),
		'etc'				=> array( 'tabs'	=> array(	'categorie.anagrafica.view' ) ),
	    'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'categorie' ),
																			'priority'	=> '010' ) ) )
	);

    // form categorie anagrafica
	$p['categorie.anagrafica.form'] = array(
	    'sitemap'			=> false,
	    'title'				=> array( $l		=> 'gestione' ),
	    'h1'				=> array( $l		=> 'gestione' ),
	    'parent'			=> array( 'id'		=> 'categorie.anagrafica.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.anagrafica.form.html' ),
		'macro'				=> array( '_src/_inc/_macro/_categorie.anagrafica.form.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots' ) ),
		'etc'				=> array( 'tabs'	=> array(	'categorie.anagrafica.form',
															'categorie.anagrafica.form.membri',
															'categorie.anagrafica.form.tools' ) )
	);

    // form categorie anagrafica membri
	$p['categorie.anagrafica.form.membri'] = array(
	    'sitemap'			=> false,
	    'title'				=> array( $l		=> 'membri' ),
	    'h1'				=> array( $l		=> 'membri' ),
	    'parent'			=> array( 'id'		=> 'categorie.anagrafica.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'categorie.anagrafica.form.membri.html' ),
		'macro'				=> array( '_src/_inc/_macro/_categorie.anagrafica.form.membri.php' ),
		'auth'				=> array( 'groups'	=> array(	'roots' ) ),
		'etc'				=> array( 'tabs'	=> $p['categorie.anagrafica.form']['etc']['tabs'] )
	);

	// form categorie anagrafica azioni
	$p['categorie.anagrafica.form.tools'] = array(
	    'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni categoria anagrafica' ),
	    'h1'				=> array( $l		=> 'azioni categoria anagrafica' ),
	    'parent'			=> array( 'id'		=> 'categorie.anagrafica.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'				=> array( '_src/_inc/_macro/_categorie.anagrafica.form.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'				=> array( 'tabs'	=> $p['categorie.anagrafica.form']['etc']['tabs'] )
	);

	// vista indirizzi
	$p['indirizzi.view'] = array(
		'sitemap'			=> false,
		'title'				=> array( $l		=> 'indirizzi' ),
		'h1'				=> array( $l		=> 'indirizzi' ),
		'parent'			=> array( 'id'		=> 'anagrafica.archivio.view' ),
		'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'				=> array( '_src/_inc/_macro/_indirizzi.view.php' ),
		'auth'				=> array( 'groups'	=> array(	'roots' ) ),
		'etc'				=> array( 'tabs'	=> array( 'indirizzi.view' ) ),
	    'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'indirizzi' ),
																			'priority'	=> '130' ) ) )
	);

	// gestione indirizzi 
	$p['indirizzi.form'] = array(
		'sitemap'			=> false,
		'title'				=> array( $l		=> 'gestione' ),
		'h1'				=> array( $l		=> 'gestione' ),
		'parent'			=> array( 'id'		=> 'anagrafica.archivio.view' ),
		'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'indirizzi.form.html' ),
		'macro'				=> array( '_src/_inc/_macro/_indirizzi.form.php' ),
		'auth'				=> array( 'groups'	=> array(	'roots' ) ),
		'etc'				=> array( 'tabs'	=> array( 	'indirizzi.form'	) )
		
	);

	// vista ranking anagrafica
	$p['ranking.anagrafica.view'] = array(
	    'sitemap'			=> false,
	    'title'				=> array( $l		=> 'ranking' ),
	    'h1'				=> array( $l		=> 'ranking' ),
	    'parent'			=> array( 'id'		=> 'anagrafica.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		'macro'				=> array( '_src/_inc/_macro/_ranking.anagrafica.view.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots' ) ),
		'etc'				=> array( 'tabs'	=> array( 'ranking.anagrafica.view' ) ),
	    'menu'				=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'ranking' ),
																			'priority'	=> '020' ) ) )
	);

    // form ranking anagrafica
	$p['ranking.anagrafica.form'] = array(
	    'sitemap'			=> false,
	    'title'				=> array( $l		=> 'gestione' ),
	    'h1'				=> array( $l		=> 'gestione' ),
	    'parent'			=> array( 'id'		=> 'ranking.anagrafica.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'ranking.anagrafica.form.html' ),
		'macro'				=> array( '_src/_inc/_macro/_ranking.anagrafica.form.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots' ) ),
		'etc'				=> array( 'tabs'	=> array(	'ranking.anagrafica.form',
															'ranking.anagrafica.form.membri',
															'ranking.anagrafica.form.tools' ) )
	);

    // form ranking anagrafica membri
	$p['ranking.anagrafica.form.membri'] = array(
	    'sitemap'			=> false,
	    'title'				=> array( $l		=> 'membri' ),
	    'h1'				=> array( $l		=> 'membri' ),
	    'parent'			=> array( 'id'		=> 'ranking.anagrafica.view' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'ranking.anagrafica.form.membri.html' ),
		'macro'				=> array( '_src/_inc/_macro/_ranking.anagrafica.form.membri.php' ),
		'auth'				=> array( 'groups'	=> array(	'roots' ) ),
		'etc'				=> array( 'tabs'	=> $p['ranking.anagrafica.form']['etc']['tabs'] )
	);

	// form ranking anagrafica azioni
	$p['ranking.anagrafica.form.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
		'title'				=> array( $l		=> 'azioni ranking anagrafica' ),
		'h1'				=> array( $l		=> 'azioni ranking anagrafica' ),
		'parent'			=> array( 'id'		=> 'ranking.anagrafica.view' ),
		'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
		'macro'				=> array( '_src/_inc/_macro/_ranking.anagrafica.form.tools.php' ),
		'auth'				=> array( 'groups'	=> array(	'roots' ) ),
		'etc'				=> array( 'tabs'	=> $p['ranking.anagrafica.form']['etc']['tabs'] )
	);
	