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
    $ct['view']['table'] = 'conti';

    // tabella per la gestione degli oggetti esistenti
	$ct['view']['open']['table'] = 'mastri';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'conti.form';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        '__label__' => 'nome'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'id' => 'text-center d-md-table-cell',
        '__label__' => 'text-left'
    );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

   