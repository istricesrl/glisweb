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
									'priority'	=> 50 ) )
	);

    // vista archivio anagrafica
	$p['anagrafica.archivio.view'] = array(
	    'sitemap'		=> false,
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
									'anagrafica.form.collaboratori',
									'anagrafica.form.clienti',
									'anagrafica.form.fornitori',
									'anagrafica.form.struttura',
									'anagrafica.form.attivita',
									'anagrafica.form.promemoria',
									'anagrafica.form.immagini',
									'anagrafica.form.archiviazione',
									'anagrafica.form.stampe' ) )
	);

    // gestione anagrafica
	$p['anagrafica.form.informazioni'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'informazioni' ),
	    'h1'		=> array( $l		=> 'informazioni' ),
	    'parent'		=> array( 'id'		=> 'anagrafica.form' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'anagrafica.form.informazioni.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_anagrafica.form.informazioni.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'		=> array( 'tabs'	=> $p['anagrafica.form']['etc']['tabs'] )
	);

/*
    // scheda bibliografia
	if( in_array( '3100.notizie', $cf['mods']['active']['array'] ) || in_array( '3200.stampa', $cf['mods']['active']['array'] )|| in_array( '3500.documenti', $cf['mods']['active']['array'] ) ) {
	    arrayInsertSeq( 'anagrafica_gestione_stampe', $p['anagrafica_gestione']['etc']['tabs'], array( 'anagrafica_gestione_contenuti' ) );
	}

    // scheda offerte
	if( in_array( '2200.offerte', $cf['mods']['active']['array'] ) ) {
	    arrayInsertSeq( 'anagrafica_gestione_clienti', $p['anagrafica_gestione']['etc']['tabs'], array( 'anagrafica_gestione_offerte' ) );
	}

    // scheda immobili
	if( in_array( '5000.immobiliare', $cf['mods']['active']['array'] ) ) {
	    arrayInsertSeq( 'anagrafica_gestione_struttura', $p['anagrafica_gestione']['etc']['tabs'], array( 'anagrafica_gestione_immobili' ) );
	}

    // scheda richieste immobili
	if( in_array( '5000.immobiliare', $cf['mods']['active']['array'] ) ) {
	    arrayInsertSeq( 'anagrafica_gestione_immobili', $p['anagrafica_gestione']['etc']['tabs'], array( 'anagrafica_gestione_richieste_immobili' ) );
	}

    // scheda fatturati
	if( in_array( '6400.fatturati', $cf['mods']['active']['array'] ) ) {
	    arrayInsertSeq( 'anagrafica_gestione_fornitori', $p['anagrafica_gestione']['etc']['tabs'], array( 'anagrafica_gestione_fatturati' ) );
	}

    // scheda pratiche
	if( in_array( '1400.pratiche', $cf['mods']['active']['array'] ) ) {
	    arrayInsertSeq( 'anagrafica_gestione_struttura', $p['anagrafica_gestione']['etc']['tabs'], array( 'anagrafica_gestione_pratiche' ) );
	    arrayInsertSeq( 'anagrafica_gestione_informazioni', $p['anagrafica_gestione']['etc']['tabs'], array( 'anagrafica_gestione_diritti' ) );
	}

    // gestione collaboratori anagrafica
	$p['anagrafica_gestione_collaboratori'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'collaboratore' ),
	    'h1'		=> array( $l		=> 'collaboratore' ),
	    'parent'		=> array( 'id'		=> 'anagrafica' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'anagrafica.gestione.collaboratori.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_anagrafica.gestione.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> $p['anagrafica_gestione']['etc']['tabs'] )
	);

    // gestione clienti anagrafica
	$p['anagrafica_gestione_clienti'] = array(
	    'sitemap'		=> false,
#	    'icon'		=> '<i class="fa fa-money" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'cliente' ),
	    'h1'		=> array( $l		=> 'cliente' ),
	    'parent'		=> array( 'id'		=> 'anagrafica' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'anagrafica.gestione.clienti.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_anagrafica.gestione.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> $p['anagrafica_gestione']['etc']['tabs'] )
	);

    // gestione clienti anagrafica
	$p['anagrafica_gestione_contenuti'] = array(
	    'sitemap'		=> false,
	    'icon'		=> '<i class="fa fa-book" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'bibliografia' ),
	    'h1'		=> array( $l		=> 'bibliografia' ),
	    'parent'		=> array( 'id'		=> 'anagrafica' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'anagrafica.gestione.contenuti.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_anagrafica.gestione.contenuti.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> $p['anagrafica_gestione']['etc']['tabs'] )
	);

    // gestione fornitori anagrafica
	$p['anagrafica_gestione_fornitori'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'fornitore' ),
	    'h1'		=> array( $l		=> 'fornitore' ),
	    'parent'		=> array( 'id'		=> 'anagrafica' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'anagrafica.gestione.fornitori.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_anagrafica.gestione.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> $p['anagrafica_gestione']['etc']['tabs'] )
	);

    // gestione informazioni anagrafica
	$p['anagrafica_gestione_informazioni'] = array(
	    'sitemap'		=> false,
#	    'icon'		=> '<i class="fa fa-user" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'informazioni' ),
	    'h1'		=> array( $l		=> 'informazioni' ),
	    'parent'		=> array( 'id'		=> 'anagrafica' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'anagrafica.gestione.informazioni.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_anagrafica.gestione.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> $p['anagrafica_gestione']['etc']['tabs'] )
	);

    // gestione specialità diritti
	$p['anagrafica_gestione_diritti'] = array(
	    'sitemap'		=> false,
#	    'icon'		=> '<i class="fa fa-user" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'diritti' ),
	    'h1'		=> array( $l		=> 'diritti' ),
	    'parent'		=> array( 'id'		=> 'anagrafica' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'anagrafica.gestione.diritti.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_anagrafica.gestione.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> $p['anagrafica_gestione']['etc']['tabs'] )
	);

    // gestione dati amministrativi anagrafica
	$p['anagrafica_gestione_amministrazione'] = array(
	    'sitemap'		=> false,
#	    'icon'		=> '<i class="fa fa-briefcase" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'amministrazione' ),
	    'h1'		=> array( $l		=> 'amministrazione' ),
	    'parent'		=> array( 'id'		=> 'anagrafica' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'anagrafica.gestione.amministrazione.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_anagrafica.gestione.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> $p['anagrafica_gestione']['etc']['tabs'] )
	);

    // gestione struttura anagrafica
	$p['anagrafica_gestione_struttura'] = array(
	    'sitemap'		=> false,
#	    'icon'		=> '<i class="fa fa-sitemap" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'struttura' ),
	    'h1'		=> array( $l		=> 'struttura' ),
	    'parent'		=> array( 'id'		=> 'anagrafica' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'anagrafica.gestione.struttura.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_anagrafica.gestione.php', '_src/_inc/_macro/_anagrafica.gestione.struttura.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> $p['anagrafica_gestione']['etc']['tabs'] )
	);

    // gestione archiviazione anagrafica
	$p['anagrafica_gestione_archiviazione'] = array(
	    'sitemap'		=> false,
	    'icon'		=> '<i class="fa fa-archive" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'archiviazione' ),
	    'h1'		=> array( $l		=> 'archiviazione' ),
	    'parent'		=> array( 'id'		=> 'anagrafica' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'anagrafica.gestione.archiviazione.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_anagrafica.gestione.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> $p['anagrafica_gestione']['etc']['tabs'] )
	);



    // gestione attività anagrafica
	$p['anagrafica_gestione_attivita'] = array(
	    'sitemap'		=> false,
	    'icon'		=> '<i class="fa fa-list-ul" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'attività' ),
	    'h1'		=> array( $l		=> 'attività' ),
	    'parent'		=> array( 'id'		=> 'anagrafica' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'anagrafica.gestione.attivita.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_anagrafica.gestione.attivita.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> $p['anagrafica_gestione']['etc']['tabs'] )
	);

    // gestione attività promemoria
	$p['anagrafica_gestione_promemoria'] = array(
	    'sitemap'		=> false,
	    'icon'		=> '<i class="fa fa-calendar" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'promemoria' ),
	    'h1'		=> array( $l		=> 'promemoria' ),
	    'parent'		=> array( 'id'		=> 'anagrafica' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'anagrafica.gestione.promemoria.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_anagrafica.gestione.attivita.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> $p['anagrafica_gestione']['etc']['tabs'] )
	);

    // gestione immagini anagrafica
	$p['anagrafica_gestione_immagini'] = array(
	    'sitemap'		=> false,
	    'icon'		=> '<i class="fa fa-picture-o" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'immagini' ),
	    'h1'		=> array( $l		=> 'immagini' ),
	    'parent'		=> array( 'id'		=> 'anagrafica' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'anagrafica.gestione.immagini.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_anagrafica.gestione.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> $p['anagrafica_gestione']['etc']['tabs'] )
	);

    // gestione immagini anagrafica
	$p['anagrafica_gestione_stampe'] = array(
	    'sitemap'		=> false,
	    'icon'		=> '<i class="fa fa-print" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'stampe' ),
	    'h1'		=> array( $l		=> 'stampe' ),
	    'parent'		=> array( 'id'		=> 'anagrafica' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'metro.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_anagrafica.gestione.stampe.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> $p['anagrafica_gestione']['etc']['tabs'] )
	);
*/

    // vista account
	$p['account.view'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'account' ),
	    'h1'		=> array( $l		=> 'account' ),
	    'parent'		=> array( 'id'		=> 'anagrafica.view' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_account.view.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'menu'		=> array( 'admin'	=> array(	'label'		=> array( $l => 'account' ),
									'priority'	=> 100 ) )
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
								  'account.form.tools' ) ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) )
	);

