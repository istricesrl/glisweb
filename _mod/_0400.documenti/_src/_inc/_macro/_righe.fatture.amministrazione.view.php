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
    $ct['view']['table'] = 'righe_fatture_attive';

    $ct['view']['open']['page'] = 'righe.fatture.amministrazione.form';
    $ct['view']['open']['table'] = 'documenti_articoli';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'data' => 'data',
        'documento' => 'documento',
        'destinatario' => 'cliente',
        'nome' => 'nome',
#        'id_articolo' => 'articolo',
        'quantita' => 'quantità',
#		'mastro_provenienza' => 'provenienza',
#		'mastro_destinazione' => 'destinazione',
        'importo_netto_totale' => 'importo'
    #    'totale_riga' => 'totale',
	);

    // stili della vista
	$ct['view']['class'] = array(
        'nome' => 'text-left',
        'importo_netto_totale' => 'text-right',
        'quantita' => 'text-right',     
        'data' => 'no-wrap', 
        'totale_riga' => 'text-right',
        'destinatario' => 'text-left',
        'emittente' => 'text-left', 
        'data_lavorazione' => 'text-left', 
        'tipologia' => 'text-left',
        'specifiche' => 'text-left',
        'data_lavorazione' => 'no-wrap',
        'documento' => 'text-left no-wrap'
    );

	// RELAZIONI CON IL MODULO MASTRI
	if( in_array( "0500.mastri", $cf['mods']['active']['array'] ) ) {
		arrayInsertAssoc( 'nome', $ct['view']['cols'], array( 'mastro_provenienza' => 'scarico', 'mastro_destinazione' => 'carico' ) );
	}

	// RELAZIONI CON IL MODULO PRODOTTI
	if( in_array( "4100.prodotti", $cf['mods']['active']['array'] ) ) {
		arrayInsertAssoc( 'nome', $ct['view']['cols'], array( 'id_articolo' => 'articolo' ) );
	}

    // inclusione filtri speciali
	$ct['etc']['include']['filters'] = 'inc/righe.fatture.amministrazione.view.filters.html';

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

   