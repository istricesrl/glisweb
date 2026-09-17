<?php

	// lingua di questo file
	$l = 'it-IT';

    // modulo di questo file
	$m = DIR_MOD . '_5000.logistica/';

	// dashboard logistica
	$p['logistica'] = array(
	    'sitemap'		=> false,
	    'title'			=> array( $l		=> 'logistica' ),
	    'h1'			=> array( $l		=> 'logistica' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'template'		=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'logistica.html' ),
		'macro'			=> array( $m . '_src/_inc/_macro/_logistica.php' ),
		'etc'			=> array( 'tabs'	=> array(	'logistica', 'logistica.tools' ) ),
	    'auth'			=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'menu'			=> array( 'admin'	=> array(	'' => 	array(	'label'		=> array( $l => 'logistica' ),
														'priority'	=> '320' ) ) )
	);

	/**
	 * LA SCHEDA C'E' SOLO DOVE IL SOTTOSCORTA E' DICHIARATO ( 17/09/2026 )
	 *
	 * La scheda non calcola niente: mostra __report_sottoscorta__, che riscrive il task
	 * _mod/_0500.mastri/_src/_api/_task/_rifornimenti.da.sottoscorta.php. Dove quel task non e'
	 * configurato la tabella non c'e' nemmeno ( nasce col patch _202609171000 ), e una linguetta
	 * che apre una vista su una tabella inesistente e' un errore SQL in faccia all'utente.
	 *
	 * Si guarda la configurazione dell'automazione e non la presenza della tabella perche' un file
	 * di _inc/_pages/ non interroga il database: qui dentro non c'e' una sola query in tutto il
	 * framework, e metterne una costerebbe un giro a ogni richiesta per rispondere sempre lo stesso.
	 * Il ramo ['profile'] lo compone _src/_config/_705.automazioni.php dal profilo dell'ambiente
	 * corrente: se il progetto non dichiara il sottoscorta in src/config/700.automazioni.php, qui e'
	 * vuoto e la scheda non nasce.
	 */
	if( ! empty( $cf['automazioni']['profile']['sottoscorta'] ) ) {

		/**
		 * SCHEDA SOTTOSCORTA
		 *
		 * Elenco delle ubicazioni sorvegliate - quelle che hanno una scorta minima - con il verdetto
		 * dell'ultimo giro del task del sottoscorta: sotto soglia o no, da dove si riforniva, la
		 * missione generata oppure il motivo per cui non si e' potuto. Il contenuto sta in
		 * __report_sottoscorta__ e lo riscrive il task a ogni giro: qui non si calcola niente.
		 *
		 * NON e' una voce di menu: e' una SCHEDA della pagina magazzini, accanto a "magazzini" e
		 * "azioni". Il sottoscorta e' un modo di guardare i magazzini, non una sezione per conto suo.
		 *
		 * L'elenco delle schede va scritto su TUTTE le pagine che lo condividono: la barra si disegna
		 * leggendo etc.tabs della pagina corrente, quindi una pagina che non le elenca tutte mostra
		 * una barra diversa dalle sorelle e da li' non si torna indietro. magazzini.tools se le copia
		 * al momento della propria definizione, cioe' prima di questo file: per quello qui si
		 * riscrivono tutte invece di aggiungere in coda a una sola.
		 */
		$p['logistica.sottoscorta.view'] = array(
			'sitemap'			=> false,
		    'title'				=> array( $l		=> 'sottoscorta' ),
		    'h1'				=> array( $l		=> 'sottoscorta' ),
		    'parent'			=> array( 'id'		=> 'logistica' ),
		    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.view.html' ),
		    'macro'				=> array( $m . '_src/_inc/_macro/_logistica.sottoscorta.view.php' ),
		    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) )
		);

		// le pagine dei magazzini appartengono al modulo 0500.mastri, che si carica prima di questo.
		// L'isset() e' comunque d'obbligo: quel modulo potrebbe non esserci, e in quel caso la scheda
		// resta in piedi da sola invece di sparire.
		if( isset( $p['magazzini.view'] ) ) {

			$schedeMagazzini = array( 'magazzini.view', 'magazzini.tools', 'logistica.sottoscorta.view' );

			$p['magazzini.view']['etc']['tabs']             = $schedeMagazzini;
			$p['logistica.sottoscorta.view']['etc']['tabs'] = $schedeMagazzini;

			if( isset( $p['magazzini.tools'] ) ) {
				$p['magazzini.tools']['etc']['tabs'] = $schedeMagazzini;
			}

		} else {

			$p['logistica.sottoscorta.view']['etc']['tabs'] = array( 'logistica.sottoscorta.view' );

		}

	}

	// tools produzione
	$p['logistica.tools'] = array(
		'sitemap'			=> false,
		'icon'				=> '<i class="fa fa-cogs" aria-hidden="true"></i>',
	    'title'				=> array( $l		=> 'azioni' ),
	    'h1'				=> array( $l		=> 'azioni' ),
	    'parent'			=> array( 'id'		=> 'logistica' ),
	    'template'			=> array( 'path'	=> '_src/_templates/_athena/', 'schema' => 'default.tools.html' ),
	    'macro'				=> array( $m . '_src/_inc/_macro/_logistica.tools.php' ),
	    'auth'				=> array( 'groups'	=> array(	'roots', 'staff' ) ),
	    'etc'				=> array( 'tabs'	=> $p['logistica']['etc']['tabs'] )
	);


