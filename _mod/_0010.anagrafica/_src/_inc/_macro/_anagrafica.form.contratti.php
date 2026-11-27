<?php

    /**
     * macro form anagrafica
     *
     *
     *
     * -# definizione della tabella del modulo
     * -# popolazione delle tendine
     *
     *
     *
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'anagrafica';

    // tabella della vista
    // contratti_completa non esiste piu' in nessuno schema ( canone punto 8, 24/11/2026 ): il legame contratto-anagrafica sta in
    // contratti_anagrafica, e contratti_anagrafica_view ha id_anagrafica per il filtro e id_contratto per l'apertura
    // $ct['view']['table'] = 'contratti_completa';
    $ct['view']['table'] = 'contratti_anagrafica_view';

    // tabella per la gestione
    $ct['view']['open']['table'] = 'contratti';
    $ct['view']['open']['field'] = 'id_contratto';

     // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'data_inizio' => 'data inizio',
        'data_fine' => 'data fine',
//        'data_inizio_rapporto' => 'data inizio rapporto',
//        'data_fine_rapporto' => 'data fine rapporto',
        'ruolo' => 'ruolo',
	    '__label__' => 'contratto'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    '__label__' => 'text-left no-wrap'
    );
    
    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'contratti.form';
    $ct['view']['insert']['page'] = 'contratti.form';

    // campo per il preset di apertura
	$ct['view']['open']['preset']['field'] = 'id_anagrafica';
//    $ct['view']['open']['preset']['subform'] = 'contratti';
    

    // preset filtro custom
    $ct['view']['__restrict__']['id_anagrafica']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
    
    // macro di default per la vista
    require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default per l'entità anagrafica
    require DIR_MOD . '_0010.anagrafica/_src/_inc/_macro/_anagrafica.form.default.php';

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
