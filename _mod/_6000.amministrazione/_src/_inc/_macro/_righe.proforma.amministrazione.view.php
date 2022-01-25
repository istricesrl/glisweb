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
    $ct['view']['table'] = 'righe_proforma';
    

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'proforma.amministrazione.righe.form';
    $ct['view']['open']['table'] = 'documenti_articoli';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'data' => 'data',
        'documento' => 'documento',
    #    'tipologia' => 'tipologia',
        'nome' => 'nome',
        'id_articolo' => 'articolo',
        'quantita' => 'quantità',
		'mastro_provenienza' => 'provenienza',
		'mastro_destinazione' => 'destinazione',
        'importo_netto_totale' => 'importo'
    #    'totale_riga' => 'totale',
	);

    // stili della vista
	$ct['view']['class'] = array(
        'nome' => 'text-left',
        'importo_netto_totale' => 'text-right',
        'quantita' => 'text-right',     
        'totale_riga' => 'text-right',
        'cliente' => 'text-left',
        'emittente' => 'text-left', 
        'data_lavorazione' => 'text-left', 
        'tipologia' => 'text-left',
        'specifiche' => 'text-left',
        'data_lavorazione' => 'no-wrap',
        'documento' => 'text-left no-wrap'
    );

      // inclusione filtri speciali
	$ct['etc']['include']['filters'] = 'inc/documenti.articoli.view.filters.html';

    // tendina categoria
	$ct['etc']['select']['tipologie_documenti'] = mysqlCachedQuery(
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_documenti_view'
	);

     // tendina mittenti
	$ct['etc']['select']['id_emittenti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view_static WHERE se_gestita = 1'
	);

    // tendina destinatari
	$ct['etc']['select']['id_destinatari'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view_static WHERE se_cliente = 1'
	);

    // tendina articoli
	$ct['etc']['select']['id_articoli'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM articoli_view'
	);

    // tendina listini
	$ct['etc']['select']['id_listini'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM listini_view'
	);


    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

   