/*
	// pagina principale
	$p['app.logistica'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'app logistica' ),
	    'h1'		=> array( $l		=> 'app logistica' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_minerva/', 'schema' => 'app.logistica.html' ),
	    'parent'		=> array( 'id'		=> NULL ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_app.logistica.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) ),
		'menu'				=> array( 'app'	=> array(	'' => 	array(	'label'		=> array( $l => 'logistica' ),
																	'priority'	=> '020' ) ) )
	);

	// pagina principale
	$p['app.logistica.ordine'] = array(
	    'sitemap'		=> false,
		'icon'				=> '<i class="fa fa-plus" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'nuovo ordine' ),
	    'h1'		=> array( $l		=> 'crea un nuovo ordine' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_minerva/', 'schema' => 'app.logistica.nuovo.ordine.html' ),
	    'parent'		=> array( 'id'		=> 'app.logistica' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_app.logistica.nuovo.ordine.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) )
	);

	// pagina principale
	$p['app.logistica.lista.ordini'] = array(
	    'sitemap'		=> false,
		'icon'				=> '<i class="fa fa-list" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'lista ordini' ),
	    'h1'		=> array( $l		=> 'lista ordini' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_minerva/', 'schema' => 'app.logistica.lista.ordini.html' ),
	    'parent'		=> array( 'id'		=> 'app.logistica' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_app.logistica.lista.ordini.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) )
	);

	// pagina principale
	$p['app.logistica.evasione.oridne'] = array(
	    'sitemap'		=> false,
	    'title'		=> array( $l		=> 'evasione ordine' ),
	    'h1'		=> array( $l		=> 'evasione ordine' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_minerva/', 'schema' => 'app.logistica.lista.ordini.html' ),
	    'parent'		=> array( 'id'		=> 'app.logistica.lista.ordini' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_app.logistica.lista.ordini.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) )
	);
*/
/*	// pagina principale
	$p['app.logistica.ddt'] = array(
	    'sitemap'		=> false,
		'icon'				=> '<i class="fa fa-truck" aria-hidden="true"></i>',
	    'title'		=> array( $l		=> 'crea DDT' ),
	    'h1'		=> array( $l		=> 'crea DDT' ),
	    'template'		=> array( 'path'	=> '_src/_templates/_minerva/', 'schema' => 'app.logistica.nuovo.ordine.html' ),
	    'parent'		=> array( 'id'		=> 'app.logistica' ),
	    'macro'		=> array( $m . '_src/_inc/_macro/_app.logistica.nuovo.ordine.php' ),
	    'auth'		=> array( 'groups'	=> array(	'roots', 'staff' ) )
	);
*/