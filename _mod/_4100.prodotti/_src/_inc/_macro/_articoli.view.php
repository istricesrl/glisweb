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
     * ALLA VISTA NON SI CHIEDONO COLONNE CHE LA VISTA NON HA ( 17/09/2026 )
     *
     * Le colonne nuove di questo elenco - la pubblicazione, e la tipologia di voce a listino - sono arrivate fra l'8 e il
     * 16/09/2026 insieme alle viste che le espongono. Un deploy le cui viste sono piu' vecchie
     * quelle colonne non le ha, ma il controller costruisce lo stesso la SELECT su articoli_view
     * chiedendogliele, e MySQL risponde
     *
     *     Unknown column 'id_tipologia_pubblicazione' in 'where clause'
     *
     * cioe' l'elenco non si apre affatto. Non e' un caso di scuola: su gimbe, il 17/09/2026,
     * alla vista mancavano pubblicazione, tipologia_listino e id_tipologia_pubblicazione, e le due
     * maschere del catalogo erano inservibili.
     *
     * Qui si chiede alla vista che colonne abbia davvero e si tolgono dall'elenco quelle che non
     * ci sono, invece di tenere a mano la lista di quali deploy sono indietro. Dove la vista e'
     * allineata non cambia niente; dove non lo e', l'elenco perde una colonna e si apre.
     *
     * E' schema e non dato, quindi si chiede a memcache con un'ora di TTL, come fa il controller
     * per l'indice SORTING. Il TTL e' esplicito perche' dove MEMCACHE_DEFAULT_TTL vale 0 uno
     * schema resterebbe in cache per sempre e non si riallineerebbe piu' dopo una migrazione.
     *
     * Se la domanda non si puo' fare - memcache o il database non rispondono - non si pota
     * niente e si fa come prima: meglio l'errore di prima che un elenco svuotato da un guasto
     * di contorno. La chiave vuota di $ct['view']['cols'] e' la colonna delle azioni, che nel
     * database non esiste e non va cercata.
     */
    $colonneVista = mysqlCachedQuery(
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SHOW COLUMNS FROM ' . $ct['view']['table'] . '_view',
        false,
        3600
    );

    if( is_array( $colonneVista ) && count( $colonneVista ) ) {

        $ct['etc']['colonne'] = array_column( $colonneVista, 'Field' );

        foreach( $ct['view']['cols'] as $colonna => $etichetta ) {
            if( $colonna !== '' && ! in_array( $colonna, $ct['etc']['colonne'] ) ) {
                unset( $ct['view']['cols'][ $colonna ] );
            }
        }

    } else {

        $ct['etc']['colonne'] = array_merge(
            array_keys( $ct['view']['cols'] ),
            array( 'id_tipologia_pubblicazione', 'tipologia_listino' )
        );

    }

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

    if( ! empty( $ct['etc']['pubblicazioni'] )
        && in_array( 'id_tipologia_pubblicazione', $ct['etc']['colonne'] ) ) {
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
