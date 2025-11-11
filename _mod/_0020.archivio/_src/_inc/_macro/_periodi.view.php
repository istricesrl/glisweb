<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */

    // tabella della vista
	$ct['view']['table'] = 'periodi';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'periodi.form';

     // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
        'tipologia' => 'tipologia',
        '__label__' => 'nome',
        'data_inizio' => 'data inizio',
        'data_fine' => 'data fine'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
        '__label__' => 'text-left',
        'tipologia' => 'text-left',
        'data_inizio' => 'text-left',
        'data_fine' => 'text-left'
	);
   
    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';
