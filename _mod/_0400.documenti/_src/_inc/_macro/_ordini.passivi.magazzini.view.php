<?php

    /**
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     * @todo finire di documentare
     *
     * @file
     *
     */

    // tabella della vista
	$ct['view']['table'] = 'ordini_passivi';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'ordini.passivi.magazzini.form';

    // tabella per la gestione degli oggetti esistenti
	$ct['view']['open']['table'] = 'documenti';

    // campi della vista
    $ct['view']['cols'] = array(
        'id' => '#',
        'codice' => 'cod.',
        'numero' => 'num.',
        'sezionale' => 'sez.',
        'data' => 'data',
        'emittente' => 'emittente',
#        'destinatario' => 'destinatario',
        'nome' => 'nome',
        'data_ora_chiusura' => 'data chiusura',
#        '__label__' => 'nome',
    );

    // stili della vista
    $ct['view']['class'] = array(
        'nome' => 'text-left',
#        'numero' => 'text-left',
        'data' => 'no-wrap', 
        'nome' => 'text-left',
        '__label__' => 'text-left',
        'destinatario' => 'text-left',
        'emittente' => 'text-left',
        'tipologia' => 'text-left',
        'totale' => 'text-right' 
    );

    // tendina mittenti
	$ct['etc']['select']['id_emittenti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id   , __label__ FROM anagrafica_view_static WHERE se_gestita = 1 ORDER BY __label__'
	);

	/**
	 * tendina id_destinatari — disattivata il 2026-10-12, il campo ha gia' la ricerca REST
	 *
	 * Era `SELECT id, __label__ FROM anagrafica_view_static ORDER BY __label__` senza WHERE: sui deploy con l'anagrafica grande ( Polmasi:
	 * oltre 55.000 righe ) supera il tetto di 1 MB di memcached, la scrittura in cache fallisce
	 * con l'errore 37 e la query si rifa' a ogni apertura della pagina.
	 *
	 * Non serviva: nei template di questa pagina il campo e' reso da `frm.selectBox()` con l'api
	 * `anagrafica`, che non stampa le `<option>` e cerca via REST ( _src/_js/_lib/_selectbox.js ).
	 */
	$ct['etc']['select']['id_destinatari'] = array();

    // inclusione filtri speciali
//	$ct['etc']['include']['filters'] = 'inc/ddt.magazzini.view.filters.html';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    foreach( $ct['view']['data'] as $key => &$row ) {

        // $row['timestamp_chiusura'] = date( 'Y-m-d H:i', $row['timestamp_chiusura']);

	}