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
	$ct['view']['table'] = 'prodotti';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'prodotti.form';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => 'prodotto',
        'nome' => 'nome',
	    'codice_produttore' => 'codice produttore',
	    'categorie' => 'categorie',
	    'pubblicazione' => 'pubblicazione'
	);
    /**
     * FILTRO PER PUBBLICAZIONE, CON I PUBBLICATI IN PARTENZA
     * =======================================================
     *
     * Chiesto da Montanari l'08/09/2026: negli elenchi mancava un filtro per pubblicazione, e di
     * default si volevano vedere le macchine pubblicate.
     *
     * Il filtro presettato di $ct['view']['__filters__'] vale SOLO finche' l'utente non ne sceglie
     * uno suo ( _src/_inc/_macro/_default.view.php ), quindi la vista si apre sui pubblicati ma
     * resta libera: chi vuole gli archiviati o tutti li sceglie dalla tendina e la scelta gli
     * resta in sessione.
     *
     * "pubblicati" sono due tipologie, pubblicato e in evidenza, quindi il filtro usa l'operatore
     * IN e non EQ: i valori si passano separati da | ( _src/_lib/_controller.tools.php riga 494 ).
     */
    $ct['etc']['pubblicate'] = implode(
        '|',
        mysqlSelectColumn(
            'id',
            $cf['mysql']['connection'],
            'SELECT id FROM tipologie_pubblicazioni WHERE se_pubblicato = 1 OR se_evidenza = 1 ORDER BY id'
        )
    );

    $ct['view']['__filters__'] = array(
        'id_tipologia_pubblicazione' => array( 'IN' => $ct['etc']['pubblicate'] )
    );

    $ct['etc']['select']['tipologie_pubblicazioni'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM tipologie_pubblicazioni_view'
    );

    $ct['etc']['select']['categorie_prodotti'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM categorie_prodotti_view ORDER BY __label__'
    );

    // il riquadro dei filtri di questa vista
    $ct['etc']['include']['filters'] = 'inc/prodotti.view.filters.html';

    // stili della vista
	$ct['view']['class'] = array(
	    'codice_produttore' => 'text-left',
	    'categorie' => 'text-left',
	    'nome' => 'text-left',
	    'pubblicazione' => 'text-left'
	);

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';
