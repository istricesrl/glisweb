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

    // tendina destinatari
	$ct['etc']['select']['id_destinatari'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view_static ORDER BY __label__'
	);

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
