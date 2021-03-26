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
	$ct['view']['table'] = 'attivita_scoperte';

    // tabella per la gestione degli oggetti esistenti
#	$ct['view']['open']['table'] = '';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'attivita.scoperte.form';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'data_attivita' => 'data',
        'data_programmazione' => 'data pianificazione',
        'anagrafica' => 'persona',
        'cliente' => 'cliente',
        'progetto' => 'progetto',
        'nome' => 'attivita',
        'ore' => 'ore',
        'tipologia_inps' => 'tipologia INPS',
        '__label__' => 'tipologia'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'id' => 'd-none d-md-table-cell',
        'cliente' => 'text-left d-none d-md-table-cell',
        '__label__' => 'text-left'
    );
 

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

   