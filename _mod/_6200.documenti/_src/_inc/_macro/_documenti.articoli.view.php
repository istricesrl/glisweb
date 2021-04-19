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
    $ct['view']['table'] = 'documenti_articoli';
    
    // id della vista
    $ct['view']['id'] = md5( $ct['view']['table'] );

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'documenti.articoli.form';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'tipologia' => 'tipologia',
        'data_lavorazione' => 'data',
        'nome' => 'nome',
        'importo_netto_totale' => 'importo',
        'quantita' => 'quantità',
        'documento' => 'documento',
        'cliente' => 'cliente',
        'emittente' => 'emittente', 
	);

    // stili della vista
	$ct['view']['class'] = array(
        'nome' => 'text-left',
        'importo_netto_totale' => 'text-left',
        'quantita' => 'text-left',
        'documento' => 'text-left',
        'cliente' => 'text-left',
        'emittente' => 'text-left', 
        'data_lavorazione' => 'text-left', 
        'tipologia' => 'text-left'
    );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

   