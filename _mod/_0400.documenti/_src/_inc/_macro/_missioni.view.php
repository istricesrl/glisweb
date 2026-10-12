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
	$ct['view']['table'] = 'missioni';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'missioni.form';

    // tabella per la gestione degli oggetti esistenti
	$ct['view']['open']['table'] = 'documenti';

    // campi della vista
    $ct['view']['cols'] = array(
        'id' => '#',
        'codice' => 'cod.',
        // 'numero' => 'num.',
        // 'sezionale' => 'sez.',
        'data' => 'data',
#        'emittente' => 'emittente',
#        'destinatario' => 'destinatario',
        'nome' => 'nome',
#        '__label__' => 'nome',
        'documenti_antecedenti' => 'evade',
        'documenti_successivi' => 'controllo',
        'timestamp_chiusura' => 'chiusura',
    );

    // stili della vista
    $ct['view']['class'] = array(
        'nome' => 'text-left no-wrap',
#        'numero' => 'text-left',
        'codice' => 'no-wrap',
        'data' => 'no-wrap', 
        '__label__' => 'text-left no-wrap',
        'nome' => 'text-left no-wrap',
        'destinatario' => 'text-left no-wrap',
        'emittente' => 'text-left no-wrap',
        'tipologia' => 'text-left no-wrap',
        'totale' => 'text-right',
        'documenti_antecedenti' => 'text-left',
        'documenti_successivi' => 'text-left',
        'timestamp_chiusura' => 'no-wrap',
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
	$ct['view']['__restrict__']['timestamp_chiusura']['NL'] = true;

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    foreach( $ct['view']['data'] as $key => &$row ) {

        // $row['timestamp_chiusura'] = date( 'Y-m-d H:i', $row['timestamp_chiusura']);

	}