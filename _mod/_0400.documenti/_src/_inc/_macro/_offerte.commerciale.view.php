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

    // tabella della vista ( offerte_view_static: tutte le offerte, emesse e ricevute )
	$ct['view']['table'] = 'offerte';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'offerte.commerciale.form';

    // tabella per la gestione degli oggetti esistenti
	$ct['view']['open']['table'] = 'documenti';

    // campi della vista
    $ct['view']['cols'] = array(
        'id' => '#',
        'codice' => 'codice',
        'numero' => 'num.',
        'sezionale' => 'sez.',
        'data' => 'data',
#        'emittente' => 'emittente',
        'destinatario' => 'destinatario',
        '__label__' => 'nome'
    );

    // stili della vista
    $ct['view']['class'] = array(
        'nome' => 'text-left',
        'numero' => 'text-left',
        'data' => 'no-wrap', 
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
	    'SELECT id, __label__ FROM anagrafica_view_static WHERE se_gestita = 1 ORDER BY __label__'
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

    /**
     * SOLO LE OFFERTE ATTIVE
     *
     * Fino al 04/10/2026 l'elenco leggeva offerte_attive_view, che aveva nel WHERE
     * anagrafica_check_gestita() sull'emittente: offerte attive vuol dire emesse da noi, cioe' da
     * un'anagrafica gestita. Adesso la statica comprende tutte le offerte ( decisione di Fabio del
     * 03/10/2026 ) e il filtro lo mette l'elenco, con le stesse anagrafiche della tendina mittenti.
     * Se non ce n'e' nessuna, l'elenco resta vuoto come restava la vista.
     */
    $ct['view']['__restrict__']['id_emittente']['IN'] = implode( '|', array_column( (array) $ct['etc']['select']['id_emittenti'], 'id' ) );

    // inclusione filtri speciali
	$ct['etc']['include']['filters'] = 'inc/ddt.magazzini.view.filters.html';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';
