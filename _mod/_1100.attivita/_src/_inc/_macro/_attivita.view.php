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

    // debug
	// print_r( $_SESSION );

    // tabella della vista
	$ct['view']['table'] = 'attivita';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'attivita.form';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'data' => 'data',
        'anagrafica' => 'persona',
        'id_anagrafica' => 'id_anagrafica',
        'cliente' => 'cliente',
        'nome' => 'attivita',
        'ore' => 'ore',
        '__label__' => 'tipologia',
        'testo' => 'dettagli'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'id' => 'd-none d-md-table-cell',
        'id_anagrafica' => 'd-none',
        'anagrafica' => 'no-wrap',
        'cliente' => 'text-left d-none d-md-table-cell',
        'data' => 'no-wrap',
        'ore' => 'text-right no-wrap',
        'nome' => 'text-left',
        '__label__' => 'text-left',
        'testo' => 'text-left no-wrap'
	);

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

   