/*
    // gestione account - azioni
	$p['account_gestione_azioni'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'azioni' ),
	    'h1'		=> array( $l		=> 'azioni' ),
	    'parent'		=> array( 'id'		=> 'account' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'metro.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_account.gestione.azioni.php' ),
	    'etc'		=> array( 'tabs'	=>$p['account_gestione']['etc']['tabs'] ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) )
	);

    // vista gruppi
	$p['gruppi'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gruppi' ),
	    'h1'		=> array( $l		=> 'gruppi' ),
	    'parent'		=> array( 'id'		=> 'account' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'view.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_gruppi.view.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'menu'		=> array( 'admin'	=> array(	'label'		=> array( $l => 'gruppi' ),
									'priority'	=> 120 ) )
	);

    // gestione gruppi
	$p['gruppi_gestione'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'gruppi' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'gruppi.gestione.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_gruppi.gestione.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> array( 'gruppi_gestione', 'gruppi_gestione_account' ) )
	);

	$p['gruppi_gestione_account'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'membri' ),
	    'h1'		=> array( $l		=> 'membri' ),
	    'parent'		=> array( 'id'		=> 'gruppi' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'gruppi.gestione.account.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_gruppi.gestione.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'etc'		=> array( 'tabs'	=> $p['gruppi_gestione']['etc']['tabs'] )
	);

    // vista categorie anagrafica
	$p['categorie_anagrafica'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'categorie' ),
	    'h1'		=> array( $l		=> 'categorie' ),
	    'parent'		=> array( 'id'		=> 'anagrafica' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'view.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_categorie.anagrafica.view.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'menu'		=> array( 'admin'	=> array(	'label'		=> array( $l => 'categorie' ),
									'priority'	=> 600 ) )
	);

    // gestione categorie anagrafica
	$p['categorie_anagrafica_gestione'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'categorie_anagrafica' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'categorie.anagrafica.gestione.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_categorie.anagrafica.gestione.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) )
	);

    // vista tipologie crm
	$p['tipologie_crm'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'ranking CRM' ),
	    'h1'		=> array( $l		=> 'ranking CRM' ),
	    'parent'		=> array( 'id'		=> 'anagrafica' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'view.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_tipologie.crm.view.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) ),
	    'menu'		=> array( 'admin'	=> array(	'label'		=> array( $l => 'ranking' ),
									'priority'	=> 700 ) )
	);

    // gestione tipologie crm
	$p['tipologie_crm_gestione'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'gestione' ),
	    'h1'		=> array( $l		=> 'gestione' ),
	    'parent'		=> array( 'id'		=> 'tipologie_crm' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_standard/', 'schema' => 'tipologie.crm.gestione.html' ),
	    'macro'		=> array( '_src/_inc/_macro/_tipologie.crm.gestione.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots' ) )
	);
*/
?>
