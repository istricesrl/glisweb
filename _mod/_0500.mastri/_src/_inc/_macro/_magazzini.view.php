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
    $ct['view']['table'] = 'magazzini';

    // tabella per la gestione degli oggetti esistenti
	$ct['view']['open']['table'] = 'mastri';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'magazzini.form';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        '__label__' => 'nome',
        'anagrafica' => 'anagrafica',
        'indirizzo' => 'indirizzo'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'id' => 'text-center d-md-table-cell',
        '__label__' => 'text-left',
        'anagrafica' => 'text-left',
        'indirizzo' => 'text-left'
    );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

   