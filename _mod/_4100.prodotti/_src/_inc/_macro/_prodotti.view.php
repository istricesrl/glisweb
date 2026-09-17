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

    /**
     * IL PRESET VALE SOLO DOVE LE PUBBLICAZIONI SI USANO DAVVERO ( 16/09/2026 )
     *
     * Su un deploy che non pubblica niente - il catalogo e' un'anagrafica interna e la tabella
     * pubblicazioni e' vuota - ogni riga ha id_tipologia_pubblicazione NULL, quindi il filtro
     * presettato sui pubblicati svuota l'elenco e la maschera si apre su "nessun dato trovato".
     * E' successo su bernispa il 16/09/2026, dove il cliente ha letto l'elenco vuoto come un
     * guasto e ha segnalato l'anagrafica articoli come irraggiungibile. Dove le pubblicazioni
     * ci sono, il comportamento non cambia di una virgola.
     */
    $ct['etc']['pubblicazioni'] = mysqlSelectValue(
        $cf['mysql']['connection'],
        'SELECT id FROM pubblicazioni LIMIT 1'
    );

    if( ! empty( $ct['etc']['pubblicazioni'] ) ) {
        $ct['view']['__filters__'] = array(
            'id_tipologia_pubblicazione' => array( 'IN' => $ct['etc']['pubblicate'] )
        );
    }

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
