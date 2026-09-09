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
	$ct['view']['table'] = 'articoli';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'articoli.form';

    // campi della vista
	$ct['view']['cols'] = array(
	    'id_prodotto' => 'prodotto',
        'id' => 'articolo',
	    'nome' => 'nome',
        'ean' => 'EAN',
	    'pubblicazione' => 'pubblicazione',
	    'tipologia_listino' => 'tipologia',
        NULL => 'azioni'
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

    /**
     * FILTRO PER TIPOLOGIA DI VOCE A LISTINO ( domanda 13 di Montanari )
     *
     * Le tre tipologie - macchina base, opzione, macchina configurata - sono le figlie della
     * caratteristica di radice "TIPO DI VOCE A LISTINO", creata dall'importazione dei listini
     * ( src/api/job/listini.importazione.php ). NON stanno in tipologie_prodotti, che e' l'albero
     * prodotto/servizio/alimentare del framework e su cui qui tutti i prodotti valgono 1.
     *
     * La tendina si popola da li' e non da un elenco scritto a mano: se un domani se ne aggiunge
     * una quarta, compare da sola.
     */
    $ct['etc']['select']['tipologie_listino'] = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT c.id, c.nome AS __label__ FROM caratteristiche_prodotti c '.
        'JOIN caratteristiche_prodotti r ON r.id = c.id_genitore '.
        'WHERE r.nome = ? ORDER BY c.nome',
        array( array( 's' => 'TIPO DI VOCE A LISTINO' ) )
    );

    // il riquadro dei filtri di questa vista
    $ct['etc']['include']['filters'] = 'inc/articoli.view.filters.html';

    // stili della vista
	$ct['view']['class'] = array(
	    'nome' => 'text-left',
	    'ean' => 'text-left',
	    'pubblicazione' => 'text-left',
	    'tipologia_listino' => 'text-left'
	);

    // javascript della vista
    $ct['view']['onclick'] = array(
        NULL => 'event.stopPropagation();'
    );

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // azioni
    foreach( $ct['view']['data'] as &$row ) {
        if( is_array( $row ) ) {
            $row[ NULL ] =  '<a href="#" onclick="$(this).metroWs(\'/task/4170.ecommerce/aggiungi.al.carrello?__carrello__[__articolo__][id_articolo]='.$row['id'].'\', aggiornaCarrello );"><span class="media-left"><i class="fa fa-cart-plus"></i></span></a>';
        }
    }
