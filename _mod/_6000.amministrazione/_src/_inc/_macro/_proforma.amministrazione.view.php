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
	$ct['view']['table'] = 'note_proforma';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'proforma.amministrazione.form';

    // campi della vista
    $ct['view']['cols'] = array(
        'id' => '#',
        'nome' => 'nome',
        'data' => 'data',
        'emittente' => 'emittente',
        'destinatario' => 'destinatario'
    );

    // stili della vista
    $ct['view']['class'] = array(
        'nome' => 'text-left',
        'id' => 'text-left',
        'data' => 'text-left',
        'emittente' => 'text-left',
        'destinatario' => 'text-left'
    );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';
