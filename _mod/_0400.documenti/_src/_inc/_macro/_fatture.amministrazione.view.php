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
	$ct['view']['table'] = 'fatture';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'fatture.amministrazione.form';

    // tabella per la gestione degli oggetti esistenti
	$ct['view']['open']['table'] = 'documenti';

    // campi della vista
    $ct['view']['cols'] = array(
        'id' => '#',
        'numero' => 'num.',
        'sezionale' => 'sez.',
        'data' => 'data',
        'emittente' => 'emittente',
        'destinatario' => 'destinatario',
        'nome' => 'nome'
    );

    // stili della vista
	$ct['view']['class'] = array(
        'nome' => 'text-left',
        'data' => 'no-wrap',
        'nome' => 'text-left',
        'destinatario' => 'text-left',
        'emittente' => 'text-left',
        'tipologia' => 'text-left',
        'totale' => 'text-right' 
    );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';