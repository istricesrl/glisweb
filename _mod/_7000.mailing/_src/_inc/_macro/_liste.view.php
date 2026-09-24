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
	$ct['view']['table'] = 'liste';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'liste.form';

    // campi della vista
    $ct['view']['cols'] = array(
        'id' => '#',
        '__label__' => 'nome'
    );

    // stili della vista
    $ct['view']['class'] = array(
        '__label__' => 'text-left'
    );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';
