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
	$ct['view']['table'] = 'ricevute_attive';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'ricevute.amministrazione.form';

    // tabella per la gestione degli oggetti esistenti
	$ct['view']['open']['table'] = 'documenti';

    // campi della vista
    $ct['view']['cols'] = array(
        'id' => '#',
        'numero' => 'num.',
        'sezionale' => 'sez.',
        'data' => 'data',
#        'emittente' => 'emittente',
        'destinatario' => 'cliente',
        'nome' => 'nome'
    );

    // stili della vista
	$ct['view']['class'] = array(
        'nome' => 'text-left',
        'data' => 'no-wrap',
        'nome' => 'text-left',
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
     * tendina destinatari — disattivata il 2026-09-10, non la legge nessun template
     *
     * Era `SELECT id, __label__ FROM anagrafica_view_static ORDER BY __label__` senza WHERE. Su un
     * deploy con l'anagrafica grande ( Polmasi: 55.372 righe ) sono circa 5 MB serializzati: oltre
     * il tetto di 1 MB di memcached, quindi la scrittura in cache fallisce con l'errore 37 e la
     * query — ordinamento compreso — si rifà a ogni apertura dell'elenco.
     *
     * La chiave `etc.select.id_destinatari` non compare nel template dei filtri di questa vista
     * ( `inc/ricevute.amministrazione.view.filters.html`, incluso qui sotto ): la lista veniva
     * costruita, ordinata e buttata. La `id_emittenti` qui sopra resta: è filtrata su
     * `se_gestita = 1` e sono poche righe.
     *
     * Se serve davvero una tendina sull'anagrafica, la strada è quella che il framework ha già:
     * `frm.selectBox()` con `populate-api="anagrafica"`, che rende un hidden e lascia cercare via
     * REST a `_src/_js/_lib/_selectbox.js` da tre caratteri in su.
     */

    // inclusione filtri speciali
	$ct['etc']['include']['filters'] = 'inc/ricevute.amministrazione.view.filters.html';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';
