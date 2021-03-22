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
    $ct['view']['table'] = 'documenti';
    
    // id della vista
    $ct['view']['id'] = md5( $ct['view']['table'] );

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'documenti.form';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'numero' => 'numero',
        'data' => 'data',
        '__label__' => 'nome'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'nome' => 'text-left',
        'numero' => 'text-left',
        'data' => 'text-left',
        '__label__' => 'text-left',
    );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

   